BEGIN TRY

	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  
	IF OBJECT_ID('tempdb..#TEMP_BusinessPartnerCompany') IS NOT NULL DROP TABLE #TEMP_BusinessPartnerCompany

	CREATE TABLE #TEMP_BusinessPartnerCompany
	(
		[BusinessPartnerID_Old] [int] NULL,
		[CompanyName_Old] [nvarchar](200) NULL,
		[ClassificationCDE_Old] [int] NULL,
		[IndustryTypeCDE_Old] [int] NULL,
		[IndustrySubtypeCDE_Old] [int] NULL,
		[RegistrationDate_Old] [datetime] NULL,
		[LoanGradeCDE_Old] [int] NULL,
		[BusinessTypeCDE_Old] [char] (5) NULL,
		[CompanyNbr_Old] [nvarchar] (200) NULL,
		[ActionTaken] nvarchar(10),
		[BusinessPartnerID] [int] NULL,
		[CompanyName] [nvarchar](200) NULL,
		[ClassificationCDE] [int] NULL,
		[IndustryTypeCDE] [int] NULL,
		[IndustrySubtypeCDE] [int] NULL,
		[RegistrationDate] [datetime] NULL,
		[LoanGradeCDE] [int] NULL,
		[BusinessTypeCDE] [char] (5) NULL,
		[CompanyNbr] [nvarchar] (200) NULL
	);  

	MERGE INTO [dbo].[BusinessPartnerCompany] AS Target
	USING
	(
		SELECT 
			[MAIN].[BUSS_PTNR_ID], [MAIN].[FRST_NME], [MAIN].[CLFN_ID], [MAIN].[INDY_TYPE_ID], [MAIN].[INDY_SBTP_ID], [MAIN].[REGT_DTE], [MAIN].[LOAN_GRNG_ID],
			(SELECT TOP (1) [BUSS_TYPE_ID] FROM [dbo].[BP_CMPY_ADDL] WHERE [BUSS_PTNR_ID] = [MAIN].[BUSS_PTNR_ID] ORDER BY [CMPY_ADDL] DESC) AS [BUSS_TYPE_ID], 
			(SELECT TOP (1) [ID_NUMB] FROM [dbo].[BP_ID_TYPE_ASOC] WHERE [BUSS_PTNR_ID] = [MAIN].[BUSS_PTNR_ID] AND [DFLT_IND] = 1 ORDER BY [TYPE_ASOC_ID] DESC) AS [BUSS_TYPE_ID], 
			2 AS [CompanyId]
		FROM [dbo].[BP_MAIN] AS [MAIN]
	)
	AS [Source] ([BUSS_PTNR_ID], [FRST_NME], [CLFN_ID], [INDY_TYPE_ID], [INDY_SBTP_ID], [REGT_DTE], [LOAN_GRNG_ID], [BUSS_TYPE_ID], [ID_NUMB], [CompanyId]) 
		ON 
		(
			[Target].[BusinessPartnerID] = [Source].[BUSS_PTNR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[CompanyName] = [Source].[FRST_NME],
			[Target].[ClassificationCDE] = [Source].[CLFN_ID],
			[Target].[IndustryTypeCDE] = [Source].[INDY_TYPE_ID],
			[Target].[IndustrySubtypeCDE] = [Source].[INDY_SBTP_ID],
			[Target].[RegistrationDate] = [Source].[REGT_DTE],
			[Target].[LoanGradeCDE] = [Source].[LOAN_GRNG_ID],
			[Target].[BusinessTypeCDE] = [Source].[BUSS_TYPE_ID],
			[Target].[CompanyNbr] = [Source].[ID_NUMB]

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([BusinessPartnerID], [CompanyName], [ClassificationCDE], [IndustryTypeCDE], [IndustrySubtypeCDE], [RegistrationDate], [LoanGradeCDE], [BusinessTypeCDE], [CompanyNbr], [CreationDate], [CompanyID])
		VALUES ([Source].[BUSS_PTNR_ID],[Source].[FRST_NME], [Source].[CLFN_ID], [Source].[INDY_TYPE_ID], [Source].[INDY_SBTP_ID], [Source].[REGT_DTE], [Source].[LOAN_GRNG_ID], [Source].[BUSS_TYPE_ID], [Source].[ID_NUMB], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT	
		deleted.[BusinessPartnerID], deleted.[CompanyName], deleted.[ClassificationCDE], deleted.[IndustryTypeCDE], deleted.[IndustrySubtypeCDE], deleted.[RegistrationDate], deleted.[LoanGradeCDE], deleted.[BusinessTypeCDE], deleted.[CompanyNbr],
		$action,
		inserted.[BusinessPartnerID], inserted.[CompanyName], inserted.[ClassificationCDE], inserted.[IndustryTypeCDE], inserted.[IndustrySubtypeCDE], inserted.[RegistrationDate], inserted.[LoanGradeCDE], inserted.[BusinessTypeCDE], inserted.[CompanyNbr]
	INTO #TEMP_BusinessPartnerCompany; 

	PRINT 'BusinessPartnerCompany merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'Problem in dbo.BusinessPartnerCompany.Table.sql.'

END CATCH;

--SELECT CompanyName_Old, CompanyName FROM #TEMP_BusinessPartnerCompany where CompanyName <> CompanyName_Old