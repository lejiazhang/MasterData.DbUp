USE [NPOS_PROD_Master_LC]
GO

/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboBP_ID_TYPE_ASOC]    Script Date: 2/28/2020 3:20:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboBP_ID_TYPE_ASOC]
		@TYPE_ASOC_ID int,
		@ID_NUMB varchar(100),
		@BUSS_PTNR_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@DFLT_IND int
as
begin  
	declare @primarykey_text nvarchar(100) = ''

	if exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @BUSS_PTNR_ID)
	begin
		update [dbo].[BusinessPartnerCompany] set [CompanyNbr] = NULL where [BusinessPartnerID] = @BUSS_PTNR_ID 
	end

	if exists(select 1 from [dbo].[BP_ID_TYPE_ASOC] where [TYPE_ASOC_ID] = @TYPE_ASOC_ID)
	begin
		delete [dbo].[BP_ID_TYPE_ASOC] 
			where [TYPE_ASOC_ID] = @TYPE_ASOC_ID
		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[TYPE_ASOC_ID] = ' + convert(nvarchar(100),@TYPE_ASOC_ID,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ID_TYPE_ASOC]', @param2=@primarykey_text, @param3=13234 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
				End
	end
	
end  
GO


