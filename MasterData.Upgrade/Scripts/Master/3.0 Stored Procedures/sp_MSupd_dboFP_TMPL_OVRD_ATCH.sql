/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboFP_TMPL_OVRD_ATCH]    Script Date: 3/5/2020 5:03:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_OVRD_ATCH]
		@TMPL_OVRD_ATCH_ID int,
		@PNTY_TYPE_KEY varchar(25),
		@LATE_PNTY_PCNT decimal(21,5),
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_ASOC_ID int,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@bitmap binary(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

	
	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'D' and not (@FinancialProductId is null)
	begin
		if @PNTY_TYPE_KEY = 'Margin %'
			update [dbo].[FinancialProduct] 
				set [OdCalcBaseStatus] = NULL,
					[OdInterestPct]    = NULL
			
			WHERE [FinancialProductID] = @FinancialProductId
		else
			update [dbo].[FinancialProduct] 
				set [OverdueActualRate] = NULL
			WHERE [FinancialProductID] = @FinancialProductId
	end
	else
	begin
		if @PNTY_TYPE_KEY = 'Margin %'
		begin
			update [dbo].[FinancialProduct] 
				set [OdCalcBaseStatus] = @PNTY_TYPE_KEY,
					[OdInterestPct]    = @LATE_PNTY_PCNT
			
			WHERE [FinancialProductID] = @FinancialProductId

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[TMPL_OVRD_ATCH_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
							set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@pkc2,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_OVRD_ATCH]', @param2=@primarykey_text, @param3=13233 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End 
		end
		else
		begin
			update [dbo].[FinancialProduct] 
				set [OverdueActualRate]    = @LATE_PNTY_PCNT
			WHERE [FinancialProductID] = @FinancialProductId

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[TMPL_OVRD_ATCH_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
							set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@pkc2,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_OVRD_ATCH]', @param2=@primarykey_text, @param3=13233 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End 
		end
	end
end 
GO