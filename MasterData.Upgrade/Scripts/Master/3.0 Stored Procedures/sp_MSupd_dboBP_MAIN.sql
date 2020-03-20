/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboBP_MAIN]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboBP_MAIN]
		@c1 int = NULL,
		@c2 nvarchar(605) = NULL,
		@c3 varchar(10) = NULL,
		@c4 decimal(21,5) = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 nvarchar(200) = NULL,
		@c9 nvarchar(200) = NULL,
		@c10 nvarchar(200) = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@c13 bit = NULL,
		@c14 datetime = NULL,
		@c15 datetime = NULL,
		@c16 datetime = NULL,
		@c17 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
if (@c17 = 'D')
begin
	if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1)
	begin
		delete from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1
	end

	if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @pkc1)
	begin
		delete from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @pkc1
	end

	if exists (select 1 from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @pkc1)
	begin
		delete from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @pkc1
	end
end
else
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin 

if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1)
begin
	update [dbo].[BusinessPartner] set
		[BusinessPartnerID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [BusinessPartnerID] end,
		[BusinessPartnerName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BusinessPartnerName] end,
		[LegalStatusCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LegalStatusCode] end,
		[RegistrationFee] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RegistrationFee] end,
		[CreationDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreationDate] end
	
	where [BusinessPartnerID] = @pkc1
end

if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @pkc1)
BEGIN
	update [dbo].[BusinessPartnerCompany] set
		[BusinessPartnerID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [BusinessPartnerID] end,
		[CompanyName] = case substring(@bitmap,1,1) & 1 when 1 then @c8 else [CompanyName] end,
		[ClassificationCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c5 else [ClassificationCDE] end,
		[IndustryTypeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c6 else [IndustryTypeCDE] end,
		[IndustrySubtypeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c7 else [IndustrySubtypeCDE] end,
		[RegistrationDate] = case substring(@bitmap,1,1) & 1 when 1 then @c11 else [RegistrationDate] end,
		[LoanGradeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c12 else [LoanGradeCDE] end
	
	where [BusinessPartnerID] = @pkc1
end

if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
			set @primarykey_text = @primarykey_text + '[BUSS_PTNR_ID] = ' + convert(nvarchar(100),@pkc1,1)
			exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_MAIN]', @param2=@primarykey_text, @param3=13233
		End
end  
else
begin 

if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @pkc1)
begin
	update [dbo].[BusinessPartner] set
			[BusinessPartnerName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BusinessPartnerName] end,
			[LegalStatusCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LegalStatusCode] end,
			[RegistrationFee] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RegistrationFee] end,
			[CreationDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreationDate] end
			
	where [BusinessPartnerID] = @pkc1
END

if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @pkc1)
BEGIN
	update [dbo].[BusinessPartnerCompany] set
			[CompanyName] = case substring(@bitmap,1,1) & 1 when 1 then @c8 else [CompanyName] end,
			[ClassificationCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c5 else [ClassificationCDE] end,
			[IndustryTypeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c6 else [IndustryTypeCDE] end,
			[IndustrySubtypeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c7 else [IndustrySubtypeCDE] end,
			[RegistrationDate] = case substring(@bitmap,1,1) & 1 when 1 then @c11 else [RegistrationDate] end,
			[LoanGradeCDE] = case substring(@bitmap,1,1) & 1 when 1 then @c12 else [LoanGradeCDE] end
		
	where [BusinessPartnerID] = @pkc1
END

if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			
			set @primarykey_text = @primarykey_text + '[BUSS_PTNR_ID] = ' + convert(nvarchar(100),@pkc1,1)
			exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_MAIN]', @param2=@primarykey_text, @param3=13233
		End
end 
end 
end
GO