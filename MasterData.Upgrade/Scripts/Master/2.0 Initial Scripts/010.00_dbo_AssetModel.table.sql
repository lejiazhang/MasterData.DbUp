BEGIN TRY

	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  

	DROP TABLE IF EXISTS tempdb.dbo.#TEMP_AssetModel
	CREATE TABLE #TEMP_AssetModel
	(
		[ID_Old] [int] NULL,
		[ActiveIND_Old] [bit] NULL,
		[CarNameEN_Old] [nvarchar](200) NULL,
		[AssetModelExternalID_Old] [int] NULL,
		[ActionTaken] nvarchar(10),
		[ID] [int] NULL,
		[ActiveIND] [bit] NULL,
		[CarNameEn] [nvarchar](200) NULL,
		[AssetModelExternalID] [int] NULL
	);  

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[AssetModel] AS Target
	USING
	(
		SELECT [MODL_ID], [NME], [ACT_IND]
		FROM [dbo].[ASET_MODL_CODE]
	)
	AS [Source] ([MODL_ID], [NME], [ACT_IND]) 
		ON 
		(
			[Target].[AssetModelExternalID] = [Source].[MODL_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[CarNameEN] = [Source].[NME],
			[Target].[ActiveIND] = [Source].[ACT_IND]

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetModelExternalID], [CarNameEN], [ActiveIND], [ModifiedDate], [ModifiedBy])
		VALUES ([Source].[MODL_ID], [Source].[NME], [Source].[ACT_IND], GETDATE(), N'Initial')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT
		deleted.[ID], deleted.[ActiveIND], deleted.[CarNameEn], deleted.[AssetModelExternalID],
		$action,
		inserted.[ID], inserted.[ActiveIND], inserted.[CarNameEn], inserted.[AssetModelExternalID]
	INTO #TEMP_AssetModel;

	PRINT 'AssetModel merge script ran successfully.'
END TRY
BEGIN CATCH
	--  SELECT  
    --  ERROR_NUMBER() AS ErrorNumber  
    -- ,ERROR_SEVERITY() AS ErrorSeverity  
    -- ,ERROR_STATE() AS ErrorState  
    -- ,ERROR_PROCEDURE() AS ErrorProcedure  
    -- ,ERROR_LINE() AS ErrorLine  
    -- ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.AssetModel.Table.sql.'

END CATCH;