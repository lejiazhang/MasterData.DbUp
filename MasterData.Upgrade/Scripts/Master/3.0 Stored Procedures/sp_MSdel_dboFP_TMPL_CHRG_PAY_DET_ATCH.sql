/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_TMPL_CHRG_PAY_DET_ATCH]    Script Date: 3/10/2020 6:52:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_CHRG_PAY_DET_ATCH]
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

	if not (@FinancialProductId is null)
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

if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TMPL_CHRG_PAY_DET_ATCH_ID] = ' + convert(nvarchar(100),@TMPL_CHRG_PAY_DET_ATCH_ID,1) + ', '
				set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_CHRG_PAY_DET_ATCH]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
GO
