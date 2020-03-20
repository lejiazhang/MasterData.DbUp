USE [NPOS_PROD_Master_LC]
GO

/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboBP_CMPY_ADDL]    Script Date: 2/28/2020 3:15:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboBP_CMPY_ADDL]
		@CMPY_ADDL int,
		@BUSS_PTNR_ID int,
		@BUSS_TYPE_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

	if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] =  @BUSS_PTNR_ID)
    begin
        update [dbo].[BusinessPartnerCompany] set
                [BusinessTypeCDE] =  NULL
        where [BusinessPartnerID] = @BUSS_PTNR_ID
    end


	if exists (select 1 from [dbo].[BP_CMPY_ADDL]  where [CMPY_ADDL] = @CMPY_ADDL)
	begin
		delete [dbo].[BP_CMPY_ADDL] 
		where [CMPY_ADDL] = @CMPY_ADDL
	end
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[CMPY_ADDL] = ' + convert(nvarchar(100),@CMPY_ADDL,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_CMPY_ADDL]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
GO


