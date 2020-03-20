BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetModelYearType];
	MERGE INTO [dbo].[AssetModelYearType] AS Target
	USING
	(
		SELECT [MODL_YEAR_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_MODL_YEAR_TYPE_CODE]
	)
	AS [Source] ([MODL_YEAR_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetModelYearTypeID] = [Source].[MODL_YEAR_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetModelYearTypeName] = [Source].[NME],
			[Target].[AssetModelYearTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetModelYearTypeID], [AssetModelYearTypeName], [AssetModelYearTypeDesc], [ActiveIndicator], [ExternalCode], [CompanyID])
		VALUES ([Source].[MODL_YEAR_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetModelYearType]) = (SELECT COUNT (1) FROM [dbo].[ASET_MODL_YEAR_TYPE_CODE]))
		PRINT 'AssetModelYearType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetModelYearType.Table.sql.'

END CATCH;