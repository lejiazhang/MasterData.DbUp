BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetSubType];
	MERGE INTO [dbo].[AssetSubType] AS Target
	USING
	(
		SELECT [ASET_SBTP_ID], [NME], [DSCR], [ASET_TYPE_ID], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_SBTP_CODE]
	)
	AS [Source] ([ASET_SBTP_ID], [NME], [DSCR], [ASET_TYPE_ID], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetSubTypeID] = [Source].[ASET_SBTP_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetSubTypeName] = [Source].[NME],
			[Target].[AssetSubTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[AssetTypeID] = [Source].[ASET_TYPE_ID],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetSubTypeID], [AssetSubTypeName], [AssetSubTypeDesc], [ActiveIndicator], [AssetTypeID], [ExternalCode], [CompanyID])
		VALUES ([Source].[ASET_SBTP_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[ASET_TYPE_ID], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetSubType]) = (SELECT COUNT (1) FROM [dbo].[ASET_SBTP_CODE]))
		PRINT 'AssetSubType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetSubType.Table.sql.'

END CATCH;