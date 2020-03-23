IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_TMPL_RNDG_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_TMPL_RNDG_ATCH]
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_RNDG_ATCH]
		@TMPL_RNDG_ATCH_ID int,
		@ADJT_LAST_RNTL_IND bit,
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
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @pkc2

	if @FLAG = 'D' and not (@FinancialProductId is null)
	begin
		update [dbo].[FinancialProduct] set [LastrentalRoundingInd] = NULL WHERE [FinancialProductID] = @FinancialProductId 
	end
	else
	begin
		update [dbo].[FinancialProduct] set [LastrentalRoundingInd] = @ADJT_LAST_RNTL_IND WHERE [FinancialProductID] = @FinancialProductId

		 if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[TMPL_RNDG_ATCH_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
						set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@pkc2,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNDG_ATCH]', @param2=@primarykey_text, @param3=13233 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
		End
	end
end 
GO

