IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboASET_TYPE_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboASET_TYPE_CODE]
GO

create procedure [dbo].[sp_MSupd_dboASET_TYPE_CODE]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(200) = NULL,
		@c4 nvarchar(1000) = NULL,
		@c5 varchar(10) = NULL,
		@c6 bit = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 datetime = NULL,
		@c10 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c10 = 'D' and EXISTS (SELECT 1 FROM [dbo].[AssetType] WHERE [AssetTypeID] = @pkc1))
begin
	DELETE FROM [dbo].[AssetType] WHERE [AssetTypeID] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[AssetType] WHERE [AssetTypeID] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[AssetType] set
			[AssetTypeID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AssetTypeID] end,
			[AssetTypeName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetTypeName] end,
			[AssetTypeDesc] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AssetTypeDesc] end,
			[ExternalCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ExternalCode] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActiveIndicator] end
		
		where [AssetTypeID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ASET_TYPE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[AssetType] set
			[AssetTypeName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetTypeName] end,
			[AssetTypeDesc] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AssetTypeDesc] end,
			[ExternalCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ExternalCode] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActiveIndicator] end
			
		where [AssetTypeID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ASET_TYPE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end 
end
end

GO