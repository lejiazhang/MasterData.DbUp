BEGIN TRY
	-- Clear data
	TRUNCATE TABLE [dbo].[LookupDetail]

	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  
	IF OBJECT_ID ('TEMPDB..#TEMP_LookupDetail') IS NOT NULL
		DROP TABLE #TEMP_LookupDetail
		 
	CREATE TABLE #TEMP_LookupDetail
	(
		[LookupMainID_Old] int NULL,
		[LookupDetailID_Old] numeric(11,0) null,
		[ExternalCode_Old] nvarchar(200) null,
		[Narration_Old] nvarchar (510) NULL,
		[CompanyID_Old] tinyint null,
		[ParentID_Old] numeric(11,0) null,
		[ActiveInd_Old] bit NULL,
		[FIMLOOKUPDETAILID_Old] int null, 
		[ActionTaken] nvarchar(10),
		[LookupMainID] int NULL,
		[LookupDetailID] numeric(11,0) null,
		[ExternalCode] nvarchar(200) null,
		[Narration] nvarchar (510) NULL,
		[CompanyID] tinyint null,
		[ParentID] numeric(11,0) null,
		[ActiveInd] bit NULL,
		[FIMLOOKUPDETAILID] int null
	);  

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_AFC
	MERGE INTO [dbo].[LookupDetail] AS Target
	USING
	(
 

		SELECT [LKUP_DET].LKUP_MAIN_ID, [LKUP_DET].LKUP_DET_ID, [LKUP_DET].EXTR_CODE, LKUP_DET.NME as NARRATION,
				CMPY_ID as [CompanyID], PRNT_ID as [ParentID], ACT_IND as [ActiveInd], max(LookupDetailFIM.LookupDetailID) as [FIMLOOKUPDETAILID]
		FROM [STAGING_DB_AFC].[dbo].[LKUP_DET]
		inner join [dbo].LookupMain on [LKUP_DET].LKUP_MAIN_ID = LookupMain.LookupMainID
		left join dbo.LookupDetailFIM on LookupMain.FIMLOOKUPMAINID = LookupDetailFIM.LookupMainID
		and [LKUP_DET].EXTR_CODE = LookupDetailFIM.ExternalCode and  LookupDetailFIM.companyid = '$CompanyId$'-- LKUP_MAIN_ID = 2582 and LKUP_DET_ID = 1075 
		group by  [LKUP_DET].LKUP_MAIN_ID, [LKUP_DET].LKUP_DET_ID, [LKUP_DET].EXTR_CODE, LKUP_DET.NME ,
				CMPY_ID , PRNT_ID , ACT_IND  
 
 -- select * from [NPOS_PROD_Master_AFC].[dbo].[LookupDetail] where   exists (select * from [STAGING_DB_AFC].[dbo].[LKUP_DET]
 
 --where [LookupMainID] =  [LKUP_MAIN_ID] and [LookupDetailID] =  [LKUP_DET_ID])

		--select * from [STAGING_DB_AFC].[dbo].[LKUP_DET] where  LKUP_MAIN_ID = 2582  and LKUP_DET_ID = 1075
		--select * from [NPOS_PROD_Master_AFC].dbo.LookupDetailFIM where LookupDetailID = 6708
		--select * from [NPOS_PROD_Master_AFC].dbo.LookupDetailFIM where LookupDetailID = 6217 or LookupDetailID = 8194
		--select * from [NPOS_PROD_Master_AFC].dbo.LookupDetailFIM where lookupmainid = 26 and companyid= 1 and externalcode = '1075'
		
		--SELECT  [LKUP_DET].LKUP_MAIN_ID, [LKUP_DET].LKUP_DET_ID, count(1)
		--FROM [STAGING_DB_AFC].[dbo].[LKUP_DET]
		--inner join [NPOS_PROD_Master_AFC].[dbo].LookupMain on [LKUP_DET].LKUP_MAIN_ID = LookupMain.LookupMainID
		--left join [NPOS_PROD_Master_AFC].dbo.LookupDetailFIM on LookupMain.FIMLOOKUPMAINID = LookupDetailFIM.LookupMainID
		--and [LKUP_DET].EXTR_CODE = LookupDetailFIM.ExternalCode and LookupDetailFIM.companyid = 1
		--group by [LKUP_DET].LKUP_MAIN_ID, [LKUP_DET].LKUP_DET_ID having  count(1) >1

		--select * from [STAGING_DB_AFC].[dbo].[LKUP_DET]
		--inner join [NPOS_PROD_Master_AFC].[dbo].LookupMain on [LKUP_DET].LKUP_MAIN_ID = LookupMain.LookupMainID
	)
	AS [Source] (LKUP_MAIN_ID, LKUP_DET_ID, EXTR_CODE, NARRATION, [CompanyID], [ParentID], [ActiveInd], [FIMLOOKUPDETAILID]) 
		ON 
		(
			[Target].[LookupMainID] = [Source].[LKUP_MAIN_ID] and
			[Target].[LookupDetailID] = [Source].[LKUP_DET_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET 
			[Target].[LookupMainID] = [Source].LKUP_MAIN_ID,
			[Target].[LookupDetailID] = [Source].LKUP_DET_ID,
			[Target].[ExternalCode] = [Source].EXTR_CODE,
			[Target].[Narration] = [Source].NARRATION,
			[Target].[CompanyID] = '$CompanyId$',
			[Target].[ParentID] = [Source].[ParentID],
			[Target].[ActiveInd] = [Source].[ActiveInd],
			[Target].[FIMLOOKUPDETAILID] = [Source].[FIMLOOKUPDETAILID]

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT (LookupMainID, LookupDetailID, ExternalCode, Narration,CompanyID,ParentID,ActiveInd,FIMLOOKUPDETAILID)
		VALUES ([Source].LKUP_MAIN_ID, [Source].LKUP_DET_ID, [Source].EXTR_CODE, [Source].NARRATION
				, '$CompanyId$', [Source].[ParentID], [Source].[ActiveInd], [Source].[FIMLOOKUPDETAILID])

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT
		deleted.LookupMainID, deleted.LookupDetailID, deleted.ExternalCode, deleted.Narration, deleted.CompanyID, deleted.ParentID, deleted.ActiveInd, deleted.FIMLOOKUPDETAILID,
		$action,
		inserted.LookupMainID, inserted.LookupDetailID, inserted.ExternalCode, inserted.Narration, inserted.CompanyID, inserted.ParentID, inserted.ActiveInd, inserted.FIMLOOKUPDETAILID
	INTO #TEMP_LookupDetail;

	PRINT 'Lookupdetail merge script ran successfully.'
END TRY
BEGIN CATCH
	--  SELECT  
    --  ERROR_NUMBER() AS ErrorNumber  
    -- ,ERROR_SEVERITY() AS ErrorSeverity  
    -- ,ERROR_STATE() AS ErrorState  
    -- ,ERROR_PROCEDURE() AS ErrorProcedure  
    -- ,ERROR_LINE() AS ErrorLine  
    -- ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.Lookupdetail.Table.sql'

END CATCH;