BEGIN TRY

	TRUNCATE TABLE [dbo].[ChartDetail];

	MERGE INTO [dbo].[ChartDetail] AS Target
	USING
	(
		SELECT [DCSN_TABL_ID], [DCSN_TABL].[MSTR_ID], [MSTR].[CHRT_TYPE_ID], [ASET_TYPE], [ASET_SUB_TYPE], [ASET_MAKE], [ASET_BRND], [ASET_MODL], [ASET_COND], [RNTL_MODE], [CONT_TERM_RANG],
			[MIN_RATE], [MAX_RATE], [CHRT_VAL], [STND_RATE], [MAX_FINC_PCNT], [RNTL_FREQ], [ASET_CLFN], [INTR_RATE_RANG], [INTR_RTNG], [FINC_TYPE],
			[CRDT_RTNG], [DOWN_PYMT_RANG], [AGE_RANG], [MODL_YEAR], [PROD_YEAR], [MILG_PER_YEAR], [MNFC_SBDY_PCNT], [DELR_SBDY_PCNT], [PRE_PAY_PCNT],
			[AMNT_RANG], [TERM_RANG], [NFA_PCNT], [COMM_FIXD_AMNT], [FC_COMM_AMNT], [FC_COMM_PCNT], [MIN_COMM_AMNT], [EFCT_STRT_DTE], [EFCT_END_DTE],
			[NST_CODE], [OTP_PRCE_PCNT], 2 AS [CompanyId]
		FROM [dbo].[CHRT_DCSN_TABL] AS [DCSN_TABL]
		JOIN [dbo].[CHRT_MSTR] AS [MSTR] ON [DCSN_TABL].[MSTR_ID] = [MSTR].[MSTR_ID]
	)
	AS [Source] 
		ON 
		(
			[Target].[ChartDetailSEQ] = [Source].[DCSN_TABL_ID] AND
			[Target].[TransactionTypeID] = [Source].[MSTR_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[TransactionTypeID] = [Source].[CHRT_TYPE_ID],
			[Target].[ChartDetailSEQ] = [Source].[DCSN_TABL_ID],
			[Target].[ChartMainID] = [Source].[MSTR_ID],
			[Target].[VehicleTypeCode] = [Source].[ASET_TYPE],
			[Target].[AssetMakeCode] = [Source].[ASET_SUB_TYPE],
			[Target].[AssetBrandCode] = [Source].[ASET_BRND],
			[Target].[AssetModelCode] = [Source].[ASET_MODL],
			[Target].[AssetConditionCode] = [Source].[ASET_COND],
			[Target].[RentalModeType] = [Source].[RNTL_MODE],
			[Target].[MinimumRate] = [Source].	[MIN_RATE],
			[Target].[MaximumRate] = [Source].[MAX_RATE],
			[Target].[ChartValue] = [Source].[CHRT_VAL],
			[Target].[StandardRate]	= [Source].[STND_RATE],
			[Target].[DownPaymentRangeID] = [Source].[DOWN_PYMT_RANG],
			[Target].[AgeRangeID] = [Source].[AGE_RANG],
			[Target].[ModelYearCDE]	= [Source].[MODL_YEAR],
			[Target].[ProductionYearCDE] = [Source].[PROD_YEAR],
			[Target].[MileagePerYearCDE] = [Source].[MILG_PER_YEAR],
			[Target].[AmountRangeID] = [Source].[AMNT_RANG],
			[Target].[TermRangeID] = [Source].[TERM_RANG],
			[Target].[NfaPercentage] = [Source].[NFA_PCNT],
			[Target].[CommissionFixedAmount] = [Source].[COMM_FIXD_AMNT],
			[Target].[FCCommissionAmount] = [Source].[FC_COMM_AMNT],
			[Target].[FCCommissionPercentage] = [Source].[FC_COMM_PCNT],
			[Target].[MinimumCommissionAmount] = [Source].[MIN_COMM_AMNT],
			[Target].[EffStartDate]	= [Source].[EFCT_STRT_DTE],
			[Target].[EffEndDate] = [Source].[EFCT_END_DTE],
			[Target].[NST] = [Source].[NST_CODE],
			[Target].[OptionPricePct] = [Source].[OTP_PRCE_PCNT],
			[Target].[CompanyID] = '$CompanyId$'

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([ChartDetailSEQ], [TransactionTypeID], [ChartMainID], [VehicleTypeCode], [AssetMakeCode], [AssetBrandCode], [AssetModelCode],
				[AssetConditionCode], [RentalModeType], [MinimumRate], [MaximumRate], [ChartValue], [StandardRate], [DownPaymentRangeID],
				[AgeRangeID], [ModelYearCDE], [ProductionYearCDE], [MileagePerYearCDE], [AmountRangeID], [TermRangeID], [NfaPercentage],
				[CommissionFixedAmount], [FCCommissionAmount], [FCCommissionPercentage], [MinimumCommissionAmount], [EffStartDate],
				[EffEndDate], [NST], [OptionPricePct],[CompanyID])
		VALUES ([Source].[DCSN_TABL_ID], [Source].[CHRT_TYPE_ID], [Source].[MSTR_ID], [Source].[ASET_TYPE], [Source].[ASET_MAKE], [Source].[ASET_BRND],
				[Source].[ASET_MODL],[Source].[ASET_COND],[Source].[RNTL_MODE],[Source].[MIN_RATE],[Source].[MAX_RATE],[Source].[CHRT_VAL],[Source].[STND_RATE],
				[Source].[DOWN_PYMT_RANG],[Source].[AGE_RANG],[Source].[MODL_YEAR],[Source].[PROD_YEAR],[Source].[MILG_PER_YEAR],[Source].[AMNT_RANG],[Source].[TERM_RANG],
				[Source].[NFA_PCNT],[Source].[COMM_FIXD_AMNT],[Source].[FC_COMM_AMNT],[Source].[FC_COMM_PCNT],[Source].[MIN_COMM_AMNT],[Source].[EFCT_STRT_DTE],
				[Source].[EFCT_END_DTE],[Source].[NST_CODE],[Source].[OTP_PRCE_PCNT],'$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	PRINT 'ChartDetail merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT
	ERROR_NUMBER() AS ErrorNumber  
     , ERROR_SEVERITY() AS ErrorSeverity  
     , ERROR_STATE() AS ErrorState  
     , ERROR_PROCEDURE() AS ErrorProcedure  
     , ERROR_LINE() AS ErrorLine  
     , ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'ChartDetail in dbo.Relationship.Table.sql.'

END CATCH;