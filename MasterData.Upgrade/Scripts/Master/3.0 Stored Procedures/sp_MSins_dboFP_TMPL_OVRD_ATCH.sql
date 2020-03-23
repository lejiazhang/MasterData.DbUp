IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_OVRD_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_OVRD_ATCH]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_OVRD_ATCH]
    @TMPL_OVRD_ATCH_ID int,
    @PNTY_TYPE_KEY varchar(25),
    @LATE_PNTY_PCNT decimal(21,5),
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
		
		if @PNTY_TYPE_KEY = 'Margin %'
			update [dbo].[FinancialProduct] 
				set [OdCalcBaseStatus] = @PNTY_TYPE_KEY,
					[OdInterestPct]    = @LATE_PNTY_PCNT
			
			WHERE [FinancialProductID] = @FinancialProductId
		else
			update [dbo].[FinancialProduct] 
				set [OverdueActualRate] = @LATE_PNTY_PCNT
			WHERE [FinancialProductID] = @FinancialProductId
	end
end  
GO


