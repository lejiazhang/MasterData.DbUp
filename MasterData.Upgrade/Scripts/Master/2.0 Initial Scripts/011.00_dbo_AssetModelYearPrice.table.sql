BEGIN TRY

	TRUNCATE TABLE [dbo].[AssetModelYearPrice];
	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[AssetModelYearPrice] AS Target
	USING
	(
		SELECT  
			[MODL_YEAR_PRCE_ID], [MODL_ID], [MODL_SEQ_NUMB], [EFCT_DTE], [TRAN_KEY], [CRCY_ID], [RETL_PRCE], [WS_PRCE], 
			[WARG_PCNT], [REJN_PCNT], [MODL_DET_ID], [MODL_YEAR_TYPE_ID], 2 AS [CompanyId]
		FROM [dbo].[ASET_MODL_YEAR_PRCE] 
	)
	AS [Source] 
	ON 
	(
		[Target].AssetYearPriceId = [Source].[MODL_YEAR_PRCE_ID]
	)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[AssetModelExtId] = [Source].[MODL_ID],
			[Target].[AssetSequenceNumber] = [Source].[MODL_SEQ_NUMB],
			[Target].[EffectDate] = [Source].[EFCT_DTE],
			[Target].[TransmissionTypeCode] = [Source].[TRAN_KEY],
			[Target].[CRCY_ID] = [Source].[CRCY_ID],
			[Target].[RetailPrice] = [Source].[RETL_PRCE],
			[Target].[WholeSalePrice] = [Source].[WS_PRCE],
			[Target].[WARG_PCNT] = [Source].[WARG_PCNT],
			[Target].[REJN_PCNT] = [Source].[REJN_PCNT],
			[Target].[AssetModelExtDetailId] = [Source].[MODL_DET_ID],
			[Target].[AssetModelYearTypeId] = [Source].[MODL_YEAR_TYPE_ID],
			[Target].[CreationDate] = GETDATE(),
			[Target].[CompanyId] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([AssetYearPriceId], [AssetModelExtId], [AssetSequenceNumber], [EffectDate], [TransmissionTypeCode], 
				[CRCY_ID], [RetailPrice], [WholeSalePrice], [WARG_PCNT], [REJN_PCNT], [AssetModelExtDetailId], 
				[AssetModelYearTypeId], [CreationDate], [CompanyId])

		VALUES ([Source].[MODL_YEAR_PRCE_ID], [Source].[MODL_ID],[Source].[MODL_SEQ_NUMB],[Source].[EFCT_DTE],[Source].[TRAN_KEY],
				[Source].[CRCY_ID], [Source].[RETL_PRCE],
				[Source].[WS_PRCE], [Source].[WARG_PCNT], [Source].[REJN_PCNT], [Source].[MODL_DET_ID], [Source].[MODL_YEAR_TYPE_ID],
				GETDATE(), '$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;
	
	PRINT 'AssetModelYearPrice merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.AssetModelYearPrice.Table.sql.'

END CATCH;