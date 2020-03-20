BEGIN TRY

	TRUNCATE TABLE [dbo].[BPAddress];
	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[BPAddress] AS Target
	USING
	(
		SELECT  
			[ADDR_ID], [CTRY_ID], [STAT_ID], [CITY_ID], [HOUS_NUMB], [PSTL_CODE], [BLDG_NME], 
			[STET_NUMB], [UNIT_NUMB], [STAY_PERD_YR], [STAY_PERD_MNTH], 
			[ATTN_TO], [INSR_DTE], [UPDT_DTE], [EXEC_DTE], [FLAG], 2 AS [CompanyId]
		FROM [dbo].[BP_ADDR] 
	)
	AS [Source] 
	ON 
	(
		[Target].[Id] = [Source].[ADDR_ID]
	)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[ContryId] = [Source].[CTRY_ID],
			[Target].[StateId] = [Source].[STAT_ID],
			[Target].[CityId] = [Source].[CITY_ID],
			[Target].[StreetName] = [Source].[HOUS_NUMB],
			[Target].[PostalCode] = [Source].[PSTL_CODE],
			[Target].[BuildingName] = [Source].[BLDG_NME],
			[Target].[StreetNumber] = [Source].[STET_NUMB],
			[Target].[UnitNumber] = [Source].[UNIT_NUMB],
			[Target].[StayInYear] = [Source].[STAY_PERD_YR],
			[Target].[StayInMonth] = [Source].[STAY_PERD_MNTH],
			[Target].[AttentionToName] = [Source].[ATTN_TO],
			[Target].[CreationDate] = GETDATE(),
			[Target].[CompanyId] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ( [Id], [ContryId], [StateId], [CityId], [StreetName], [PostalCode], [BuildingName], [StreetNumber], 
				 [UnitNumber], [StayInYear], [StayInMonth], [AttentionToName], [CreationDate], [CompanyId])

		VALUES ([Source].[ADDR_ID], [Source].[CTRY_ID], [Source].[STAT_ID], [Source].[HOUS_NUMB],[Source].[PSTL_CODE],
				[Source].[BLDG_NME],[Source].[BLDG_NME], [Source].[STET_NUMB], [Source].[UNIT_NUMB],
				[Source].[STAY_PERD_YR], [Source].[STAY_PERD_MNTH], [Source].[ATTN_TO], GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;
	
	PRINT 'BPAddress merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.BPAddress.Table.sql.'

END CATCH;