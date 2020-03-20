SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_MSdel_dboLKUP_RANG_DET]
		@pkc1 int
as
begin 

declare @companyId smallint = 1

	IF EXISTS(SELECT * FROM LookupRangeDetail WHERE LookupRangeID = @pkc1)
		begin
			declare @primarykey_text nvarchar(100) = ''

			delete [dbo].LookupRangeDetail where LookupRangeID = @pkc1

			if @@rowcount = 0
				if @@microsoftversion>0x07320000
					Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
						Begin
				
							set @primarykey_text = @primarykey_text + '[LKUP_RANG_ID] = ' + convert(nvarchar(100),@pkc1,1)
							exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_RANG_DET]', @param2=@primarykey_text, @param3=13234 
						End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End
		end
end  
GO


