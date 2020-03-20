/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboASET_TRAN_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboASET_TRAN_TYPE_CODE]
		@c1 varchar(10) = NULL,
		@c2 nvarchar(1000) = NULL,
		@c3 varchar(10) = NULL,
		@c4 bit = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 char(1) = NULL,
		@pkc1 varchar(10) = NULL,
		@bitmap binary(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c8 = 'D' and EXISTS (SELECT 1 FROM [dbo].[AssetTransmissionType] WHERE [AssetTransmissionTypeName] = @pkc1))
begin
	DELETE FROM [dbo].[AssetTransmissionType] WHERE [AssetTransmissionTypeName] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[AssetTransmissionType] WHERE [AssetTransmissionTypeName] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[AssetTransmissionType] set
			[AssetTransmissionTypeName] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AssetTransmissionTypeName] end,
			[AssetTransmissionTypeDesc] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetTransmissionTypeDesc] end,
			[ExternalCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ExternalCode] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActiveIndicator] end

		where [AssetTransmissionTypeName] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[TRAN_KEY] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_TRAN_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[AssetTransmissionType] set
			[AssetTransmissionTypeDesc] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetTransmissionTypeDesc] end,
			[ExternalCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ExternalCode] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActiveIndicator] end
		
		where [AssetTransmissionTypeName] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[TRAN_KEY] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_TRAN_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end 
end
end
GO