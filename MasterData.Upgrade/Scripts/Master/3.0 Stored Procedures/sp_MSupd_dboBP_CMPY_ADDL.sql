IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboBP_CMPY_ADDL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboBP_CMPY_ADDL]
GO

create procedure [dbo].[sp_MSupd_dboBP_CMPY_ADDL]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 datetime = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c7 = 'D' and exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] =  @c2))
begin
	update [dbo].[BusinessPartnerCompany] set
					[BusinessTypeCDE] =  NULL
	where [BusinessPartnerID] = @c2
end

if (@c7 = 'U')
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 
		if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] =  @c2)
		begin
			update [dbo].[BusinessPartnerCompany] set
					[BusinessTypeCDE] =  @c3
			where [BusinessPartnerID] = @c2
            
		end
	end  
	else
	begin 
		if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] =  @c2)
		begin
			update [dbo].[BusinessPartnerCompany] set
					[BusinessTypeCDE] =  @c3
			where [BusinessPartnerID] = @c2
            
		end
	end 
	end 
end

GO