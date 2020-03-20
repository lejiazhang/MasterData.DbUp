BEGIN TRY

	TRUNCATE TABLE [dbo].[FPAssetSelection];
	MERGE INTO [dbo].[FPAssetSelection] AS Target
	USING
	(
		SELECT [TMPL_ASOC].[FNCL_PROD_ID], [MODL_CODE_DET].[AssetMakeID], [MODL_CODE_DET].[AssetModelExtID], [ASET_DET_ATCH].[ASET_MODL_ID], 2 AS [CompanyId]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_ASET_DET_ATCH] AS [ASET_DET_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [ASET_DET_ATCH].[TMPL_ASOC_ID]
		LEFT JOIN [AssetModelCompany] AS [MODL_CODE_DET] ON [ASET_DET_ATCH].[ASET_MODL_ID] = [MODL_CODE_DET].[AssetModelExtDetailId]
	)
	AS [Source] ([FNCL_PROD_ID], [AssetMakeID], [AssetModelExtID], [ASET_MODL_ID], [CompanyID]) 
		ON 
		(
			[Target].[FinancialProductID] = [Source].[FNCL_PROD_ID] AND
			[Target].[AssetMakeCode] = [Source].[AssetMakeID] AND
			[Target].[AssetModelCode] = [Source].[AssetModelExtID] AND
			[Target].[AssetModelExtDetailId] = [Source].[ASET_MODL_ID]
		)

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([FinancialProductID], [AssetMakeCode], [AssetModelCode], [AssetModelExtDetailId], [InsertedBy], [CreationDate], [CompanyID])
		VALUES ([Source].[FNCL_PROD_ID], [Source].[AssetMakeID], [Source].[AssetModelExtID], [Source].[ASET_MODL_ID], 'dbo', GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[FPAssetSelection]) = (SELECT COUNT (1) FROM [dbo].[FP_TMPL_INTR_DET_ATCH]))
		PRINT 'FPAssetSelection merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.FPAssetSelection.Table.sql.'

END CATCH;