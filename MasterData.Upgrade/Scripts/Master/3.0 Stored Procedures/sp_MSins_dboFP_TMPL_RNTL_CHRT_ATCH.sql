IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_RNTL_CHRT_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_RNTL_CHRT_ATCH]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_RNTL_CHRT_ATCH]
    @TMPL_RNTL_CHRT_ATCH_ID int,
    @TMPL_RNTL_ATCH_ID int,
    @CHRT_MSTR_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @TMPL_ASOC_ID int
as
begin  
	declare @FinancialProductId int,
			@TransactionTypeId int;

	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	select  @TransactionTypeId = [TransactionTypeID] from [ChartMain] where [ChartMainID] = @CHRT_MSTR_ID

	if @FLAG = 'I' and not (@FinancialProductId is null)
	begin
		if not exists (select 1 from [dbo].[FinancialParameterChart] where [FinancialParameterID] = @FinancialProductId and [ChartMainID] = @CHRT_MSTR_ID and [TransactionTypeID] = @TransactionTypeId)
		begin
			INSERT INTO [dbo].[FinancialParameterChart]
				   ([ChartMainID]
				   ,[FinancialParameterID]
				   ,[TransactionTypeID]
				   ,[CreationDate]
				   ,[InsertedBy]
				   ,[CompanyID])
			 VALUES
				   (@CHRT_MSTR_ID
				   ,@FinancialProductId
				   ,@TransactionTypeId
				   ,GETDATE()
				   ,'New Sync'
				   ,'$CompanyId$')
		end
	end

end  
GO