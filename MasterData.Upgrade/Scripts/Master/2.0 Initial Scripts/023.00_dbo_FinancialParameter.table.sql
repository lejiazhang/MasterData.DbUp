BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialParameter];
	MERGE INTO [dbo].[FinancialParameter] AS Target
	USING
	(
		SELECT [TMPL_ASOC].[FNCL_PROD_ID], [FNCL_PROD].[NME], [FNCL_PROD].[MIN_FNCL_TRMS], [FNCL_PROD].[MAX_FNCL_TRMS],
			   [TMPL_RNTL_ATCH].[RNTL_MODE_KEY], [TMPL_RNTL_ATCH].[RV_CALC_MTHD_TYPE_KEY], 2 AS [CompanyId]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		JOIN [dbo].[FP_FNCL_PROD] AS [FNCL_PROD] ON [TMPL_ASOC].[FNCL_PROD_ID] = [FNCL_PROD].[FNCL_PROD_ID]
		LEFT JOIN [dbo].[FP_TMPL_RNTL_ATCH] [TMPL_RNTL_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [TMPL_RNTL_ATCH].[TMPL_ASOC_ID]
	)
	AS [Source] ([FNCL_PROD_ID], [NME], [MIN_FNCL_TRMS], [MAX_FNCL_TRMS], [RNTL_MODE_KEY], [RV_CALC_MTHD_TYPE_KEY], [CompanyId]) 
		ON 
		(
			[Target].[FINANCIALPARAMETERID] = [Source].[FNCL_PROD_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ParameterName] = [Source].[NME],
			[Target].[MinimumLeaseTerm] = [Source].[MIN_FNCL_TRMS],
			[Target].[MaximumLeaseTerm] = [Source].[MAX_FNCL_TRMS],
			[Target].[RentalModeType] = [Source].[RNTL_MODE_KEY],
			[Target].[SplitRVInd] = [Source].[RV_CALC_MTHD_TYPE_KEY]

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([FinancialParameterID], [ParameterName], [MinimumLeaseTerm], [MaximumLeaseTerm], [RentalModeType], [SplitRVInd], [CreationDate], [CompanyID])
		VALUES ([Source].[FNCL_PROD_ID], [Source].[NME], [Source].[MIN_FNCL_TRMS], [Source].[MAX_FNCL_TRMS], [Source].[RNTL_MODE_KEY], [Source].[RV_CALC_MTHD_TYPE_KEY], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FinancialParameter]) = (SELECT COUNT (1) FROM [dbo].[FP_FNCL_PROD_GRP]))
		PRINT 'FinancialParameter merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FinancialParameter.Table.sql.'

END CATCH;