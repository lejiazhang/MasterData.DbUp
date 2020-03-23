IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboBP_MAIN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboBP_MAIN]
GO

create procedure [dbo].[sp_MSdel_dboBP_MAIN]
		@pkc1 int
as

declare @primarykey_text nvarchar(100) = ''

if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1)
begin  
	
	delete [dbo].[BusinessPartner]
	where [BusinessPartnerID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
			set @primarykey_text = @primarykey_text + '[BUSS_PTNR_ID] = ' + convert(nvarchar(100),@pkc1,1)
			exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_MAIN]', @param2=@primarykey_text, @param3=13234
		End
end  

if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @pkc1)
begin  
	delete [dbo].[BusinessPartnerCompany]
	where [BusinessPartnerID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
			set @primarykey_text = @primarykey_text + '[BUSS_PTNR_ID] = ' + convert(nvarchar(100),@pkc1,1)
			exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_MAIN]', @param2=@primarykey_text, @param3=13234
		End
end  

if exists (select 1 from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @pkc1)
begin  
	delete [dbo].[BusinessPartnerCompany]
	where [BusinessPartnerID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
			set @primarykey_text = @primarykey_text + '[BUSS_PTNR_ID] = ' + convert(nvarchar(100),@pkc1,1)
			exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_MAIN]', @param2=@primarykey_text, @param3=13234
		End
end  

GO