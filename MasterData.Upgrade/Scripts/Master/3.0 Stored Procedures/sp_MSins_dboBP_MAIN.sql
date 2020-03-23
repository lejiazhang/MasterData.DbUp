IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboBP_MAIN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboBP_MAIN]
GO

create procedure [dbo].[sp_MSins_dboBP_MAIN]
    @BUSS_PTNR_ID int,
    @FULL_NME_C nvarchar(605),
    @LEGL_STS_KEY varchar(10),
    @CPTL_REGT_AMNT decimal(21,5),
    @CLFN_ID int,
    @INDY_TYPE_ID int,
    @INDY_SBTP_ID int,
    @FRST_NME nvarchar(200),
    @MDLE_NME nvarchar(200),
    @LAST_NME nvarchar(200),
    @REGT_DTE datetime,
    @LOAN_GRNG_ID int,
    @FC_EMP_IND bit,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as

begin

	if (@FLAG = 'I' and not exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @BUSS_PTNR_ID))
	begin  
		insert into [dbo].[BusinessPartner](
			[BusinessPartnerID],
			[BusinessPartnerName],
			[LegalStatusCode],
			[RegistrationFee],
			[CreationDate],
			[CompanyID]
		) values (
		@BUSS_PTNR_ID,
		@FULL_NME_C,
		@LEGL_STS_KEY,
		@CPTL_REGT_AMNT,
		GETDATE(),
		'$CompanyId$' ) 

	end  

	if (@FLAG = 'I' and not exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @BUSS_PTNR_ID))
	begin  
	insert into [dbo].[BusinessPartnerCompany](
			[BusinessPartnerID],
			[CompanyName],
			[ClassificationCDE],
			[IndustryTypeCDE],
			[IndustrySubtypeCDE],
			[RegistrationDate],
			[LoanGradeCDE],
			[CompanyID]
		) values (
			@BUSS_PTNR_ID,
			@FRST_NME,
			@CLFN_ID,
			@INDY_TYPE_ID,
			@INDY_SBTP_ID,
			@REGT_DTE,
			@LOAN_GRNG_ID,
			'$CompanyId$'
		)
	end
end

GO