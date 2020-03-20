/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboBP_MAIN]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSdel_dboBP_MAIN]
		@pkc1 int
as

if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1)
begin  
	declare @primarykey_text nvarchar(100) = ''
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
	declare @primarykey_text nvarchar(100) = ''
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
	declare @primarykey_text nvarchar(100) = ''
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