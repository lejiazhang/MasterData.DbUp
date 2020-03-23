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

if (@c17 = 'D' and EXISTS (SELECT 1 FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @pkc1))
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
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[ASET_MODL_CODE] set
		[MODL_ID] = case substring(@bitmap,1,1) & 1 when 1 then @MODL_ID else [MODL_ID] end,
		[NME] = case substring(@bitmap,1,1) & 2 when 2 then @NME else [NME] end,
		[DSCR] = case substring(@bitmap,1,1) & 4 when 4 then @DSCR else [DSCR] end,
		[EXTR_MODL_CODE] = case substring(@bitmap,1,1) & 8 when 8 then @EXTR_MODL_CODE else [EXTR_MODL_CODE] end,
		[MAKE_TYPE_ID] = case substring(@bitmap,1,1) & 16 when 16 then @MAKE_TYPE_ID else [MAKE_TYPE_ID] end,
		[ASET_TYPE_ID] = case substring(@bitmap,1,1) & 32 when 32 then @ASET_TYPE_ID else [ASET_TYPE_ID] end,
		[ASET_SBTP_ID] = case substring(@bitmap,1,1) & 64 when 64 then @ASET_SBTP_ID else [ASET_SBTP_ID] end,
		[BRND_TYPE_ID] = case substring(@bitmap,1,1) & 128 when 128 then @BRND_TYPE_ID else [BRND_TYPE_ID] end,
		[BLAZ_TYPE_ID] = case substring(@bitmap,2,1) & 1 when 1 then @BLAZ_TYPE_ID else [BLAZ_TYPE_ID] end,
		[NST] = case substring(@bitmap,2,1) & 2 when 2 then @NST else [NST] end,
		[MSRP] = case substring(@bitmap,2,1) & 4 when 4 then @MSRP else [MSRP] end,
		[EXTR_CODE] = case substring(@bitmap,2,1) & 8 when 8 then @EXTR_CODE else [EXTR_CODE] end,
		[ACT_IND] = case substring(@bitmap,2,1) & 16 when 16 then @ACT_IND else [ACT_IND] end,
		[INSR_DTE] = case substring(@bitmap,2,1) & 32 when 32 then @INSR_DTE else [INSR_DTE] end,
		[UPDT_DTE] = case substring(@bitmap,2,1) & 64 when 64 then @UPDT_DTE else [UPDT_DTE] end,
		[EXEC_DTE] = case substring(@bitmap,2,1) & 128 when 128 then @EXEC_DTE else [EXEC_DTE] end,
		[FLAG] = case substring(@bitmap,3,1) & 1 when 1 then @FLAG else [FLAG] end
	where [MODL_ID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
					
					set @primarykey_text = @primarykey_text + '[MODL_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE]', @param2=@primarykey_text, @param3=13233 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End

	update [dbo].[AssetModel] set
			[AssetModelExternalID] = case substring(@bitmap,1,1) & 1 when 1 then @MODL_ID else [AssetModelExternalID] end,
			[CarNameEN] = case substring(@bitmap,1,1) & 2 when 2 then @NME else [CarNameEN] end,
			[ActiveIND] = case substring(@bitmap,2,1) & 16 when 16 then @ACT_IND else [ActiveIND] end
		
		where [AssetModelExternalID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[ASET_MODL_CODE] set
		[NME] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [NME] end,
		[DSCR] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [DSCR] end,
		[EXTR_MODL_CODE] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EXTR_MODL_CODE] end,
		[MAKE_TYPE_ID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MAKE_TYPE_ID] end,
		[ASET_TYPE_ID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ASET_TYPE_ID] end,
		[ASET_SBTP_ID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ASET_SBTP_ID] end,
		[BRND_TYPE_ID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [BRND_TYPE_ID] end,
		[BLAZ_TYPE_ID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [BLAZ_TYPE_ID] end,
		[NST] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [NST] end,
		[MSRP] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MSRP] end,
		[EXTR_CODE] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [EXTR_CODE] end,
		[ACT_IND] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ACT_IND] end,
		[INSR_DTE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [INSR_DTE] end,
		[UPDT_DTE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [UPDT_DTE] end,
		[EXEC_DTE] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [EXEC_DTE] end,
		[FLAG] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FLAG] end
	where [MODL_ID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
					
					set @primarykey_text = @primarykey_text + '[MODL_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE]', @param2=@primarykey_text, @param3=13233 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End

	update [dbo].[AssetModel] set
			[CarNameEN] = case substring(@bitmap,1,1) & 2 when 2 then @NME else [CarNameEN] end,
			[ActiveIND] = case substring(@bitmap,2,1) & 16 when 16 then @ACT_IND else [ActiveIND] end
		
		where [AssetModelExternalID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MODL_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_CODE]', @param2=@primarykey_text, @param3=13233
			End
	end 

	DECLARE @AssetModelExtId INT;

	SET @AssetModelExtId = @MODL_ID	-- [MODL_ID]

	IF EXISTS(SELECT 1 FROM [dbo].[AssetModelCompany] WHERE [AssetModelExtID] = @AssetModelExtId)
	BEGIN
		
		UPDATE [dbo].[AssetModelCompany]
			SET 
				 [AssetMakeID]		= @MAKE_TYPE_ID -- [MAKE_TYPE_ID]
			    ,[AssetTypeID]		= @ASET_TYPE_ID -- [ASET_TYPE_ID]
				,[AssetSubTypeID]	= @ASET_SBTP_ID -- [ASET_SBTP_ID]
				,[AssetBrandTypeID] = @BRND_TYPE_ID -- [BRND_TYPE_ID]
				,[AssetBlazeTypeID] = @BLAZ_TYPE_ID -- [BLAZ_TYPE_ID]
				
		WHERE [AssetModelExtID] = @AssetModelExtId
	END
end 
end
end


GO