IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_RNDG_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_RNDG_ATCH]
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