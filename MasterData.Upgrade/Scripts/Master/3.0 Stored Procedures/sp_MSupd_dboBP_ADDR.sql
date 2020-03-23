IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboBP_ADDR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboBP_ADDR]
GO

create procedure [dbo].[sp_MSupd_dboBP_ADDR]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 varchar(50) = NULL,
		@c6 varchar(50) = NULL,
		@c7 varchar(255) = NULL,
		@c8 varchar(50) = NULL,
		@c9 varchar(50) = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 varchar(1000) = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 datetime = NULL,
		@c16 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  

if (@c16 = 'D' and exists (select 1 from [dbo].[BPAddress] where Id = @pkc1))
begin
	delete from [dbo].[BPAddress] where Id = @pkc1
	delete [dbo].[BPAddressAssiocation] where [BPAddressId] = @pkc1
end
else
begin
if exists (select 1 from [dbo].[BPAddress] where Id = @pkc1)
begin
		declare @primarykey_text nvarchar(100) = ''
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[BPAddress] set
			[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
			[ContryId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContryId] end,
			[StateId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [StateId] end,
			[CityId] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CityId] end,
			[StreetName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [StreetName] end,
			[PostalCode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PostalCode] end,
			[BuildingName] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [BuildingName] end,
			[StreetNumber] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [StreetNumber] end,
			[UnitNumber] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UnitNumber] end,
			[StayInYear] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [StayInYear] end,
			[StayInMonth] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [StayInMonth] end,
			[AttentionToName] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AttentionToName] end
		
		where [Id] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ADDR_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ADDR]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[BPAddress] set
			[ContryId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContryId] end,
			[StateId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [StateId] end,
			[CityId] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CityId] end,
			[StreetName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [StreetName] end,
			[PostalCode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PostalCode] end,
			[BuildingName] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [BuildingName] end,
			[StreetNumber] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [StreetNumber] end,
			[UnitNumber] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UnitNumber] end,
			[StayInYear] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [StayInYear] end,
			[StayInMonth] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [StayInMonth] end,
			[AttentionToName] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AttentionToName] end
		where [Id] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ADDR_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ADDR]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end 
end
end
GO