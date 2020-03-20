BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetBlazeType];
	MERGE INTO [dbo].[AssetBlazeType] AS Target
	USING
	(
		SELECT [BLAZ_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[ASET_SBTP_BLAZ_TYPE_CODE]
	)
	AS [Source] ([BLAZ_TYPE_ID], [NME], [DSCR], [EXTR_CODE], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[AssetBlazeTypeID] = [Source].[BLAZ_TYPE_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetBlazeTypeName] = [Source].[NME],
			[Target].[AssetBlazeTypeDesc] = [Source].[DSCR],
			[Target].[ActiveIndicator] = [Source].[ACT_IND],
			[Target].[ExternalCode] = [Source].[EXTR_CODE],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetBlazeTypeID], [AssetBlazeTypeName], [AssetBlazeTypeDesc], [ActiveIndicator],[ExternalCode], [CompanyID])
		VALUES ([Source].[BLAZ_TYPE_ID], [Source].[NME], [Source].[DSCR], [Source].[ACT_IND], [Source].[EXTR_CODE], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	IF ((SELECT COUNT (1) FROM [dbo].[AssetBlazeType]) = (SELECT COUNT (1) FROM [dbo].[ASET_SBTP_BLAZ_TYPE_CODE]))
		PRINT 'AssetBlazeType merge script ran successfully.'

END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.AssetBlazeType.Table.sql.'

END CATCH;