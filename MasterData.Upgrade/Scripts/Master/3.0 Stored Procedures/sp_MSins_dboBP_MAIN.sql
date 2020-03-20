/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_MAIN]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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

	if (@c17 = 'I' and not exists (select 1 from [dbo].[BusinessPartner] where [BusinessPartnerID] = @c1))
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
		2 ) 

	end  

	if (@c17 = 'I' and not exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] = @c1))
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
			2
		)
	end
end

GO