IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboBP_ID_TYPE_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboBP_ID_TYPE_ASOC]
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