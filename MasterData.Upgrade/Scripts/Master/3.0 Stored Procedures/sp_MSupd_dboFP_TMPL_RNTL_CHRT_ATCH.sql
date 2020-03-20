/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboFP_TMPL_RNTL_CHRT_ATCH]    Script Date: 2/27/2020 5:53:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboFP_TMPL_RNTL_CHRT_ATCH]
		@TMPL_RNTL_CHRT_ATCH_ID int,
		@TMPL_RNTL_ATCH_ID int,
		@CHRT_MSTR_ID int,
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

	declare @FinancialProductId int,
			@TransactionTypeId int;

	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @pkc2
	select  @TransactionTypeId = [TransactionTypeID] from [ChartMain] where [ChartMainID] = @CHRT_MSTR_ID

	if @FLAG = 'D' and not (@FinancialProductId is null)
	begin
		if exists (select 1 from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId)
		begin
			delete from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId
		end
	end
	else
	begin
		if exists (select 1 from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId)
		begin
			update [dbo].[FinancialParameterChart] 
				set [ChartMainID] = @CHRT_MSTR_ID
			where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[TMPL_RNTL_CHRT_ATCH_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
							set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@pkc2,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_CHRT_ATCH]', @param2=@primarykey_text, @param3=13233 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End
		end
	end
end 
GO