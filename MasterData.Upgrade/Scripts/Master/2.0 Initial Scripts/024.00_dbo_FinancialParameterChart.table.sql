BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialParameterChart];
	MERGE INTO [dbo].[FinancialParameterChart] AS Target
	USING
	(
		SELECT  
			[TMPL_ASOC].[TMPL_ASOC_ID], [TMPL_ASOC].[FNCL_PROD_ID], [CHRT_ATCH].[CHRT_MSTR_ID], [MSTR].[CHRT_TYPE_ID], 2 AS [CompanyId]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_RNTL_CHRT_ATCH] AS [CHRT_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [CHRT_ATCH].[TMPL_ASOC_ID]
		LEFT JOIN [dbo].[CHRT_MSTR] AS [MSTR] ON [CHRT_ATCH].[CHRT_MSTR_ID] = [MSTR].[MSTR_ID]
	)
	AS [Source] ([FNCL_PROD_ID], [CHRT_MSTR_ID], [CHRT_TYPE_ID], [MAX_FNCL_TRMS], [CompanyId]) 
		ON 
		(
			[Target].[FinancialParameterID] = [Source].[FNCL_PROD_ID] AND
			[Target].[TransactionTypeID] = [Source].[CHRT_TYPE_ID] AND
			[Target].[ChartMainID] = [Source].[CHRT_MSTR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ChartMainID] = [Source].[CHRT_MSTR_ID],
			[Target].[TransactionTypeID] = [Source].[CHRT_TYPE_ID],
			[Target].[FinancialParameterID] = [Source].[FNCL_PROD_ID]

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([ChartMainID],[TransactionTypeID], [FinancialParameterID], [CreationDate], [CompanyID], [InsertedBy])
		VALUES ([Source].[CHRT_MSTR_ID], [Source].[CHRT_TYPE_ID], [Source].[FNCL_PROD_ID], GETDATE(), '$CompanyId$', 'dbo')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FinancialParameterChart]) = (SELECT COUNT (1) FROM [dbo].[FP_FNCL_PROD_GRP]))
		PRINT 'FinancialParameterChart merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FinancialParameterChart.Table.sql.'

END CATCH;