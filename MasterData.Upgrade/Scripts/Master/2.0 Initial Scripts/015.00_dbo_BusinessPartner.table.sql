BEGIN TRY

	TRUNCATE TABLE [dbo].[BusinessPartner];

	INSERT INTO [dbo].[BusinessPartner]
		([BusinessPartnerID], [CompanyID], [BusinessPartnerName], [BPNumber], [BPTypeID], [CreationDate], [LegalStatusCode], [PMSDealerNbr], [RegistrationFee], [PurchaseTax], [VatRate])
	SELECT [BusinessPartnerID], [CompanyID], [BusinessPartnerName], [BPNumber], [BPTypeID], [CreationDate], [LegalStatusCode], [PMSDealerNbr], [RegistrationFee], [PurchaseTax], [VatRate]
	FROM [NPOS_PROD_Master_Data_Service].[dbo].[BusinessPartner] WHERE [CompanyID] = 2


	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  
	DROP TABLE IF EXISTS tempdb.dbo.#TEMP_BusinessPartner
	CREATE TABLE #TEMP_BusinessPartner
	(
		[BusinessPartnerID_Old] [int] NULL,
		[BusinessPartnerName_Old] [nvarchar](510) NULL,
		[LegalStatusCode_Old] [varchar](10) NULL,
		[RegistrationFee_Old] [decimal](18, 5) NULL,
		[PMSDealerNbr_Old] [varchar](50) NULL,
		[CompanyID_Old] [tinyint] NULL,
		[ActionTaken] nvarchar(10),
		[BusinessPartnerID] [int] NULL,
		[BusinessPartnerName] [nvarchar](510) NULL,
		[LegalStatusCode] [varchar](10) NULL,
		[RegistrationFee] [decimal](18, 5) NULL,
		[PMSDealerNbr] [varchar](50) NULL,
		[CompanyID] [tinyint] NULL
	);  

	;WITH BP_ROLE_DET ([BUSS_PTNR_ID], [DELR_CODE]) AS
	(
		SELECT [MAIN].[BUSS_PTNR_ID], [ROLE_DET].[DELR_CODE]
		FROM [dbo].[BP_MAIN] AS [MAIN]
		JOIN [dbo].[BP_ROLE_ASOC] AS [ROLE_ASOC] ON [MAIN].[BUSS_PTNR_ID] = [ROLE_ASOC].[BUSS_PTNR_ID]
			AND [ROLE_ASOC].[BP_ROLE_ID] = 
			(
				SELECT [LKUP_DET_ID] FROM [dbo].[LKUP_DET] 
				WHERE
					[LKUP_MAIN_ID] = 
					(
						SELECT [LKUP_MAIN_ID] from [dbo].[LKUP_MAIN] WHERE [NME] = 'BpRoleTypeCode'
					)
				AND [NME] = 'Dealer'
			)
		JOIN [dbo].[BP_ROLE_DET] AS [ROLE_DET] ON [ROLE_ASOC].[ROLE_ASOC_ID] = [ROLE_DET].[ROLE_ASOC_ID]
	)
	MERGE INTO [dbo].[BusinessPartner] AS Target
	USING
	(
		SELECT [MAIN].[BUSS_PTNR_ID], [MAIN].[FULL_NME_C], [MAIN].[LEGL_STS_KEY], [MAIN].[CPTL_REGT_AMNT], [BP_ROLE_DET].[DELR_CODE], 2 AS [CompanyId]
		FROM [dbo].[BP_MAIN] AS [MAIN]
		LEFT JOIN [BP_ROLE_DET] ON [MAIN].[BUSS_PTNR_ID] = [BP_ROLE_DET].[BUSS_PTNR_ID]
	)
	AS [Source] ([BUSS_PTNR_ID], [FULL_NME_C], [LEGL_STS_KEY], [CPTL_REGT_AMNT], [DELR_CODE], [CompanyId]) 
		ON 
		(
			[Target].[BusinessPartnerID] = [Source].[BUSS_PTNR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[BusinessPartnerName] = [Source].[FULL_NME_C],
			[Target].[LegalStatusCode] = [Source].[LEGL_STS_KEY],
			[Target].[RegistrationFee] = [Source].[CPTL_REGT_AMNT],
			[Target].[PMSDealerNbr] = [Source].[DELR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([BusinessPartnerID], [BusinessPartnerName], [LegalStatusCode], [RegistrationFee], [CreationDate], [PMSDealerNbr], [CompanyID])
		VALUES ([Source].[BUSS_PTNR_ID], [Source].[FULL_NME_C], [Source].[LEGL_STS_KEY], [Source].[CPTL_REGT_AMNT], GETDATE(), [Source].[DELR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT	
		deleted.[BusinessPartnerID], deleted.[BusinessPartnerName], deleted.[LegalStatusCode], deleted.[RegistrationFee], deleted.[PMSDealerNbr], deleted.[CompanyID], 
		$action,
		inserted.[BusinessPartnerID], inserted.[BusinessPartnerName], inserted.[LegalStatusCode], inserted.[RegistrationFee], inserted.[PMSDealerNbr], inserted.[CompanyID] 
	INTO #TEMP_BusinessPartner; 

	PRINT 'BusinessPartner merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'Problem in dbo.BusinessPartner.Table.sql.'

END CATCH;

--SELECT * FROM #TEMP_BusinessPartner --WHERE ActionTaken = N'DELETE'

--select * from #TEMP_BusinessPartner where BusinessPartnerName <> BusinessPartnerName_Old