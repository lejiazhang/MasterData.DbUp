IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboFP_TMPL_RNTL_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboFP_TMPL_RNTL_ATCH]
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_ATCH]
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

	if not (@FinancialProductId is null and @FinancialParameterId is null)
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

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[TMPL_RNTL_ATCH_ID] = ' + convert(nvarchar(100),@c1,1) + ', '
						set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@c21,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_ATCH]', @param2=@primarykey_text, @param3=13234 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
				End
	end
end  
GO