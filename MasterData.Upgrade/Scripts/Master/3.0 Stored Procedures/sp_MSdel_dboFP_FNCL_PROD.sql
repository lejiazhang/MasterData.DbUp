/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_FNCL_PROD]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_MSdel_dboFP_FNCL_PROD]
		@pkc1 int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	DECLARE @COMPANYID SMALLINT = 1

	IF EXISTS (SELECT 1 FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID)
		DELETE FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID
			
	IF EXISTS (SELECT 1 FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID)
		DELETE FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID

	DELETE FROM [dbo].[FinancialProductBP] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID
	DELETE FROM [dbo].[FinancialParameterChart] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID
	DELETE FROM [dbo].[FPAssetSelection] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID

if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
					set @primarykey_text = @primarykey_text + '[FNCL_PROD_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_FNCL_PROD]', @param2=@primarykey_text, @param3=13234
				End
		end  
GO