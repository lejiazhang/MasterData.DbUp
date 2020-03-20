BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetBrandType];
	MERGE INTO [dbo].[AssetBrandType] AS Target
	USING
	(
		SELECT [BRND_TYPE_ID], [NME], [DSCR], [MAKE_TYPE_ID], [EXTR_CODE],[ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_BRND_TYPE_CODE]
	)
	AS [Source] ([BRND_TYPE_ID], [NME], [DSCR], [MAKE_TYPE_ID], [EXTR_CODE],[ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetBrandTypeID] = [Source].[BRND_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetBrandTypeName] = [Source].[NME],
			[Target].[AssetBrandTypeDesc] = [Source].[DSCR],
			[Target].[AssetMakeTypeID] = [Source].[MAKE_TYPE_ID],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
        -- insert new rows 
		INSERT ([AssetBrandTypeID], [AssetBrandTypeName], [AssetBrandTypeDesc], [AssetMakeTypeID], [ExternalCode],[ActiveIndicator], [CompanyID])
		VALUES ([Source].[BRND_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[MAKE_TYPE_ID], [Source].[EXTR_CODE], [Source].[ACT_IND], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
        -- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetBrandType]) = (SELECT COUNT (1) FROM [dbo].[ASET_BRND_TYPE_CODE]))
		PRINT 'AssetBrandType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetBrandType.Table.sql.'

END CATCH;