BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetUsageType];
	MERGE INTO [dbo].[AssetUsageType] AS Target
	USING
	(
		SELECT [USAG_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_USAG_TYPE_CODE]
	)
	AS [Source] ([USAG_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetUsageTypeID] = [Source].[USAG_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetUsageTypeName] = [Source].[NME],
			[Target].[AssetUsageTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetUsageTypeID], [AssetUsageTypeName], [AssetUsageTypeDesc], [ActiveIndicator], [ExternalCode], [CompanyID])
		VALUES ([Source].[USAG_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetUsageType]) = (SELECT COUNT (1) FROM [dbo].[ASET_USAG_TYPE_CODE]))
		PRINT 'AssetUsageType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetUsageType.Table.sql.'

END CATCH;