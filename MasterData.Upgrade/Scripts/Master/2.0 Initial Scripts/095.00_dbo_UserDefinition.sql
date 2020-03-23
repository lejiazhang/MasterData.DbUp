BEGIN TRY

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

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_AFC
	MERGE INTO [dbo].[UserDefinition] AS Target
	USING
	(
		SELECT SYS_USR_ID, USR_LOGN_ID, ltrim(rtrim(REPLACE(USR_FIRT_NME, ' ', ''))) + ' '+ ltrim(rtrim(REPLACE(USR_LAST_NME, ' ', ''))) as BP_Name, DEPT_ID, DSIG_ID, LANG_ID, USR_EMAL, ACT_IND, 1 as Company_ID
		FROM [dbo].[UMS_SYS_USR]
	)
	AS [Source] (SYS_USR_ID, USR_LOGN_ID, BP_Name, DEPT_ID, DSIG_ID, LANG_ID, USR_EMAL, ACT_IND,Company_ID) 
		ON 
		(
			[Target].[UserName] = [Source].USR_LOGN_ID and
			[Target].[CompanyID] = [Source].Company_ID
		)

	WHEN MATCHED THEN
		-- row found in target: udpate existing rows
		UPDATE SET 
			[Target].[CHILDID] = [Source].SYS_USR_ID,
			[Target].[BPINDIVIDUALID] = [Source].SYS_USR_ID,
			[Target].[BPName] = [Source].BP_Name,
			[Target].[DEPARTMENTID] = [Source].DEPT_ID,
			[Target].[DESIGNATIONID] = [Source].DSIG_ID,
			[Target].[LANGUAGEID] = [Source].LANG_ID,
			[Target].[POSUserEmail] = [Source].USR_EMAL,
			[Target].[ACTIVEIND] = [Source].ACT_IND

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows in target
		INSERT (UserID, CompanyID, UserName, [BPName], BpIndividualID, DepartmentID, DesignationID, LanguageID, PosUserEmail, ActiveInd)
		VALUES ([Source].USR_LOGN_ID, '$CompanyId$', [Source].USR_LOGN_ID, [Source].BP_Name, [Source].SYS_USR_ID
				,[Source].DEPT_ID, [Source].DSIG_ID, [Source].LANG_ID, [Source].USR_EMAL, [Source].ACT_IND)

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT
		deleted.[CHILDID], deleted.[BPINDIVIDUALID], deleted.[USERNAME], deleted.[BPName], deleted.[DEPARTMENTID], deleted.[DESIGNATIONID], deleted.[LANGUAGEID], deleted.[POSUserEmail], deleted.[ACTIVEIND],
		$action,
		inserted.[CHILDID], inserted.[BPINDIVIDUALID], inserted.[USERNAME], inserted.[BPName], inserted.[DEPARTMENTID], inserted.[DESIGNATIONID], inserted.[LANGUAGEID], inserted.[POSUserEmail], inserted.[ACTIVEIND]
	INTO #TEMP_UserDefinition;

	PRINT 'UserDefinition merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.UserDefinition.Table.sql'
 
END CATCH;

--select * from NPOS_PROD_Master_AFC.dbo.UserDefinition where not exists (select * from STAGING_DB_AFC.dbo.UMS_SYS_USR where UserName = USR_LOGN_ID)
--select * from STAGING_DB_AFC.dbo.UMS_SYS_USR where not exists (select * from NPOS_PROD_Master_AFC.dbo.UserDefinition  where UserName = USR_LOGN_ID)