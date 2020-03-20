/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_TMPL_RNDG_DET_ATCH]    Script Date: 3/9/2020 3:47:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_RNDG_DET_ATCH]
		@TMPL_RNDG_DET_ATCH_ID int,
		@AMNT_CMPT_TYPE_KEY varchar(20),
		@TMPL_RNDG_ATCH_ID int,
		@PRCN_LEVL decimal(4,2),
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_ASOC_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	
	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if not (@FinancialProductId is null)
	begin
		if @AMNT_CMPT_TYPE_KEY = 'Down Payment'
			update [dbo].[FinancialProduct] set [PrepayRndInd] = NULL where [FinancialProductID] = @FinancialProductId

		if @AMNT_CMPT_TYPE_KEY = 'Security Deposit'
			update [dbo].[FinancialProduct] set [SdRoundInd] = NULL, [SdRound] = NULL where [FinancialProductID] = @FinancialProductId

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[TMPL_RNDG_DET_ATCH_ID] = ' + convert(nvarchar(100),@TMPL_RNDG_DET_ATCH_ID,1) + ', '
						set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNDG_DET_ATCH]', @param2=@primarykey_text, @param3=13234 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
				End
end 
end
GO
