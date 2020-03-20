BEGIN TRY

	TRUNCATE TABLE [dbo].[BusinessPartnerRole];

	MERGE INTO [dbo].[BusinessPartnerRole] AS Target
	USING
	(
		SELECT [BP_ROLE_ID], [BUSS_PTNR_ID], [ACT_IND], 2 AS [CompanyId]
		FROM [dbo].[BP_ROLE_ASOC]
	)
	AS [Source] ( [BP_ROLE_ID], [BUSS_PTNR_ID], [ACT_IND], [CompanyId]) 
		ON 
		(
			[Target].[BusinessPartnerID] = [Source].[BUSS_PTNR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[RoleID] = [Source].[BP_ROLE_ID],
			[Target].[BusinessPartnerID] = [Source].[BUSS_PTNR_ID],
			[Target].[CompanyId] = '$CompanyId$',
			[Target].[ActivateInd] = [Source].[ACT_IND]

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([RoleID], [BusinessPartnerID], [CompanyId], [ActivateInd])
		VALUES ([Source].[BP_ROLE_ID], [Source].[BUSS_PTNR_ID], '$CompanyId$', [Source].[ACT_IND])

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	PRINT 'BusinessPartnerRole merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'Problem in dbo.BusinessPartnerRole.Table.sql.'

END CATCH;