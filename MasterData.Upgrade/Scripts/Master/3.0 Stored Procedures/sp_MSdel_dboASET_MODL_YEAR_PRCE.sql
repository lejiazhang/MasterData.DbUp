/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboASET_MODL_YEAR_PRCE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSdel_dboASET_MODL_YEAR_PRCE]
		@pkc1 int
as

BEGIN
	IF EXISTS (SELECT 1 FROM [dbo].[AssetModelYearPrice] WHERE [AssetYearPriceId] = @pkc1)
	begin  
		declare @primarykey_text nvarchar(100) = ''
		delete [dbo].[AssetModelYearPrice]
		where [AssetYearPriceId] = @pkc1
		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					
					set @primarykey_text = @primarykey_text + '[MODL_YEAR_PRCE_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ASET_MODL_YEAR_PRCE]', @param2=@primarykey_text, @param3=13234
				End
	end  
END

GO