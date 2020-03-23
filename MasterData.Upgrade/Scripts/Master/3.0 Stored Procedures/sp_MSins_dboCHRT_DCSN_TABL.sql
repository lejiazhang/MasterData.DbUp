IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboCHRT_DCSN_TABL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboCHRT_DCSN_TABL]
GO

create procedure [dbo].[sp_MSins_dboCHRT_DCSN_TABL]
    @DCSN_TABL_ID int,
    @MSTR_ID int,
    @ASET_TYPE varchar(25),
    @ASET_SUB_TYPE varchar(25),
    @ASET_MAKE varchar(25),
    @ASET_BRND varchar(25),
    @ASET_MODL varchar(25),
    @ASET_COND varchar(25),
    @RNTL_MODE varchar(25),
    @CONT_TERM_RANG varchar(25),
    @MIN_RATE varchar(25),
    @MAX_RATE varchar(25),
    @CHRT_VAL varchar(25),
    @STND_RATE varchar(25),
    @MAX_FINC_PCNT varchar(25),
    @RNTL_FREQ varchar(25),
    @ASET_CLFN varchar(25),
    @INTR_RATE_RANG varchar(25),
    @INTR_RTNG varchar(25),
    @FINC_TYPE varchar(25),
    @CRDT_RTNG varchar(25),
    @DOWN_PYMT_RANG varchar(25),
    @AGE_RANG varchar(25),
    @MODL_YEAR varchar(25),
    @PROD_YEAR varchar(25),
    @MILG_PER_YEAR varchar(25),
    @MNFC_SBDY_PCNT varchar(25),
    @DELR_SBDY_PCNT varchar(25),
    @PRE_PAY_PCNT varchar(25),
    @AMNT_RANG varchar(25),
    @TERM_RANG varchar(25),
    @NFA_PCNT varchar(25),
    @COMM_FIXD_AMNT varchar(25),
    @FC_COMM_AMNT varchar(25),
    @FC_COMM_PCNT varchar(25),
    @MIN_COMM_AMNT varchar(25),
    @EFCT_STRT_DTE varchar(25),
    @EFCT_END_DTE varchar(25),
    @NST_CODE varchar(25),
    @OTP_PRCE_PCNT varchar(25),
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin
    if (@c44 = 'I' and not exists (SELECT 1 FROM [dbo].[ChartDetail] WHERE [ChartDetailSEQ] = @c1))
    begin  
        insert into [dbo].[ChartDetail](
            [ChartDetailSEQ],
            [ChartMainID],
            [VehicleTypeCode],
            [AssetMakeCode],
            [AssetBrandCode],
            [AssetModelCode],
            [AssetConditionCode],
            [RentalModeType],
            [MinimumRate],
            [MaximumRate],
            [ChartValue],
            [StandardRate],
            [DownPaymentRangeID],
            [AgeRangeID],
            [ModelYearCDE],
            [ProductionYearCDE],
            [MileagePerYearCDE],
            [AmountRangeID],
            [TermRangeID],
            [NfaPercentage],
            [CommissionFixedAmount],
            [FCCommissionAmount],
            [FCCommissionPercentage],
            [MinimumCommissionAmount],
            [EffStartDate],
            [EffEndDate],
            [NST],
            [OptionPricePct],
            [CompanyID]
        ) values (
        @DCSN_TABL_ID,
        @MSTR_ID,
        @ASET_TYPE,
        @ASET_MAKE,
        @ASET_BRND,
        @ASET_MODL,
        @ASET_COND,
        @RNTL_MODE,
        @MIN_RATE,
        @MAX_RATE,
        @CHRT_VAL,
        @STND_RATE,
        @DOWN_PYMT_RANG,
        @AGE_RANG,
        @MODL_YEAR,
        @PROD_YEAR,
        @MILG_PER_YEAR,
        @AMNT_RANG,
        @TERM_RANG,
        @NFA_PCNT,
        @COMM_FIXD_AMNT,
        @FC_COMM_AMNT,
        @FC_COMM_PCNT,
        @MIN_COMM_AMNT,
        @EFCT_STRT_DTE,
        @EFCT_END_DTE,
        @NST_CODE,
        @OTP_PRCE_PCNT,
        '$CompanyId$'	) 
    end 
end

GO