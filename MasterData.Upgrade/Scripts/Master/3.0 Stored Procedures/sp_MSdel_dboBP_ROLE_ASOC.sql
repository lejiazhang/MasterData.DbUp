IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboBP_ROLE_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboBP_ROLE_ASOC]
GO

create procedure [dbo].[sp_MSdel_dboBP_ROLE_ASOC]
		@pkc1 int
as
begin  
	if exists(select 1 from [dbo].[BP_ROLE_ASOC] where [ROLE_ASOC_ID] = @pkc1)
	begin
			declare @primarykey_text nvarchar(100) = ''
			delete [dbo].[BP_ROLE_ASOC]
			where [ROLE_ASOC_ID] = @pkc1
		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
			
					set @primarykey_text = @primarykey_text + '[ROLE_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ROLE_ASOC]', @param2=@primarykey_text, @param3=13234
				End
	end

	if (exists(select 1 from [dbo].[BP_ROLE_ASOC] where [ROLE_ASOC_ID] = @pkc1))
	begin
		
			declare @BusinessParternId int, @RoleId int;

			select 
				@RoleId = [BP_ROLE_ID], @BusinessParternId = [BUSS_PTNR_ID]
			from [dbo].[BP_ROLE_ASOC] 
			where [ROLE_ASOC_ID] = @pkc1

			if exists(select 1 from [dbo].[BusinessPartnerRole] where [RoleID] = @RoleId and [BusinessPartnerID] = @BusinessParternId)
			begin
				delete from [dbo].[BusinessPartnerRole] where [RoleID] = @RoleId and [BusinessPartnerID] = @BusinessParternId
			end
	end
end  

GO