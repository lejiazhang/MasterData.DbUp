IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_TMPL_CHRG_PAY_DET_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_TMPL_CHRG_PAY_DET_ATCH]
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_CHRG_PAY_DET_ATCH]
		@TMPL_CHRG_PAY_DET_ATCH_ID_OLD int,
		@FINC_IND_OLD bit,
		@CHRG_RATE_TYPE_ID_OLD int,
		@INSR_DTE_OLD datetime,
		@UPDT_DTE_OLD datetime,
		@EXEC_DTE_OLD datetime,
		@FLAG_OLD char(1),
		@TMPL_CHRG_PAY_ABLE_ATCH_ID_OLD int,
		@TMPL_ASOC_ID_OLD int,
		@CHRG_PAY_ABLE_TYPE_ID_OLD int,
		@TMPL_CHRG_PAY_DET_ATCH_ID int,
		@FINC_IND bit,
		@CHRG_RATE_TYPE_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_CHRG_PAY_ABLE_ATCH_ID int,
		@TMPL_ASOC_ID int,
		@CHRG_PAY_ABLE_TYPE_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	
	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'D' and not (@FinancialProductId is null)
	begin
		IF @CHRG_PAY_ABLE_TYPE_ID = 1092 -- Service Contract Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSerFeeInd]	   = '0',
				[SubsidySerFeeInd] = '0',
			    [ZeroSerFeeInd]	   = '0'
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1093 -- Registration Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppRegFeeInd]	   = '0',
				[SubsidyRegFeeInd] = '0',
			    [ZeroRegFeeInd]	   = '0'
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1095 -- Sundry Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSunFeeInd]	   = '0',
				[SubsidySunFeeInd] = '0',
			    [ZeroSunFeeInd]	   = '0'
			where [FinancialProductID] = @FinancialProductId
		end
	end
	else
	begin
		IF @CHRG_PAY_ABLE_TYPE_ID = 1092 -- Service Contract Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSerFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidySerFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroSerFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1093 -- Registration Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppRegFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidyRegFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroRegFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1095 -- Sundry Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSunFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidySunFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroSunFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
	end
	
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
				
					set @primarykey_text = @primarykey_text + '[TMPL_CHRG_PAY_DET_ATCH_ID] = ' + convert(nvarchar(100),@TMPL_CHRG_PAY_DET_ATCH_ID_OLD,1) + ', '
					set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID_OLD,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_CHRG_PAY_DET_ATCH]', @param2=@primarykey_text, @param3=13233 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End
end 
GO


