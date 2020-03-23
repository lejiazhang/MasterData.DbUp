IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_TMPL_RNTL_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_TMPL_RNTL_ATCH]
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_RNTL_ATCH]
		@TMPL_RNTL_ATCH_ID_OLD int,
		@RNTL_MODE_KEY_OLD varchar(8),
		@RNTL_AMRT_MTHD_TYPE_KEY_OLD varchar(25),
		@SBDY_CALC_MTHD_TYPE_ID_OLD varchar(25),
		@INRT_TYPE_KEY_OLD varchar(10),
		@RNTL_CALC_MTHD_TYPE_KEY_OLD varchar(25),
		@STRC_RNTL_IND_OLD bit,
		@DOWN_PYMT_APLC_IND_OLD bit,
		@SECR_DPST_APLC_IND_OLD bit,
		@SECR_DPST_CALC_MTHD_TYPE_ID_OLD int,
		@NUMB_OF_RNTL_OLD int,
		@SECR_DPST_PCNT_OLD decimal(8,5),
		@RV_CALC_MTHD_TYPE_KEY_OLD varchar(25),
		@WVED_RNTL_OLD int,
		@PYMT_WAVR_IND_OLD bit,
		@SNGL_PYMT_IND_OLD bit,
		@INSR_DTE_OLD datetime,
		@UPDT_DTE_OLD datetime,
		@EXEC_DTE_OLD datetime,
		@FLAG_OLD char(1),
		@TMPL_ASOC_ID_OLD int,
		@SKIP_PYMT_IND_OLD bit,
		@RV_BLON_APLC_TYPE_KEY_Old varchar(10),
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

	declare @primarykey_text nvarchar(100) = ''
 
	declare @FinancialProductId int, @FinancialParameterId int;

	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	select @FinancialParameterId = [FinancialParameterID] from [dbo].[FinancialParameter] where [FinancialParameterID] = @FinancialProductId

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

	if @FLAG = 'D' and not (@FinancialProductId is null and @FinancialParameterId is null)
	begin
		update [dbo].[FinancialParameter] set
			[RentalModeType]			= NULL,
			[SplitRVInd]				= NULL
		where [FinancialParameterID]	= @FinancialParameterId

		update [dbo].[FinancialProduct] set
			[AmortizationMethod]		= NULL,
			[CommissionSubsidyInd]		= NULL,
			[FixVariableType]			= NULL,
			[RentalCalculationMethod]	= NULL,
			[StructuredRentalInd]		= NULL,
			[PrepayInd]					= NULL,
			[SdAppInd]					= NULL,
			[SdPctRentalInd]			= NULL,
			[SdRental]					= NULL,
			[SdCtrAmtPct]				= NULL,
			[WaivedRental]				= NULL,
			[WaivedRentalInd]			= NULL,
			[SinglePaymentInd]			= NULL,
			[LeaseSubType]				= NULL,
			[FutureValueType]			= NULL
		where   [FinancialProductID]	= @FinancialProductId
	end
	else
	begin
		update [dbo].[FinancialParameter] set
			[RentalModeType]			= @RNTL_MODE_KEY,
			[SplitRVInd]				= @RV_CALC_MTHD_TYPE_KEY
		where [FinancialParameterID]		= @FinancialParameterId
			
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
		where   [FinancialProductID]		= @FinancialProductId
	end

	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
				
					set @primarykey_text = @primarykey_text + '[TMPL_RNTL_ATCH_ID] = ' + convert(nvarchar(100),@TMPL_RNTL_ATCH_ID,1) + ', '
					set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_ATCH]', @param2=@primarykey_text, @param3=13233 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End
end 
GO


