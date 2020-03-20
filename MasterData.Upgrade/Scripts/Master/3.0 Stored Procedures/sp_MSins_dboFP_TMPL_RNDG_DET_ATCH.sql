/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_RNDG_DET_ATCH]    Script Date: 3/5/2020 5:02:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_RNDG_DET_ATCH]
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
	
	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'I' and not (@FinancialProductId is null)
	begin
		
		if @AMNT_CMPT_TYPE_KEY = 'Down Payment'
			update [dbo].[FinancialProduct] set [PrepayRndInd] = 1 where [FinancialProductID] = @FinancialProductId

		if @AMNT_CMPT_TYPE_KEY = 'Security Deposit'
			update [dbo].[FinancialProduct] set [SdRoundInd] = 1, [SdRound] = @PRCN_LEVL where [FinancialProductID] = @FinancialProductId
	end
	
end  
GO