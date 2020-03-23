IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_RNTL_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_RNTL_ATCH]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_ATCH]
    @TMPL_RNTL_ATCH_ID int,
    @RNTL_MODE_KEY varchar(8),
    @RNTL_AMRT_MTHD_TYPE_KEY varchar(25),
    @SBDY_CALC_MTHD_TYPE_ID varchar(25),
    @INRT_TYPE_KEY varchar(10),
    @RNTL_CALC_MTHD_TYPE_KEY varchar(25),
    @STRC_RNTL_IND bit,
    @DOWN_PYMT_APLC_IND bit,
    @SECR_DPST_APLC_IND bit,
    @SECR_DPST_CALC_MTHD_TYPE_ID int,
    @NUMB_OF_RNTL int,
    @SECR_DPST_PCNT decimal(8,5),
    @RV_CALC_MTHD_TYPE_KEY varchar(25),
    @WVED_RNTL int,
    @PYMT_WAVR_IND bit,
    @SNGL_PYMT_IND bit,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime, 
    @FLAG char(1),
	@TMPL_ASOC_ID int,
	@SKIP_PYMT_IND bit,
	@RV_BLON_APLC_TYPE_KEY varchar(10)
as
begin  

    declare @FinancialProductId int, @FinancialParameterId int;

	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	select @FinancialParameterId = [FinancialParameterID] from [dbo].[FinancialParameter] where [FinancialParameterID] = @FinancialProductId

	if @FLAG = 'I' and not (@FinancialParameterId is null and  @FinancialProductId is null)
	begin
		
		declare @LeaseSubtype char(1);
		
		set @LeaseSubtype = 
		(
			CASE 
				WHEN @SNGL_PYMT_IND = 1 THEN 'G'
				WHEN @PYMT_WAVR_IND = 1 THEN 'P'
				WHEN @SKIP_PYMT_IND = 1 THEN 'K'
				ELSE NULL
			END
		)

		update [dbo].[FinancialParameter] set
			[RentalModeType]			= @RNTL_MODE_KEY,
			[SplitRVInd]				= @RV_CALC_MTHD_TYPE_KEY
		where [FinancialParameterID]	= @FinancialParameterId
			
		update [dbo].[FinancialProduct] set
			[AmortizationMethod]		= @RNTL_AMRT_MTHD_TYPE_KEY,
			[CommissionSubsidyInd]		= @SBDY_CALC_MTHD_TYPE_ID,
			[FixVariableType]			= @INRT_TYPE_KEY,
			[RentalCalculationMethod]	= @RNTL_CALC_MTHD_TYPE_KEY,
			[StructuredRentalInd]		= @STRC_RNTL_IND,
			[PrepayInd]					= @DOWN_PYMT_APLC_IND,
			[SdAppInd]					= @SECR_DPST_APLC_IND,
			[SdPctRentalInd]			= @SECR_DPST_CALC_MTHD_TYPE_ID,
			[SdRental]					= @NUMB_OF_RNTL,
			[SdCtrAmtPct]				= @SECR_DPST_PCNT,
			[WaivedRental]				= @WVED_RNTL,
			[WaivedRentalInd]			= @PYMT_WAVR_IND,
			[SinglePaymentInd]			= @SNGL_PYMT_IND,
			[LeaseSubType]				= @LeaseSubtype,
			[FutureValueType]			= @RV_CALC_MTHD_TYPE_KEY
		where [FinancialProductID]		= @FinancialProductId
	end

end  

GO