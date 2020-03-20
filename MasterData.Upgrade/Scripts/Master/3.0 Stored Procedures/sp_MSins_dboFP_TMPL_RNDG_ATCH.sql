/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_RNDG_ATCH]    Script Date: 3/5/2020 5:01:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_RNDG_ATCH]
    @TMPL_RNDG_ATCH_ID int,
    @ADJT_LAST_RNTL_IND bit,
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
		update [dbo].[FinancialProduct] set [LastrentalRoundingInd] = @ADJT_LAST_RNTL_IND WHERE [FinancialProductID] = @FinancialProductId
	end
end  
GO