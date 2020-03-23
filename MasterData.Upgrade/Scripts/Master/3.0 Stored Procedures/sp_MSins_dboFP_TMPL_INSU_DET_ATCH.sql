IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_INSU_DET_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_INSU_DET_ATCH]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_INSU_DET_ATCH]
    @INSU_DET_ATCH_ID int,
    @TMPL_INSU_ATCH_ID int,
    @INSU_TYPE_ID int,
    @INRT_RATE_TYPE_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(11),
    @TMPL_ASOC_ID int
as
begin  
	
    declare @FinancialProductId int, @FinancialParameterId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'I' AND NOT (@FinancialProductId IS NULL)
	begin

		if @INSU_TYPE_ID = 1  -- Compulsory Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCompInsInd]	   = '1',
				[SubsidyCompInsInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroCompInsInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end

		if @INSU_TYPE_ID = 3  -- Commercial Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCommInsInd]	   = '1',
				[SubsidyCommInsInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroCommInsInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end

		if @INSU_TYPE_ID = 4  -- Vessel Tax
		begin
			update [dbo].[FinancialProduct] set
				[AppVtInd]	   = '1',
				[SubsidyVtInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroVtInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
	end
end  
GO