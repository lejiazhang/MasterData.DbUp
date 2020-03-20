USE [NPOS_PROD_Master_LC]
GO

/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_FREQ_DET_ATCH]    Script Date: 3/6/2020 6:33:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_FREQ_DET_ATCH]
		@TMPL_RNTL_FREQ_DET_ATCH_ID int,
		@RNTL_FREQ_KEY varchar(25),
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_RNTL_FREQ_ATCH_ID int,
		@TMPL_ASOC_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	declare @FinancialProductId int;

	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if not (@FinancialProductId is null)
	begin
		if exists (select 1 from [dbo].[FinancialPaymentFrequency] where [FinancialParameterID] = @FinancialProductId and [PaymentFrequencyID] = @RNTL_FREQ_KEY)
			delete from [dbo].[FinancialPaymentFrequency] where [FinancialParameterID] = @FinancialProductId and [PaymentFrequencyID] = @RNTL_FREQ_KEY
			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID,1) + ', '
							set @primarykey_text = @primarykey_text + '[TMPL_RNTL_FREQ_DET_ATCH_ID] = ' + convert(nvarchar(100),@TMPL_RNTL_FREQ_DET_ATCH_ID,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_FREQ_DET_ATCH]', @param2=@primarykey_text, @param3=13234 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End
	end
	
	
end  
GO