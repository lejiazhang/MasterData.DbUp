IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboASET_SBTP_BLAZ_TYPE_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboASET_SBTP_BLAZ_TYPE_CODE]
GO

create procedure [dbo].[sp_MSdel_dboASET_SBTP_BLAZ_TYPE_CODE]
		@pkc1 int
as
begin  

IF EXISTS (SELECT 1 FROM [dbo].[AssetBlazeType] WHERE [AssetBlazeTypeID] = @pkc1)
	begin
		declare @primarykey_text nvarchar(100) = ''
		delete [dbo].[AssetBlazeType]
		where [AssetBlazeTypeID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				
				set @primarykey_text = @primarykey_text + '[AssetBlazeTypeID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AssetBlazeType]', @param2=@primarykey_text, @param3=13234
			End
	end  
end
GO