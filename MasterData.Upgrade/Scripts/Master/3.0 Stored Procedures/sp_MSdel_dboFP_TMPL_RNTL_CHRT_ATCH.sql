/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_CHRT_ATCH]    Script Date: 3/6/2020 6:28:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_CHRT_ATCH]
		@TMPL_RNTL_CHRT_ATCH_ID int,
		@TMPL_RNTL_ATCH_ID int,
		@CHRT_MSTR_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_ASOC_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	declare @FinancialProductId int,
			@TransactionTypeId int;

	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	select  @TransactionTypeId = [TransactionTypeID] from [ChartMain] where [ChartMainID] = @CHRT_MSTR_ID

	if not (@FinancialProductId is null)
	begin
		if exists (select 1 from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId)
		begin
			delete from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[TMPL_RNTL_CHRT_ATCH_ID] = ' + convert(nvarchar(100),@c1,1) + ', '
							set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@c8,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_CHRT_ATCH]', @param2=@primarykey_text, @param3=13234 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
		End
		end
	end
			

end  
GO