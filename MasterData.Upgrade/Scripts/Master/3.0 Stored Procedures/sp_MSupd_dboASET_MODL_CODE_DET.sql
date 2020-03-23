IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboASET_MODL_CODE_DET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboASET_MODL_CODE_DET]
GO

create procedure [dbo].[sp_MSupd_dboASET_MODL_CODE_DET]
		@c1 int = NULL,
		@c2 varchar(500) = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 varchar(20) = NULL,
		@c6 int = NULL,
		@c7 bit = NULL,
		@c8 datetime = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c11 = 'D' and EXISTS (SELECT 1 FROM [dbo].AssetModelCompany WHERE [AssetModelExtDetailId] = @pkc1))
begin
	DELETE FROM [dbo].[AssetModelCompany] WHERE [AssetModelExtDetailId] = @pkc1
	DELETE FROM [dbo].[FPAssetSelection] WHERE [AssetModelExtDetailId] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].AssetModelCompany WHERE [AssetModelExtDetailId] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[AssetModelCompany] set
			[AssetModelExtDetailId] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AssetModelExtDetailId] end,
			[AssetModelExtID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetModelExtID] end,
			[ModelYear] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ModelYear] end,
			[AssetModelAscentID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AssetModelAscentID] end
		
		where [AssetModelExtDetailId] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_DET_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE_DET]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[AssetModelCompany] set
			[AssetModelExtID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetModelExtID] end,
			[ModelYear] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ModelYear] end,
			[AssetModelAscentID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AssetModelAscentID] end
		
		where [AssetModelExtDetailId] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_DET_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE_DET]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end
end

end

GO