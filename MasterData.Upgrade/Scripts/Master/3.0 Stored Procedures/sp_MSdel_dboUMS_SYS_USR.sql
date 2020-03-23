IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboUMS_SYS_USR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboUMS_SYS_USR]
GO

CREATE procedure [dbo].[sp_MSdel_dboUMS_SYS_USR]
		@pkc1 int
as
begin 
	declare @companyId smallint = '$CompanyId$'
	IF EXISTS(SELECT * FROM UserDefinition WHERE ChildID = @pkc1 AND COMPANYID = @COMPANYID)
		declare @primarykey_text nvarchar(100) = ''

		delete [dbo].UserDefinition where ChildID = @pkc1 AND COMPANYID = @COMPANYID

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[SYS_USR_ID] = ' + convert(nvarchar(100),@pkc1,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_SYS_USR]', @param2=@primarykey_text, @param3=13234 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
				End
end  
GO


