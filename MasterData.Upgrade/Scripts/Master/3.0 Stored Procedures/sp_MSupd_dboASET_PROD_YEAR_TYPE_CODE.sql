/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboASET_PROD_YEAR_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboASET_PROD_YEAR_TYPE_CODE]
		@c1 int = NULL,
		@c2 nvarchar(200) = NULL,
		@c3 nvarchar(1000) = NULL,
		@c4 varchar(10) = NULL,
		@c5 bit = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c9 = 'D' AND EXISTS (SELECT 1 FROM [dbo].[AssetProductionYearType] WHERE [AssetProductionYearTypeID] = @pkc1))
begin
	DELETE FROM [dbo].[AssetProductionYearType] WHERE [AssetProductionYearTypeID] = @pkc1 
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[AssetProductionYearType] WHERE [AssetProductionYearTypeID] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 
		update [dbo].[AssetProductionYearType] set
			[AssetProductionYearTypeID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AssetProductionYearTypeID] end,
			[AssetProductionYearTypeName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetProductionYearTypeName] end,
			[AssetProductionYearTypeDesc] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetProductionYearTypeDesc] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActiveIndicator] end

		where [AssetProductionYearTypeID] = @pkc1
		if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[PROD_YEAR_TYPE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_PROD_YEAR_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

		update [dbo].[AssetProductionYearType] set
			[AssetProductionYearTypeName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetProductionYearTypeName] end,
			[AssetProductionYearTypeDesc] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetProductionYearTypeDesc] end,
			[ExternalCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ExternalCode] end,
			[ActiveIndicator] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActiveIndicator] end

		where [AssetProductionYearTypeID] = @pkc1
		if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[PROD_YEAR_TYPE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_PROD_YEAR_TYPE_CODE]', @param2=@primarykey_text, @param3=13233
			End
		end 
	end
end 
end
GO