IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboFP_FNCL_PROD_GRP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboFP_FNCL_PROD_GRP]
GO

CREATE procedure [dbo].[sp_MSdel_dboFP_FNCL_PROD_GRP]		
	@pkc1 int
as
declare @companyId smallint = 1
IF EXISTS (SELECT 1 FROM [dbo].[FinancialGroup] WHERE FinancialGroupID = @pkc1 and CompanyID = @COMPANYID)
	begin  
		declare @primarykey_text nvarchar(100) = ''
			delete [dbo].[FinancialGroup]
			where [FinancialGroupID] = @pkc1 and CompanyID = @companyId

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
			
					set @primarykey_text = @primarykey_text + '[FNCL_PROD_GRP_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_FNCL_PROD_GRP]', @param2=@primarykey_text, @param3=13234
				End
	end  
GO

