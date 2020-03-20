BEGIN TRY

	TRUNCATE TABLE [dbo].[BPAddressAssiocation];
	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[BPAddressAssiocation] AS Target
	USING
	(
		SELECT  
			[ADDR_ASOC_ID], [BUSS_PTNR_ID], [SEQ_ID], [ADDR_TYPE_ID], [ADDR_ID], 2 AS [CompanyId]
		FROM [dbo].[BP_ADDR_ASOC] 
	)
	AS [Source] 
	ON 
	(
		[Target].[Id] = [Source].[ADDR_ASOC_ID]
	)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[BusinessPartnerId] = [Source].[BUSS_PTNR_ID],
			[Target].[AddressSeq] = [Source].[SEQ_ID],
			[Target].[AddressTypeId] = [Source].[ADDR_TYPE_ID],
			[Target].[BPAddressId] = [Source].[ADDR_ID],
			[Target].[CompanyId] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ( [Id], [BusinessPartnerId], [AddressSeq], [AddressTypeId], [BPAddressId], [CompanyId] )

		VALUES ([Source].[ADDR_ASOC_ID], [Source].[BUSS_PTNR_ID], [Source].[SEQ_ID], [Source].[ADDR_TYPE_ID],
				[Source].[ADDR_ID], '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;
	
	PRINT 'BPAddressAssiocation merge script ran successfully.'
END TRY
BEGIN CATCH
	
	 PRINT 'Problem in dbo.BPAddressAssiocation.Table.sql.'

END CATCH;