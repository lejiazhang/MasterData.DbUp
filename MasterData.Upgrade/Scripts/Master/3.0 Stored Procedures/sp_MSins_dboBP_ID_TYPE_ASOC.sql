/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_ID_TYPE_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboBP_ID_TYPE_ASOC]
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

	if (@FLAG = 'I' and exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @BUSS_PTNR_ID AND [CompanyNbr] = @ID_NUMB))
	begin
        if @DFLT_IND = 1
        begin
            update [dbo].[BusinessPartnerCompany] set [CompanyNbr] = @ID_NUMB where [BusinessPartnerID] = @BUSS_PTNR_ID
        end
	end
end  

GO