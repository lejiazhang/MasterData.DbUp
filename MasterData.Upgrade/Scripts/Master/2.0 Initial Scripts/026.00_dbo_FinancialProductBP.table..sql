BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialProductBP];
	MERGE INTO [dbo].[FinancialProductBP] AS Target
	USING
	(
		SELECT [TMPL_ASOC].[FNCL_PROD_ID], [INTR_DET_ATCH].[BUSS_PTNR_ID], [INTR_DET_ATCH].[BP_ROLE_ID], 2 AS [CompanyId]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_INTR_DET_ATCH] AS [INTR_DET_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [INTR_DET_ATCH].[TMPL_ASOC_ID]
	)
	AS [Source] ([FNCL_PROD_ID], [BUSS_PTNR_ID], [BP_ROLE_ID], [CompanyId]) 
		ON 
		(
			[Target].[FinancialProductID] = [Source].[FNCL_PROD_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[BusinessPartnerID] = [Source].[BUSS_PTNR_ID],
			[Target].[RoleID] = [Source].[BP_ROLE_ID],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([FinancialProductID], [BusinessPartnerID], [RoleID], [CreationDate], [CompanyID])
		VALUES ([Source].[FNCL_PROD_ID], [Source].[BUSS_PTNR_ID], [Source].[BP_ROLE_ID], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FinancialProductBP]) = (SELECT COUNT (1) FROM [dbo].[FP_TMPL_INTR_DET_ATCH]))
		PRINT 'FinancialProductBP merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FinancialProductBP.Table.sql.'

END CATCH;