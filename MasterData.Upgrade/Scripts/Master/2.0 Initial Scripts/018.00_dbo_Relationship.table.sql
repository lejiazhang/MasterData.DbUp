BEGIN TRY

	TRUNCATE TABLE [dbo].[Relationship];

	MERGE INTO [dbo].[Relationship] AS Target
	USING
	(
		SELECT DISTINCT [RLSP_ASOC].[BUSS_PTNR_ID], [RLSP_ASOC].[RLTN_MAIN_ID], [RLSP_ASOC_DET].[SECY_BUSS_PTNR_ID], 2 AS [CompanyId]
		FROM [dbo].[BP_RLSP_ASOC] AS [RLSP_ASOC]
		JOIN [dbo].[BP_RLSP_ASOC_DET] AS [RLSP_ASOC_DET] ON [RLSP_ASOC].[RLSP_ASOC_ID] = [RLSP_ASOC_DET].[RLSP_ASOC_ID]
	)
	AS [Source] ( [BUSS_PTNR_ID], [RLTN_MAIN_ID], [SECY_BUSS_PTNR_ID], [CompanyId]) 
		ON 
		(
			[Target].[ParentID] = [Source].[BUSS_PTNR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ParentID] = [Source].[BUSS_PTNR_ID],
			[Target].[ChildID] = [Source].[SECY_BUSS_PTNR_ID],
			[Target].[RelationshipID] = [Source].[RLTN_MAIN_ID],
			[Target].[ActiveInd] = 1,
			[Target].[CreationDate] = GETDATE(),
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([ParentID], [ChildID], [RelationshipID], [ActiveInd], [CreationDate], [CompanyID])
		VALUES ([Source].[BUSS_PTNR_ID], [Source].[SECY_BUSS_PTNR_ID], [Source].[RLTN_MAIN_ID], 1, GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	PRINT 'Relationship merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'Problem in dbo.Relationship.Table.sql.'

END CATCH;