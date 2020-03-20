BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetConditionType];
	MERGE INTO [dbo].[AssetConditionType] AS Target
	USING
	(
		SELECT [COND_TYPE_KEY], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_COND_TYPE_CODE]
	)
	AS [Source] ([COND_TYPE_KEY], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetConditionTypeCode] = [Source].[COND_TYPE_KEY]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetConditionTypeDesc] = [Source].DSCR,
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetConditionTypeCode], [AssetConditionTypeDesc], [ExternalCode], [ActiveIndicator], [CompanyID])
		VALUES ([Source].[COND_TYPE_KEY], [Source].[DSCR], [Source].[EXTR_CODE], [Source].[ACT_IND], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetConditionType]) = (SELECT COUNT (1) FROM [dbo].[ASET_COND_TYPE_CODE]))
		PRINT 'AssetConditionType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetConditionType.Table.sql.'

END CATCH;