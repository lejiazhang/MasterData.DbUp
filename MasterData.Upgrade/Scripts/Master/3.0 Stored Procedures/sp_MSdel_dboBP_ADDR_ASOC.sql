IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboBP_ADDR_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboBP_ADDR_ASOC]
GO

create procedure [dbo].[sp_MSdel_dboBP_ADDR_ASOC]
		@pkc1 int
as


begin 
	if exists (select 1 from [dbo].[BPAddressAssiocation] where [Id] = @pkc1) 
	begin
		declare @primarykey_text nvarchar(100) = ''
			delete [dbo].[BPAddressAssiocation]
			where [Id] = @pkc1
			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						
						set @primarykey_text = @primarykey_text + '[ADDR_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ADDR_ASOC]', @param2=@primarykey_text, @param3=13234
					End
	end  
	end

GO