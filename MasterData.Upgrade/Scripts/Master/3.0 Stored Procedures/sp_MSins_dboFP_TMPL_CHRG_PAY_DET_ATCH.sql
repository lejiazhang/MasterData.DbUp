/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_CHRG_PAY_DET_ATCH]    Script Date: 3/10/2020 2:03:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_CHRG_PAY_DET_ATCH]
    @TMPL_CHRG_PAY_DET_ATCH_ID int,
    @FINC_IND bit,
    @CHRG_RATE_TYPE_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @TMPL_CHRG_PAY_ABLE_ATCH_ID int,
    @TMPL_ASOC_ID int,
	@CHRG_PAY_ABLE_TYPE_ID int
as
begin  
	
	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'I' AND NOT (@FinancialProductId IS NULL)
	begin
		IF @CHRG_PAY_ABLE_TYPE_ID = 1092 -- Service Contract Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSerFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidySerFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroSerFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1093 -- Registration Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppRegFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidyRegFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroRegFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
		IF @CHRG_PAY_ABLE_TYPE_ID = 1095 -- Sundry Fee
		begin
			update [dbo].[FinancialProduct] set
				[AppSunFeeInd]	   = case @FINC_IND when '1' then '1' else '0' end,
				[SubsidySunFeeInd] = case @CHRG_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroSunFeeInd]	   = case @CHRG_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
	end
end  
GO