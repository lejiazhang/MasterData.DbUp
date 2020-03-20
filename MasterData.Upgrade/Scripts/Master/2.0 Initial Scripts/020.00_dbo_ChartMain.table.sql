BEGIN TRY

	TRUNCATE TABLE [dbo].[ChartMain];

	MERGE INTO [dbo].[ChartMain] AS Target
	USING
	(
		SELECT [MSTR_ID], [CHRT_NME], [CHRT_TYPE_ID], [ACT_IND], [INSR_DTE], [UPDT_DTE], [EXEC_DTE], [FLAG], 2 AS [CompanyId]
		FROM [dbo].[CHRT_MSTR]
	)
	AS [Source]
		ON 
		(
			[Target].[ChartMainID] = [Source].[MSTR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ChartMainID] = [Source].[MSTR_ID],
			[Target].[ChartName] = [Source].[CHRT_NME],
			[Target].[TransactionTypeID] = [Source].[CHRT_TYPE_ID],
			[Target].[ActiveIND] = [Source].[ACT_IND],
			[Target].[CreationDate] = GETDATE(),
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([ChartMainID], [ChartName], [TransactionTypeID], [ActiveIND], [CreationDate], [CompanyID])
		VALUES ([Source].[MSTR_ID], [Source].[CHRT_NME], [Source].[CHRT_TYPE_ID], [Source].[ACT_IND], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	PRINT 'ChartMain merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'ChartMain in dbo.Relationship.Table.sql.'

END CATCH;