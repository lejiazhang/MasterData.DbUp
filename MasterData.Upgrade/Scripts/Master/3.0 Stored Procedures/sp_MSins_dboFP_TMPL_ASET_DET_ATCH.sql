IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_ASET_DET_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_ASET_DET_ATCH]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_ASET_DET_ATCH]
    @TMPL_ASET_DET_ATCH_ID int,
    @ASET_MODL_ID int,
    @TMPL_ASET_ATCH_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @TMPL_ASOC_ID int
as
begin  

	declare @FinancialProductId int,
			@AssetModelCode int,
			@AssetModelExtDetailId int,
			@AssetMakeId int;

	set     @AssetModelExtDetailId = @ASET_MODL_ID;

	select  @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	select  @AssetModelCode = [AssetModelExtID], @AssetMakeId = [AssetMakeID] from [dbo].[AssetModelCompany] where [AssetModelExtDetailId] = @AssetModelExtDetailId

	if @FLAG = 'I' and not (@FinancialProductId is null or @AssetModelCode is null or @AssetModelExtDetailId is null or @AssetMakeId is null)
	begin
		if not exists 
			(
			 select 1 from [dbo].[FPAssetSelection] where [FinancialProductId] = @FinancialProductId	
			 and [AssetMakeCode] = @AssetMakeId	and [AssetModelCode] = @AssetModelCode		
			 and [AssetModelExtDetailId] = @AssetModelExtDetailId
			)
		begin
			INSERT INTO [dbo].[FPAssetSelection]
					   ([FinancialProductId]
					   ,[AssetMakeCode]
					   ,[AssetModelCode]
					   ,[CreationDate]
					   ,[InsertedBy]
					   ,[CompanyId]
					   ,[AssetModelExtDetailId])
				 VALUES
					   (@FinancialProductId
					   ,@AssetMakeId
					   ,@AssetModelCode
					   ,GETDATE()
					   ,'dbo'
					   ,'$CompanyId$'
					   ,@AssetModelExtDetailId)
		end

	end
	
end  
GO