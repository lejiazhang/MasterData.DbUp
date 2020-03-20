BEGIN TRY

	TRUNCATE TABLE [dbo].[FinancialProduct];
	
	;WITH FP_CHRG_ABLE_PAY_TYPE 
	(
		[TMPL_ASOC_ID], [FNCL_PROD_ID], [APP_SER_FEE], [SUBSIDY_SER_FEE], [ZERO_SER_FEE], [APP_REG_FEE], [SUBSIDY_REG_FEE], [ZERO_REG_FEE],
		[APP_SUN_FEE], [SUBSIDY_SUN_FEE], [ZERO_SUN_FEE]
	)
	AS
	(
		SELECT
		[TMPL_ASOC].[TMPL_ASOC_ID], [TMPL_ASOC].[FNCL_PROD_ID],
		-- Service Contract Fee
		(CASE [ServiceContractFee].[FINC_IND] WHEN 1 THEN '1' ELSE '0' END) AS [APP_SER_FEE],
		(CASE WHEN [ServiceContractFee].[FINC_IND] = 1 AND [ServiceContractFee].[CHRG_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_SER_FEE],
		(CASE WHEN [ServiceContractFee].[FINC_IND] = 1 AND [ServiceContractFee].[CHRG_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_SER_FEE],
		-- Registrion Fee
		(CASE [RegistrationFee].[FINC_IND] WHEN 1 THEN 1 ELSE 0 END) AS [APP_REG_FEE],
		(CASE WHEN [RegistrationFee].[FINC_IND] = 1 AND [RegistrationFee].[CHRG_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_REG_FEE],
		(CASE WHEN [RegistrationFee].[FINC_IND] = 1 AND [RegistrationFee].[CHRG_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_REG_FEE],
		-- Sundry Fee
		(CASE [SundryFee].[FINC_IND] WHEN 1 THEN '1' ELSE '0' END) AS [APP_SUN_FEE],
		(CASE WHEN [SundryFee].[FINC_IND] = 1 AND [SundryFee].[CHRG_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_SUN_FEE],
		(CASE WHEN [SundryFee].[FINC_IND] = 1 AND [SundryFee].[CHRG_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_SUN_FEE]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_CHRG_PAY_DET_ATCH] AS [ServiceContractFee]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [ServiceContractFee].[TMPL_ASOC_ID] AND
			[ServiceContractFee].[CHRG_PAY_ABLE_TYPE_ID] = 1092
		)
		LEFT JOIN [dbo].[FP_TMPL_CHRG_PAY_DET_ATCH] AS [RegistrationFee]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [ServiceContractFee].[TMPL_ASOC_ID] AND
			[ServiceContractFee].[CHRG_PAY_ABLE_TYPE_ID] = 1093
		)
		LEFT JOIN [dbo].[FP_TMPL_CHRG_PAY_DET_ATCH] AS [SundryFee]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [ServiceContractFee].[TMPL_ASOC_ID] AND
			[ServiceContractFee].[CHRG_PAY_ABLE_TYPE_ID] = 1095
		)
	),
	FP_INSURANCE 
	(
		[TMPL_ASOC_ID], [FNCL_PROD_ID], 
		[APP_COMM_INS_IND], [SUBSIDY_COMM_INS_IND], [ZERO_COMM_INS_IND],
		[APP_COMP_INS_IND], [SUBSIDY_COMP_INS_IND], [ZERO_COMP_INS_IND],
		[APP_VT_INS_IND], [SUBSIDY_VT_INS_IND], [ZERO_VT_INS_IND]
	)
	AS 
	(
		SELECT 
			[TMPL_ASOC].[TMPL_ASOC_ID], [TMPL_ASOC].[FNCL_PROD_ID],
			-- Commercial Insurance
			(CASE WHEN [CommercialInsurance].[INSU_DET_ATCH_ID] IS NOT NULL THEN '1' ELSE '0' END) AS [APP_COMM_INS_IND],
			(CASE WHEN [CommercialInsurance].[INRT_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_COMM_INS_IND],
			(CASE WHEN [CommercialInsurance].[INRT_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_COMM_INS_IND],

			-- Compulsory Insurance
			(CASE WHEN [CompulsoryInsurance].[INSU_DET_ATCH_ID] IS NOT NULL THEN '1' ELSE '0' END) AS [APP_COMP_INS_IND],
			(CASE WHEN [CompulsoryInsurance].[INRT_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_COMP_INS_IND],
			(CASE WHEN [CompulsoryInsurance].[INRT_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_COMP_INS_IND],

			-- Vessel Tax
			(CASE WHEN [VesselTax].[INSU_DET_ATCH_ID] IS NOT NULL THEN '1' ELSE '0' END) AS [APP_VT_INS_IND],
			(CASE WHEN [VesselTax].[INRT_RATE_TYPE_ID] = 1 THEN '1' ELSE '0' END) AS [SUBSIDY_VT_INS_IND],
			(CASE WHEN [VesselTax].[INRT_RATE_TYPE_ID] = 3 THEN '1' ELSE '0' END) AS [ZERO_VT_INS_IND]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_INSU_DET_ATCH] AS [CommercialInsurance]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [CommercialInsurance].[TMPL_ASOC_ID] AND
			[CommercialInsurance].[INSU_TYPE_ID] = 3
		)
		LEFT JOIN [dbo].[FP_TMPL_INSU_DET_ATCH] AS [CompulsoryInsurance]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [CommercialInsurance].[TMPL_ASOC_ID] AND
			[CommercialInsurance].[INSU_TYPE_ID] = 1
		)
		LEFT JOIN [dbo].[FP_TMPL_INSU_DET_ATCH] AS [VesselTax]
		ON
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [CommercialInsurance].[TMPL_ASOC_ID] AND
			[CommercialInsurance].[INSU_TYPE_ID] = 4
		)
	),
	FP_TMPL_RNDG_DET ([TMPL_ASOC_ID], [FNCL_PROD_ID], [PREPAY_IND], [SD_ROUND_IND], [SD_ROUND])
	AS
    (
        SELECT  [TMPL_ASOC].[TMPL_ASOC_ID],[TMPL_ASOC].[FNCL_PROD_ID], 
		(CASE WHEN [RNDG_DET_ATCH_DOWN_PAYMENT].[TMPL_RNDG_DET_ATCH_ID] IS NOT NULL  THEN 1 ELSE 0 END) AS [PREPAY_IND],
		(CASE WHEN [RNDG_DET_ATCH_SECURITY_DEPOSIT].[TMPL_RNDG_DET_ATCH_ID] IS NOT NULL  THEN 1 ELSE 0 END) AS [SD_ROUND_IND],
		(CASE WHEN [RNDG_DET_ATCH_SECURITY_DEPOSIT].[TMPL_RNDG_DET_ATCH_ID] IS NOT NULL  THEN [RNDG_DET_ATCH_SECURITY_DEPOSIT].PRCN_LEVL ELSE 0 END) AS [SD_ROUND]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		LEFT JOIN [dbo].[FP_TMPL_RNDG_DET_ATCH] AS [RNDG_DET_ATCH_DOWN_PAYMENT] 
		ON 
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [RNDG_DET_ATCH_DOWN_PAYMENT].[TMPL_ASOC_ID] AND [RNDG_DET_ATCH_DOWN_PAYMENT].[AMNT_CMPT_TYPE_KEY] = 'Down Payment'
		)
		LEFT JOIN [dbo].[FP_TMPL_RNDG_DET_ATCH] AS [RNDG_DET_ATCH_SECURITY_DEPOSIT] 
		ON 
		(
			[TMPL_ASOC].[TMPL_ASOC_ID] = [RNDG_DET_ATCH_SECURITY_DEPOSIT].[TMPL_ASOC_ID] AND [RNDG_DET_ATCH_SECURITY_DEPOSIT].[AMNT_CMPT_TYPE_KEY] = 'Security Deposit'
		)
    ),
	TMPL_OVRD_ATCH ([TMPL_ASOC_ID], [FNCL_PROD_ID], [PNTY_TYPE_KEY], [LATE_PNTY_PCNT], [OVERDUE_ATCUAL_RATE])
	AS
	(
		SELECT 
			[TMPL_ASOC].[TMPL_ASOC_ID], [TMPL_ASOC].[FNCL_PROD_ID], [OVRD_ATCH].[PNTY_TYPE_KEY], [OVRD_ATCH].[LATE_PNTY_PCNT], [OTHER_OVRD_ATCH].[LATE_PNTY_PCNT] AS [OVERDUE_ATCUAL_RATE]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC] 
		LEFT JOIN [dbo].[FP_TMPL_OVRD_ATCH] AS [OVRD_ATCH] ON [TMPL_ASOC].TMPL_ASOC_ID = [OVRD_ATCH].[TMPL_ASOC_ID]
			AND [OVRD_ATCH].[PNTY_TYPE_KEY] = 'Margin %'
		LEFT JOIN [dbo].[FP_TMPL_OVRD_ATCH] AS [OTHER_OVRD_ATCH] ON [TMPL_ASOC].TMPL_ASOC_ID = [OTHER_OVRD_ATCH].[TMPL_ASOC_ID]
			AND [OVRD_ATCH].[PNTY_TYPE_KEY] <> 'Margin %'

	),
	FP_FIELDS AS
	(
		SELECT 
		[TMPL_ASOC].[FNCL_PROD_ID],[TMPL_ASOC].[TMPL_ASOC_ID],
		[PURCHASE_TAX].[CMPT_APLC_IND] AS [APP_PT_IND], 
		(CASE WHEN [PURCHASE_TAX].[INRT_RATE_TYPE_ID] = 1 AND  [PURCHASE_TAX].[CMPT_APLC_IND] = 1 THEN 1 ELSE 0 END) AS [SUBSIDY_PT_IND],
		(CASE WHEN [PURCHASE_TAX].[INRT_RATE_TYPE_ID] = 3 AND  [PURCHASE_TAX].[CMPT_APLC_IND] = 1 THEN 1 ELSE 0 END) AS [ZERO_PT_IND],
		[FNCL_PROD].[NME], [FNCL_PROD].[FNCL_PROD_GRP_ID], [FNCL_PROD].[DSCR], [FNCL_PROD].[VLDY_STRT_DTE], [FNCL_PROD].[VLDY_END_DTE],
		[FNCL_PROD_GRP].[FINC_TYPE_KEY],
		[TMPL_RNTL_ATCH].[RNTL_AMRT_MTHD_TYPE_KEY], [TMPL_RNTL_ATCH].[SBDY_CALC_MTHD_TYPE_ID], [TMPL_RNTL_ATCH].[INRT_TYPE_KEY],
		[TMPL_RNTL_ATCH].[RNTL_CALC_MTHD_TYPE_KEY], [TMPL_RNTL_ATCH].[STRC_RNTL_IND], [TMPL_RNTL_ATCH].[DOWN_PYMT_APLC_IND],
		[TMPL_RNTL_ATCH].[SECR_DPST_APLC_IND], [TMPL_RNTL_ATCH].[SECR_DPST_CALC_MTHD_TYPE_ID], [TMPL_RNTL_ATCH].[NUMB_OF_RNTL],
		[TMPL_RNTL_ATCH].[SECR_DPST_PCNT], [TMPL_RNTL_ATCH].[WVED_RNTL], [TMPL_RNTL_ATCH].[PYMT_WAVR_IND], [TMPL_RNTL_ATCH].[SNGL_PYMT_IND],
		[TMPL_RNTL_ATCH].[RV_BLON_APLC_TYPE_KEY], [TMPL_RNTL_ATCH].[RV_CALC_MTHD_TYPE_KEY],
		[TMPL_RNDG_ATCH].[ADJT_LAST_RNTL_IND],
		(CASE 
				WHEN [TMPL_RNTL_ATCH].[SNGL_PYMT_IND] = 1 THEN 'G'
				WHEN [TMPL_RNTL_ATCH].[PYMT_WAVR_IND] = 1 THEN 'P'
				WHEN [TMPL_RNTL_ATCH].[SKIP_PYMT_IND] = 1 THEN 'K'
				ELSE NULL
			END) AS [LEASE_SUBTYPE]
		FROM [dbo].[FP_TMPL_ASOC] AS [TMPL_ASOC]
		JOIN [dbo].[FP_FNCL_PROD] AS [FNCL_PROD] ON [TMPL_ASOC].[FNCL_PROD_ID] = [FNCL_PROD].[FNCL_PROD_ID]
		JOIN [dbo].[FP_FNCL_PROD_GRP] AS [FNCL_PROD_GRP] ON [FNCL_PROD].[FNCL_PROD_GRP_ID] = [FNCL_PROD_GRP].[FNCL_PROD_GRP_ID]
		JOIN [dbo].[FP_TMPL_RNTL_ATCH] AS [TMPL_RNTL_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [TMPL_RNTL_ATCH].[TMPL_ASOC_ID]
		JOIN [dbo].[FP_TMPL_RNDG_ATCH] AS [TMPL_RNDG_ATCH] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [TMPL_RNDG_ATCH].[TMPL_ASOC_ID]
		JOIN [dbo].[FP_TMPL_RNTL_VADD_CONF_ATCH] AS [PURCHASE_TAX] ON [TMPL_ASOC].[TMPL_ASOC_ID] = [PURCHASE_TAX].[TMPL_ASOC_ID]
	), dt as
	(
		SELECT 
			-- Charge able pay type.
			FP_CHRG_ABLE_PAY_TYPE.[APP_SER_FEE], FP_CHRG_ABLE_PAY_TYPE.[SUBSIDY_SER_FEE], FP_CHRG_ABLE_PAY_TYPE.[ZERO_SER_FEE],
			FP_CHRG_ABLE_PAY_TYPE.[APP_REG_FEE], FP_CHRG_ABLE_PAY_TYPE.[SUBSIDY_REG_FEE], FP_CHRG_ABLE_PAY_TYPE.[ZERO_REG_FEE],
			FP_CHRG_ABLE_PAY_TYPE.[APP_SUN_FEE], FP_CHRG_ABLE_PAY_TYPE.[SUBSIDY_SUN_FEE], FP_CHRG_ABLE_PAY_TYPE.[ZERO_SUN_FEE],
			-- Insurance type.
			FP_INSURANCE.[APP_COMM_INS_IND], FP_INSURANCE.[SUBSIDY_COMM_INS_IND], FP_INSURANCE.[ZERO_COMM_INS_IND],
			FP_INSURANCE.[APP_COMP_INS_IND], FP_INSURANCE.[SUBSIDY_COMP_INS_IND], FP_INSURANCE.[ZERO_COMP_INS_IND],
			FP_INSURANCE.[APP_VT_INS_IND], FP_INSURANCE.[SUBSIDY_VT_INS_IND], FP_INSURANCE.[ZERO_VT_INS_IND],
			2 AS [CompanyId], FP_TMPL_RNDG_DET.[PREPAY_IND], FP_TMPL_RNDG_DET.[SD_ROUND_IND], FP_TMPL_RNDG_DET.[SD_ROUND],
			TMPL_OVRD_ATCH.[PNTY_TYPE_KEY], TMPL_OVRD_ATCH.[LATE_PNTY_PCNT], TMPL_OVRD_ATCH.[OVERDUE_ATCUAL_RATE],
			FP_FIELDS.*
		FROM FP_FIELDS
		JOIN FP_CHRG_ABLE_PAY_TYPE ON FP_FIELDS.[TMPL_ASOC_ID] = FP_CHRG_ABLE_PAY_TYPE.[TMPL_ASOC_ID]
		JOIN FP_INSURANCE ON FP_FIELDS.[TMPL_ASOC_ID] = FP_INSURANCE.[TMPL_ASOC_ID]
		JOIN FP_TMPL_RNDG_DET ON FP_FIELDS.[TMPL_ASOC_ID] = FP_TMPL_RNDG_DET.[TMPL_ASOC_ID]
		JOIN TMPL_OVRD_ATCH ON FP_FIELDS.[TMPL_ASOC_ID] = TMPL_OVRD_ATCH.[TMPL_ASOC_ID]
	) 
	
	MERGE INTO [dbo].[FinancialProduct] AS Target
	USING
	(
		SELECT [dt].* FROM [dt]
	)
	AS [Source]
		ON 
		(
			[Target].[FinancialProductID] = [Source].[FNCL_PROD_ID]
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET
			[Target].[FinancialGroupID] = [Source].[FNCL_PROD_GRP_ID],
			[Target].[ProductName] = [Source].[NME],
			[Target].[ProductFullName] = [Source].[DSCR],
			[Target].[FinancialParameterID] = [Source].[FNCL_PROD_ID],
			[Target].[ValidFromDate] = [Source].[VLDY_STRT_DTE],
			[Target].[ValidToDate] = [Source].[VLDY_END_DTE],
			[Target].[OperatingBusiness] = [Source].[FINC_TYPE_KEY],
			[Target].[LeaseType] = [Source].[FINC_TYPE_KEY],
			[Target].[AmortizationMethod] = [Source].[RNTL_AMRT_MTHD_TYPE_KEY],
			[Target].[CommissionSubsidyInd] = [Source].[SBDY_CALC_MTHD_TYPE_ID],
			[Target].[FixVariableType] = [Source].[INRT_TYPE_KEY],
			[Target].[RentalCalculationMethod] = [Source].[RNTL_CALC_MTHD_TYPE_KEY],
			[Target].[StructuredRentalInd] = [Source].[STRC_RNTL_IND],
			[Target].[PrepayInd] = [Source].[DOWN_PYMT_APLC_IND],
			[Target].[SdAppInd] = [Source].[SECR_DPST_APLC_IND],
			[Target].[SdPctRentalInd] = [Source].[SECR_DPST_CALC_MTHD_TYPE_ID],
			[Target].[SdRental] = [Source].[NUMB_OF_RNTL],
			[Target].[SdCtrAmtPct] = [Source].[SECR_DPST_PCNT],
			[Target].[WaivedRental] = [Source].[WVED_RNTL],
			[Target].[WaivedRentalInd] = [Source].[PYMT_WAVR_IND],
			[Target].[SinglePaymentInd] = [Source].[SNGL_PYMT_IND],
			[Target].[LeaseSubType] = [Source].[LEASE_SUBTYPE],
			[Target].[FutureValueType] = [Source].[RV_CALC_MTHD_TYPE_KEY],
			[Target].[LastrentalRoundingInd] = [Source].[ADJT_LAST_RNTL_IND],
			-- Purchase Tax
			[Target].[AppPtInd] = [Source].[APP_PT_IND],
			[Target].[SubsidyPtInd] = [Source].[SUBSIDY_PT_IND],
			[Target].[ZeroPtInd] = [Source].[ZERO_PT_IND],
			-- Service Contract Fee
			[Target].[AppSerFeeInd] = [Source].[APP_SER_FEE],
			[Target].[SubsidySerFeeInd] = [Source].[SUBSIDY_SER_FEE],
			[Target].[ZeroSerFeeInd] = [Source].[ZERO_SER_FEE],
			-- Registration Fee
			[Target].[AppRegFeeInd] = [Source].[APP_REG_FEE],
			[Target].[SubsidyRegFeeInd] = [Source].[SUBSIDY_REG_FEE],
			[Target].[ZeroRegFeeInd] = [Source].[ZERO_REG_FEE],
			-- Sundry Fee
			[Target].[AppSunFeeInd] = [Source].[APP_SUN_FEE],
			[Target].[SubsidySunFeeInd] = [Source].[SUBSIDY_SUN_FEE],
			[Target].[ZeroSunFeeInd] = [Source].[ZERO_SUN_FEE],
			-- Compulsory Insurance
			[Target].[AppCompInsInd] = [Source].[APP_COMP_INS_IND],
			[Target].[SubsidyCompInsInd] = [Source].[SUBSIDY_COMP_INS_IND],
			[Target].[ZeroCompInsInd] = [Source].[ZERO_COMP_INS_IND],
			-- Commercial Insurance
			[Target].[AppCommInsInd] = [Source].[APP_COMM_INS_IND],
			[Target].[SubsidyCommInsInd] = [Source].[SUBSIDY_COMM_INS_IND],
			[Target].[ZeroCommInsInd] = [Source].[ZERO_COMM_INS_IND],
			-- Vessel Tax
			[Target].[AppVtInd] = [Source].[APP_VT_INS_IND],
			[Target].[SubsidyVtInd] = [Source].[SUBSIDY_VT_INS_IND],
			[Target].[ZeroVtInd] = [Source].[ZERO_VT_INS_IND],

			[Target].[OdCalcBaseStatus] = [Source].[PNTY_TYPE_KEY],
			[Target].[OdInterestPct] = [Source].[LATE_PNTY_PCNT],
			[Target].[OverdueActualRate] = [Source].[OVERDUE_ATCUAL_RATE],
			[Target].[PrepayRndInd] = [Source].[PREPAY_IND],
			[Target].[SdRoundInd] = [Source].[SD_ROUND_IND],
			[Target].[SdRound] = [Source].[SD_ROUND]

	WHEN NOT MATCHED BY TARGET THEN
		-- insert new rows 
		INSERT ([FinancialProductID], [FinancialGroupID], [ProductName], [ProductFullName], [FinancialParameterID], [ValidFromDate], [ValidToDate],
				[OperatingBusiness], [LeaseType], [AmortizationMethod], [CommissionSubsidyInd], [FixVariableType], [RentalCalculationMethod], [StructuredRentalInd],
				[PrepayInd], [SdAppInd], [SdPctRentalInd], [SdRental], [SdCtrAmtPct], [WaivedRental], [WaivedRentalInd], [SinglePaymentInd], [LeaseSubType],
				[FutureValueType], [LastrentalRoundingInd], [AppPtInd], [SubsidyPtInd], [ZeroPtInd], 
				[AppSerFeeInd], [SubsidySerFeeInd], [ZeroSerFeeInd],
				[AppRegFeeInd], [SubsidyRegFeeInd], [ZeroRegFeeInd],
				[AppSunFeeInd], [SubsidySunFeeInd], [ZeroSunFeeInd],
				[AppCompInsInd], [SubsidyCompInsInd], [ZeroCompInsInd],
				[AppCommInsInd], [SubsidyCommInsInd], [ZeroCommInsInd],
				[AppVtInd], [SubsidyVtInd], [ZeroVtInd],[OdCalcBaseStatus], [OdInterestPct], [PrepayRndInd], [SdRoundInd], [SdRound], [OverdueActualRate], [CompanyId])
		VALUES ([Source].[FNCL_PROD_ID], [Source].[FNCL_PROD_GRP_ID], [Source].[NME], [Source].[DSCR], [Source].[FNCL_PROD_ID], [Source].[VLDY_STRT_DTE], [Source].[VLDY_END_DTE],
				[Source].[FINC_TYPE_KEY], [Source].[FINC_TYPE_KEY], [Source].[RNTL_AMRT_MTHD_TYPE_KEY], [Source].[SBDY_CALC_MTHD_TYPE_ID], [Source].[INRT_TYPE_KEY], 
				[Source].[RNTL_CALC_MTHD_TYPE_KEY], [Source].[STRC_RNTL_IND], [Source].[DOWN_PYMT_APLC_IND], [Source].[SECR_DPST_APLC_IND], [Source].[SECR_DPST_CALC_MTHD_TYPE_ID], 
				[Source].[NUMB_OF_RNTL], [Source].[SECR_DPST_PCNT], [Source].[WVED_RNTL], [Source].[PYMT_WAVR_IND], [Source].[SNGL_PYMT_IND], [Source].[LEASE_SUBTYPE], [Source].[RV_CALC_MTHD_TYPE_KEY], 
				[Source].[ADJT_LAST_RNTL_IND], [Source].[APP_PT_IND], [Source].[SUBSIDY_PT_IND], [Source].[ZERO_PT_IND], 
				[Source].[APP_SER_FEE], [Source].[SUBSIDY_SER_FEE], [Source].[ZERO_SER_FEE],
			    [Source].[APP_REG_FEE], [Source].[SUBSIDY_REG_FEE], [Source].[ZERO_REG_FEE],
				[Source].[APP_SUN_FEE], [Source].[SUBSIDY_SUN_FEE], [Source].[ZERO_SUN_FEE],
				[Source].[APP_COMP_INS_IND], [Source].[SUBSIDY_COMP_INS_IND], [Source].[ZERO_COMP_INS_IND],
				[Source].[APP_COMM_INS_IND], [Source].[SUBSIDY_COMM_INS_IND], [Source].[ZERO_COMM_INS_IND],
				[Source].[APP_VT_INS_IND], [Source].[SUBSIDY_VT_INS_IND], [Source].[ZERO_VT_INS_IND], 
				[Source].[PNTY_TYPE_KEY], [Source].[LATE_PNTY_PCNT], [Source].[PREPAY_IND], [Source].[SD_ROUND_IND], [Source].[SD_ROUND], [Source].[OVERDUE_ATCUAL_RATE],
				'$CompanyId$')

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE;

	PRINT 'FinancialProduct merge script ran successfully.'
END TRY
BEGIN CATCH
	  SELECT  
      ERROR_NUMBER() AS ErrorNumber  
     ,ERROR_SEVERITY() AS ErrorSeverity  
     ,ERROR_STATE() AS ErrorState  
     ,ERROR_PROCEDURE() AS ErrorProcedure  
     ,ERROR_LINE() AS ErrorLine  
     ,ERROR_MESSAGE() AS ErrorMessage;  

	 PRINT 'FinancialProduct in dbo.Relationship.Table.sql.'

END CATCH;