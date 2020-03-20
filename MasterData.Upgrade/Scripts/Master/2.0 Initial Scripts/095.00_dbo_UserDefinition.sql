BEGIN TRY
	-- Clear data
	TRUNCATE TABLE [dbo].[UserDefinition]

	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  
	IF OBJECT_ID ('TEMPDB..#TEMP_UserDefinition') IS NOT NULL
		DROP TABLE #TEMP_UserDefinition
		 
	CREATE TABLE #TEMP_UserDefinition
	(
		[CHILDID_Old] int NULL,
		[BPINDIVIDUALID_Old] int null,
		[USERNAME_Old] nvarchar(20) null,
		[BPName_Old] nvarchar (400) NULL,
		[DEPARTMENTID_Old] numeric(11,0) null,
		[DESIGNATIONID_Old] numeric(11,0) null,
		[LANGUAGEID_Old] numeric(11,0) NULL,
		[POSUserEmail_Old] varchar(50) null, 
		[ACTIVEIND_Old] bit null, 
		[ActionTaken] nvarchar(10),
		[CHILDID] int NULL,
		[BPINDIVIDUALID] int null,
		[USERNAME] nvarchar(20) null,
		[BPName] nvarchar (400) NULL,
		[DEPARTMENTID] numeric(11,0) null,
		[DESIGNATIONID] numeric(11,0) null,
		[LANGUAGEID] numeric(11,0) NULL,
		[POSUserEmail] varchar(50) null, 
		[ACTIVEIND] bit null, 
	);  

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[UserDefinition] AS Target
	USING
	(
		SELECT SYS_USR_ID, USR_LOGN_ID, USR_FIRT_NME + ' ' + USR_LAST_NME as BP_Name, DEPT_ID, DSIG_ID, LANG_ID, USR_EMAL, ACT_IND
		FROM [dbo].[UMS_SYS_USR]
	)
	AS [Source] (SYS_USR_ID, USR_LOGN_ID, BP_Name, DEPT_ID, DSIG_ID, LANG_ID, USR_EMAL, ACT_IND) 
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