/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboBP_ID_TYPE_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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