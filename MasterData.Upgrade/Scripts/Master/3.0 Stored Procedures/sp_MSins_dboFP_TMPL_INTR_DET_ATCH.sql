/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_INTR_DET_ATCH]    Script Date: 2/27/2020 3:09:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_INTR_DET_ATCH]
    @TMPL_INTR_DET_ATCH_ID int,
    @BUSS_PTNR_ID int,
    @BP_ROLE_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @TMPL_INTR_ATCH_ID int,
    @TMPL_ASOC_ID int
as
begin  
	declare @FinancialProductId int;
	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'I' and not (@FinancialProductId is null)
	begin
		if not exists (select 1 from [dbo].[FinancialProductBP] where [FinancialProductID] = @FinancialProductId and [BusinessPartnerID] = @BUSS_PTNR_ID)
		begin
			INSERT INTO [dbo].[FinancialProductBP]
				   ([FinancialProductID]
				   ,[BusinessPartnerID]
				   ,[RoleID]
				   ,[CreationDate]
				   ,[CompanyID])
			 VALUES
				   (@FinancialProductId
				   ,@BUSS_PTNR_ID
				   ,@BP_ROLE_ID
				   ,GETDATE()
				   ,2)
		end
	end

end  
GO