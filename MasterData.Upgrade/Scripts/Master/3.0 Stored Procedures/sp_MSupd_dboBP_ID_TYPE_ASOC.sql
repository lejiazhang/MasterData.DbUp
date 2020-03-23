IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboBP_ID_TYPE_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboBP_ID_TYPE_ASOC]
GO

create procedure [dbo].[sp_MSupd_dboBP_ID_TYPE_ASOC]
		@TYPE_ASOC_ID int,
		@ID_NUMB varchar(100),
		@BUSS_PTNR_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@DFLT_IND int,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin  

if (@FLAG = 'D' and exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @BUSS_PTNR_ID))
begin
	update [dbo].[BusinessPartnerCompany] set [CompanyNbr] = NULL where [BusinessPartnerID] = @BUSS_PTNR_ID 
end
else
begin
	if @DFLT_IND = 1
	begin
		update [dbo].[BusinessPartnerCompany] set [CompanyNbr] = @ID_NUMB where [BusinessPartnerID] = @BUSS_PTNR_ID 
	end
end
end 
GO