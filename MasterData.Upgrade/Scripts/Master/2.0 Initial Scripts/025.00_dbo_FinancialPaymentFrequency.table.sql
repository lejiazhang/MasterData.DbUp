BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialPaymentFrequency];
	MERGE INTO [dbo].[FinancialPaymentFrequency] AS Target
	USING
	(
		SELECT [TMPL_ASOC].[FNCL_PROD_ID], [FREQ_DET_ATCH].[RNTL_FREQ_KEY], 2 AS [CompanyId]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_RNTL_FREQ_DET_ATCH] AS [FREQ_DET_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [FREQ_DET_ATCH].[TMPL_ASOC_ID]
	)
	AS [Source] ([FNCL_PROD_ID], [RNTL_FREQ_KEY], [CompanyId]) 
		ON 
		(
			[Target].[FinancialParameterID] = [Source].[FNCL_PROD_ID] AND
			[Target].[PaymentFrequencyID] = [Source].[RNTL_FREQ_KEY]

		)

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([FinancialParameterID], [PaymentFrequencyID],[CompanyID])
		VALUES ([Source].[FNCL_PROD_ID], [Source].[RNTL_FREQ_KEY], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FinancialPaymentFrequency]) = (SELECT COUNT (1) FROM [dbo].[FP_TMPL_RNTL_FREQ_DET_ATCH]))
		PRINT 'FinancialPaymentFrequency merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FinancialPaymentFrequency.Table.sql.'

END CATCH;