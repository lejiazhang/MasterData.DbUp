/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_FREQ_DET_ATCH]    Script Date: 2/27/2020 3:32:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_FREQ_DET_ATCH]
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
	
	declare @FinancialProductId int;
	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if @FLAG = 'I' and not (@FinancialProductId is null)
	begin
		if not exists (select 1 from [dbo].[FinancialPaymentFrequency] where [FinancialParameterID] = @FinancialProductId and [PaymentFrequencyID] = @RNTL_FREQ_KEY)
		begin
			 INSERT INTO [dbo].[FinancialPaymentFrequency]
				   ([FinancialParameterID]
				   ,[PaymentFrequencyID]
				   ,[CompanyID])
			 VALUES
				   (@FinancialProductId
				   ,@RNTL_FREQ_KEY
				   ,2 )
			 
		end
		
		
	end
end  
GO