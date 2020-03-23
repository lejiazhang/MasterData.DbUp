IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboASET_MODL_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboASET_MODL_CODE]
GO

create procedure [dbo].[sp_MSupd_dboASET_MODL_CODE]
		@MODL_ID int,
		@NME nvarchar(200),
		@DSCR nvarchar(1000),
		@EXTR_MODL_CODE char(18),
		@MAKE_TYPE_ID int,
		@ASET_TYPE_ID int,
		@ASET_SBTP_ID int,
		@BRND_TYPE_ID int,
		@BLAZ_TYPE_ID int,
		@NST int,
		@MSRP nvarchar(40),
		@EXTR_CODE decimal(21,5),
		@ACT_IND varchar(10),
		@INSR_DTE bit,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@FLAG = 'D' and EXISTS (SELECT 1 FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @pkc1))
begin
	DELETE FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @pkc1
	DELETE FROM [dbo].[AssetModelCompany] where [AssetModelExtID] = @pkc1
	DELETE FROM [dbo].[AssetModelYearPrice] where [AssetModelExtId] = @pkc1
	DELETE FROM [dbo].[FPAssetSelection] where [AssetModelCode] = @pkc1
end
else

begin
if EXISTS (SELECT 1 FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @pkc1)
begin
	
	update [dbo].[AssetModel] set
			[AssetModelExternalID] = case substring(@bitmap,1,1) & 1 when 1 then @MODL_ID else [AssetModelExternalID] end,
			[CarNameEN] = case substring(@bitmap,1,1) & 2 when 2 then @NME else [CarNameEN] end,
			[ActiveIND] = case substring(@bitmap,2,1) & 16 when 16 then @ACT_IND else [ActiveIND] end
		
		where [AssetModelExternalID] = @pkc1


	IF EXISTS(SELECT 1 FROM [dbo].[AssetModelCompany] WHERE [AssetModelExtID] = @pkc1)
	BEGIN
		
		UPDATE [dbo].[AssetModelCompany]
			SET 
				 [AssetMakeID]		= @MAKE_TYPE_ID -- [MAKE_TYPE_ID]
			    ,[AssetTypeID]		= @ASET_TYPE_ID -- [ASET_TYPE_ID]
				,[AssetSubTypeID]	= @ASET_SBTP_ID -- [ASET_SBTP_ID]
				,[AssetBrandTypeID] = @BRND_TYPE_ID -- [BRND_TYPE_ID]
				,[AssetBlazeTypeID] = @BLAZ_TYPE_ID -- [BLAZ_TYPE_ID]
				
		WHERE [AssetModelExtID] = @pkc1
	END

	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE]', @param2=@primarykey_text, @param3=13233
			End
end
end 
end


GO