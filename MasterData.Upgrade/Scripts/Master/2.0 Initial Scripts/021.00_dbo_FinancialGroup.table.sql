BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialGroup];
	MERGE INTO [dbo].[FinancialGroup] AS Target
	USING
	(
		SELECT [FNCL_PROD_GRP_ID], [SHRT_NME], [LONG_NME], 2 AS [CompanyId]
		FROM [dbo].[FP_FNCL_PROD_GRP]
	)
	AS [Source] ([FNCL_PROD_GRP_ID], [SHRT_NME], [LONG_NME], [CompanyId]) 
		ON 
		(
			[Target].[FinancialGroupID] = [Source].[FNCL_PROD_GRP_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[GroupName] = [Source].[SHRT_NME],
			[Target].[GroupFullName] = [Source].[LONG_NME],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([FinancialGroupID], [GroupName], [GroupFullName], [CreationDate], [CompanyID])
		VALUES ([Source].[FNCL_PROD_GRP_ID], [Source].[SHRT_NME], [Source].[LONG_NME], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FinancialGroup]) = (SELECT COUNT (1) FROM [dbo].[FP_FNCL_PROD_GRP]))
		PRINT 'FinancialGroup merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FinancialGroup.Table.sql.'

END CATCH;