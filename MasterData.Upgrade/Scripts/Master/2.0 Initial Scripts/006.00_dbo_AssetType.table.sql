BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetType];
	MERGE INTO [dbo].[AssetType] AS Target
	USING
	(
		SELECT [ASET_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_TYPE_CODE]
	)
	AS [Source] ([ASET_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetTypeID] = [Source].[ASET_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetTypeName] = [Source].[NME],
			[Target].[AssetTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetTypeID], [AssetTypeName], [AssetTypeDesc], [ActiveIndicator], [ExternalCode], [CompanyID])
		VALUES ([Source].[ASET_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetType]) = (SELECT COUNT (1) FROM [dbo].[ASET_TYPE_CODE]))
		PRINT 'AssetType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetType.Table.sql.'

END CATCH;