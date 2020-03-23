/*
This script populates the following table:

-----------------------------------------------------------------------------------------------------
AssetModelCompany
-----------------------------------------------------------------------------------------------------

It has key(s) into the following table(s), which need to be populated first with correct keys:

-----------------------------------------------------------------------------------------------------
AssetModel, AssetModelYearPrice
-----------------------------------------------------------------------------------------------------
*/

BEGIN TRY
	
	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  

	IF OBJECT_ID('tempdb..#TEMP_AssetModelCompany') IS NOT NULL DROP TABLE #TEMP_AssetModelCompany
	CREATE TABLE #TEMP_AssetModelCompany
	(
		[AssetModelId_Old] [int] NULL,
		[AssetModelExtId_Old] [int] NULL,
		[AssetModelExtDetailId_Old] [int] NULL,
		[NST_Old] [nvarchar](20) NULL,
		[ModelYear_Old] [int] NULL,
		[ActionTaken] nvarchar(10),
		[AssetModelId] [int] NULL,
		[AssetModelExtId] [int] NULL,
		[AssetModelExtDetailId] [int] NULL,
		[NST] [nvarchar](20) NULL,
		[ModelYear] [int] NULL
	);  

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[AssetModelCompany] AS Target
	USING
	(
		SELECT  [ASET_MODL_CODE_DET].[MODL_DET_ID], [ASET_MODL_CODE_DET].[MODL_YEAR_TYPE_ID], [ASET_MODL_CODE_DET].[EXTR_CODE] AS [NST], 2 AS [CompanyId],
				[ASET_MODL_CODE].[MODL_ID], [ASET_MODL_CODE].[MAKE_TYPE_ID], [ASET_MODL_CODE].[ASET_TYPE_ID], [ASET_MODL_CODE].[ASET_SBTP_ID], 
				[ASET_MODL_CODE].[BRND_TYPE_ID], [ASET_MODL_CODE].[BLAZ_TYPE_ID], [ASET_MODL_CODE].[EXTR_CODE] AS [MODL_DET_ASCENT_ID],
				(CASE  WHEN ISNUMERIC(SUBSTRING([ASET_MODL_CODE_DET].[EXTR_CODE], 0, 7)) = 1
						THEN SUBSTRING([ASET_MODL_CODE_DET].[EXTR_CODE], 0, 7)
						ELSE NULL
				END) AS [BAU_MASTER_ID], [AssetModel].[ID] AS [AssetModelId]
		FROM [dbo].[ASET_MODL_CODE_DET] 
		JOIN [ASET_MODL_CODE] ON [ASET_MODL_CODE_DET].[MODL_ID] = [ASET_MODL_CODE].[MODL_ID]
		--JOIN [dbo].[AssetModelYearPrice] ON 
		JOIN [dbo].[AssetModel] ON [ASET_MODL_CODE].[MODL_ID] = [AssetModel].[AssetModelExternalID]
	)
	AS [Source] 
		(
			[MODL_DET_ID], [MODL_YEAR_TYPE_ID], [NST], [CompanyId], [MODL_ID], [MAKE_TYPE_ID], [ASET_TYPE_ID], 
			[ASET_SBTP_ID], [BRND_TYPE_ID], [BLAZ_TYPE_ID], [MODL_DET_ASCENT_ID], [BAU_MASTER_ID], [AssetModelId]
		) 
		ON 
		(
			[Target].[AssetModelExtDetailId] = [Source].[MODL_DET_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ModelYear] = [Source].[MODL_YEAR_TYPE_ID],
			[Target].[NST] = [Source].[NST],
			[Target].[AssetMakeID] = [Source].[MAKE_TYPE_ID],
			[Target].[AssetTypeID] = [Source].[ASET_TYPE_ID],
			[Target].[AssetSubTypeID] = [Source].[ASET_SBTP_ID],
			[Target].[AssetBrandTypeID] = [Source].[BRND_TYPE_ID],
			[Target].[AssetBlazeTypeID] = [Source].[BLAZ_TYPE_ID],
			[Target].[AssetModelAscentID] = [Source].[MODL_DET_ASCENT_ID],
			[Target].[BaumasterID] = [Source].[BAU_MASTER_ID]

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([ID], [AssetModelExtID], [AssetModelID], [CompanyID],[AssetMakeID],[AssetTypeID],[AssetSubTypeID],[AssetBrandTypeID],
				[AssetBlazeTypeID],[NST],[BaumasterID],[ModelYear],[AssetModelAscentID],[AssetModelExtDetailId])

		VALUES ([Source].[MODL_DET_ID],[Source].[MODL_ID],[Source].[AssetModelId],'$CompanyId$',[Source].[MAKE_TYPE_ID], [Source].[ASET_TYPE_ID],
				[Source].[ASET_SBTP_ID], [Source].[BRND_TYPE_ID], [Source].[BLAZ_TYPE_ID], [Source].[NST],  [Source].[BAU_MASTER_ID],
				[Source].[MODL_YEAR_TYPE_ID], [Source].[MODL_DET_ASCENT_ID], [Source].[MODL_DET_ID])

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT
		deleted.[AssetModelId], deleted.[AssetModelExtID], deleted.[AssetModelExtDetailId], deleted.[NST], deleted.[ModelYear],
		$action,
		inserted.[AssetModelId], inserted.[AssetModelExtID], inserted.[AssetModelExtDetailId], inserted.[NST], inserted.[ModelYear]
	INTO #TEMP_AssetModelCompany;

	PRINT 'AssetModelCompany merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.AssetModelCompany.Table.sql.'

END CATCH;

/*
	Test sql for view merged conflict.
*/
-- select * from #TEMP_AssetModelCompany where ActionTaken = 'DELETE'
-- select * from STAGING_DB_LC..ASET_MODL_CODE_DET where MODL_DET_ID in (select AssetModelExtDetailId_Old from #TEMP_AssetModelCompany where ActionTaken = 'DELETE')
-- select * from AssetModelCompany where AssetModelExtDetailId IN (select AssetModelExtDetailId_Old from #TEMP_AssetModelCompany where ActionTaken = 'DELETE')
-- select * from AssetModel where AssetModelExternalID in (select AssetModelId_Old from #TEMP_AssetModelCompany where ActionTaken = 'DELETE')
-- select * from NPOS_PROD_Master_Data_Service..AssetModelCompany where CompanyID = 1 and AssetModelExtDetailId IN ( select AssetModelExtDetailId_Old from #TEMP_AssetModelCompany where ActionTaken = 'DELETE')
