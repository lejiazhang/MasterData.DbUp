/****** Object:  StoredProcedure [dbo].[sp_MSins_dboUMS_USR_EXTR_RLTN]    Script Date: 2/24/2020 8:44:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_MSins_dboUMS_USR_EXTR_RLTN]
    @EXTR_RLTN_ID int,
    @EXTR_BP_ID int,
    @SYS_USR_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin 
	DECLARE @COMPANYID INT = '$CompanyId$'
	    IF (@FLAG = 'I')
		BEGIN TRY
				BEGIN				
					declare @RelationShipID int = 0

					--LKUP_MAIN_ID	LKUP_DET_ID	EXTR_CODE	NME
					--2913	1	00001	Dealer
					--2913	41	00011	Finance Company
					select TOP 1 @RelationShipID = case when BusinessPartnerRole.RoleID = 1 then 115 else case when BusinessPartnerRole.RoleID = 14 then 10 else 0 end end from BusinessPartner 
					INNER JOIN BusinessPartnerRole ON BusinessPartner.BusinessPartnerID = BusinessPartnerRole.BusinessPartnerID AND BusinessPartner.CompanyID = BusinessPartnerRole.CompanyID
					and (BusinessPartnerRole.RoleID = 1 or BusinessPartnerRole.RoleID = 14) and BusinessPartner.BusinessPartnerID = @EXTR_BP_ID

					IF @RelationShipID <> 0 and NOT EXISTS(SELECT * FROM Relationship WHERE ParentID = @EXTR_BP_ID and ChildID = @SYS_USR_ID and RelationshipID = @RelationShipID and CompanyID = @COMPANYID)
						Begin
							INSERT INTO [dbo].[Relationship]
								([ParentID]
								,[ChildID]
								,[RelationshipID]
								,[ActiveInd]
								,[CreationDate]
								,[InsertedBy]
								,[CompanyID]
								,[ActivateInd])
							VALUES
								(@EXTR_BP_ID
								,@SYS_USR_ID
								,@RelationShipID
								,1
								,@INSR_DTE
								,'sync'
								,@COMPANYID
								,'1')
						end
				END
		END TRY
		BEGIN CATCH
			SELECT
			ERROR_NUMBER() AS ERRORNUMBER,
			ERROR_STATE() AS ERRORSTATE,
			ERROR_SEVERITY() AS ERRORSEVERITY,
			ERROR_PROCEDURE() AS ERRORPROCEDURE,
			ERROR_LINE() AS ERRORLINE,
			ERROR_MESSAGE() AS ERRORMESSAGE;
		END CATCH;
end  
GO


