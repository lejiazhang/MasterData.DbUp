BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetTransmissionType];
	MERGE INTO [dbo].[AssetTransmissionType] AS Target
	USING
	(
		SELECT [TRAN_KEY], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_TRAN_TYPE_CODE]
	)
	AS [Source] ([TRAN_KEY], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetTransmissionTypeName] = [Source].[TRAN_KEY]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetTransmissionTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetTransmissionTypeName], [AssetTransmissionTypeDesc], [ActiveIndicator], [ExternalCode], [CompanyID])
		VALUES ([Source].[TRAN_KEY], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetTransmissionType]) = (SELECT COUNT (1) FROM [dbo].[ASET_TRAN_TYPE_CODE]))
		PRINT 'AssetTransmissionType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetTransmissionType.Table.sql.'

END CATCH;