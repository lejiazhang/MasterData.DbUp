IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboASET_MODL_YEAR_PRCE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboASET_MODL_YEAR_PRCE]
GO

create procedure [dbo].[sp_MSupd_dboASET_MODL_YEAR_PRCE]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 datetime = NULL,
		@c5 varchar(10) = NULL,
		@c6 int = NULL,
		@c7 decimal(21,5) = NULL,
		@c8 decimal(21,5) = NULL,
		@c9 decimal(8,5) = NULL,
		@c10 decimal(8,5) = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 datetime = NULL,
		@c16 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c16 = 'D' and EXISTS (SELECT 1 FROM [dbo].[AssetModelYearPrice] WHERE [AssetYearPriceId] = @pkc1))
begin
	DELETE FROM [dbo].[AssetModelYearPrice] WHERE [AssetYearPriceId] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[AssetModelYearPrice] WHERE [AssetYearPriceId] = @pkc1)
	begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[AssetModelYearPrice] set
			[AssetYearPriceId] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AssetYearPriceId] end,
			[AssetModelExtId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetModelExtId] end,
			[AssetSequenceNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetSequenceNumber] end,
			[EffectDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EffectDate] end,
			[TransmissionTypeCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TransmissionTypeCode] end,
			[CRCY_ID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CRCY_ID] end,
			[RetailPrice] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RetailPrice] end,
			[WholeSalePrice] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [WholeSalePrice] end,
			[WARG_PCNT] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [WARG_PCNT] end,
			[REJN_PCNT] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REJN_PCNT] end,
			[AssetModelExtDetailId] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AssetModelExtDetailId] end,
			[AssetModelYearTypeId] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AssetModelYearTypeId] end,
			[CreationDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreationDate] end
		
		where [AssetYearPriceId] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_YEAR_PRCE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_YEAR_PRCE]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[AssetModelYearPrice] set
			[AssetModelExtId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AssetModelExtId] end,
			[AssetSequenceNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AssetSequenceNumber] end,
			[EffectDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EffectDate] end,
			[TransmissionTypeCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TransmissionTypeCode] end,
			[CRCY_ID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CRCY_ID] end,
			[RetailPrice] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RetailPrice] end,
			[WholeSalePrice] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [WholeSalePrice] end,
			[WARG_PCNT] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [WARG_PCNT] end,
			[REJN_PCNT] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REJN_PCNT] end,
			[AssetModelExtDetailId] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AssetModelExtDetailId] end,
			[AssetModelYearTypeId] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AssetModelYearTypeId] end,
			[CreationDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreationDate] end
		
		where [AssetYearPriceId] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_YEAR_PRCE_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_YEAR_PRCE]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end 
end
end
GO