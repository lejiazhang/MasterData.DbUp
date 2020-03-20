/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboFP_FNCL_PROD_GRP]    Script Date: 2/20/2020 9:25:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

