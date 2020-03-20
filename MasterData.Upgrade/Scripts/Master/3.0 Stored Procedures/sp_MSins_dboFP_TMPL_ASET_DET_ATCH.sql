/****** Object:  StoredProcedure [dbo].[sp_MSins_dboFP_TMPL_ASET_DET_ATCH]    Script Date: 2/27/2020 3:32:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
					   ,'NEW SYNC'
					   ,2
					   ,@AssetModelExtDetailId)
		end

	end
	
end  
GO