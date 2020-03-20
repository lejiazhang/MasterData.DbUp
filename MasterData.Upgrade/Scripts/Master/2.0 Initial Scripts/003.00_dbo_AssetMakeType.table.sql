BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetMakeType];
	MERGE INTO [dbo].[AssetMakeType] AS Target
	USING
	(
		SELECT [MAKE_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_MAKE_TYPE_CODE]
	)
	AS [Source] ([MAKE_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetMakeTypeID] = [Source].[MAKE_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetMakeTypeName] = [Source].[NME],
			[Target].[AssetMakeTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetMakeTypeID], [AssetMakeTypeName], [AssetMakeTypeDesc], [ActiveIndicator],[ExternalCode], [CompanyID])
		VALUES ([Source].[MAKE_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetMakeType]) = (SELECT COUNT (1) FROM [dbo].[ASET_MAKE_TYPE_CODE]))
		PRINT 'AssetMakeType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetMakeType.Table.sql.'

END CATCH;