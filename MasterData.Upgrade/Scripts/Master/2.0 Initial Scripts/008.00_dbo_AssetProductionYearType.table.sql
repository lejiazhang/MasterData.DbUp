BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetProductionYearType];
	MERGE INTO [dbo].[AssetProductionYearType] AS Target
	USING
	(
		SELECT [PROD_YEAR_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_PROD_YEAR_TYPE_CODE]
	)
	AS [Source] ([PROD_YEAR_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetProductionYearTypeID] = [Source].[PROD_YEAR_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetProductionYearTypeName] = [Source].[NME],
			[Target].[AssetProductionYearTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetProductionYearTypeID], [AssetProductionYearTypeName], [AssetProductionYearTypeDesc], [ActiveIndicator], [ExternalCode], [CompanyID])
		VALUES ([Source].[PROD_YEAR_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetProductionYearType]) = (SELECT COUNT (1) FROM [dbo].[ASET_PROD_YEAR_TYPE_CODE]))
		PRINT 'AssetProductionYearType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetProductionYearType.Table.sql.'

END CATCH;