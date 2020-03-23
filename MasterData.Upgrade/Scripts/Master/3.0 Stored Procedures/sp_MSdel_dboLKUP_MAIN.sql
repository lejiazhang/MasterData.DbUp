IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboLKUP_MAIN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboLKUP_MAIN]
GO

CREATE procedure [dbo].[sp_MSdel_dboLKUP_MAIN]
		@pkc1 int
as
begin  
	declare @companyId smallint = '$CompanyId$'

	IF EXISTS(SELECT * FROM LookupMain WHERE LookupMainID = @pkc1)
		begin
			declare @primarykey_text nvarchar(100) = ''

			delete [dbo].LookupMain where LookupMainID = @pkc1

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[LKUP_MAIN_ID] = ' + convert(nvarchar(100),@pkc1,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_MAIN]', @param2=@primarykey_text, @param3=13234 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End
		end
end  
GO


