/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_VADD_CONF_ATCH]    Script Date: 3/10/2020 7:09:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_VADD_CONF_ATCH]
    @RNTL_VADD_CONF_ATCH_ID int,
    @TMPL_RNTL_ATCH_ID int,
    @CMPT_APLC_IND bit,
    @INRT_RATE_TYPE_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @TMPL_ASOC_ID int
as
begin

	declare @FinancialProductId int, @FinancialParameterId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID  

	if @FLAG = 'I' AND NOT (@FinancialProductId IS NULL)
	begin
		update [dbo].[FinancialProduct] set
				[AppPtInd]	   = case @CMPT_APLC_IND when '1' then '1' else '0' end,
				[SubsidyPtInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroPtInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
		where [FinancialProductID] = @FinancialProductId
	end
end  
GO
