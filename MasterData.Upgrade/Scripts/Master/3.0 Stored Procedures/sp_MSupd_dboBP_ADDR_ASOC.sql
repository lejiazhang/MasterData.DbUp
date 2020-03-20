/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboBP_ADDR_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboBP_ADDR_ASOC]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  

if (@c9 = 'D' and exists (select 1 from [dbo].[BPAddressAssiocation] where Id = @pkc1))
begin
	delete from [dbo].[BPAddressAssiocation] where Id = @pkc1
end
else
begin
if exists (select 1 from [dbo].[BPAddressAssiocation] where Id = @pkc1)
begin
	declare @primarykey_text nvarchar(100) = ''
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[BPAddressAssiocation] set
			[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
			[BusinessPartnerId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BusinessPartnerId] end,
			[AddressSeq] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AddressSeq] end,
			[AddressTypeId] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AddressTypeId] end,
			[BPAddressId] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BPAddressId] end
			
		where [Id] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ADDR_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ADDR_ASOC]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[BPAddressAssiocation] set
			
			[BusinessPartnerId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BusinessPartnerId] end,
			[AddressSeq] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AddressSeq] end,
			[AddressTypeId] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AddressTypeId] end,
			[BPAddressId] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BPAddressId] end
			
		where [Id] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ADDR_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ADDR_ASOC]', @param2=@primarykey_text, @param3=13233
			End
	end 
end
end 
end
GO