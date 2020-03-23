IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboUMS_USR_EXTR_RLTN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboUMS_USR_EXTR_RLTN]
GO

CREATE procedure [dbo].[sp_MSupd_dboUMS_USR_EXTR_RLTN]
		@OLD_EXTR_RLTN_ID int,
		@OLD_EXTR_BP_ID int,
		@OLD_SYS_USR_ID int,
		@OLD_INSR_DTE datetime,
		@OLD_UPDT_DTE datetime,
		@OLD_EXEC_DTE datetime,
		@OLD_FLAG char(1),
		@EXTR_RLTN_ID int,
		@EXTR_BP_ID int,
		@SYS_USR_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1)
as

begin  
	declare @primarykey_text nvarchar(100) = ''
	declare @companyId smallint = '$CompanyId$'
	declare @RelationShipID int = 0

		IF (@FLAG = 'D')
			BEGIN Try
				select TOP 1 @RelationShipID = case when BusinessPartnerRole.RoleID = 1 then 115 else case when BusinessPartnerRole.RoleID = 14 then 10 else 0 end end from BusinessPartner 
				INNER JOIN BusinessPartnerRole ON BusinessPartner.BusinessPartnerID = BusinessPartnerRole.BusinessPartnerID AND BusinessPartner.CompanyID = BusinessPartnerRole.CompanyID
				and (BusinessPartnerRole.RoleID = 1 or BusinessPartnerRole.RoleID = 14) and BusinessPartner.BusinessPartnerID = @OLD_EXTR_BP_ID

				IF not (@RelationShipID = 0) and EXISTS(SELECT * FROM [dbo].Relationship WHERE ParentID = @OLD_EXTR_BP_ID and ChildID = @OLD_SYS_USR_ID and RelationshipID = @RelationShipID and CompanyID = @companyId)
					begin
						delete [dbo].Relationship WHERE ParentID = @OLD_EXTR_BP_ID and ChildID = @OLD_SYS_USR_ID and RelationshipID = @RelationShipID  and CompanyID = @companyId

						if @@rowcount = 0
							if @@microsoftversion>0x07320000
							Begin
							if exists (Select *
							from sys.all_parameters
							where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
							Begin

								set @primarykey_text = @primarykey_text + '[EXTR_RLTN_ID] = ' + convert(nvarchar(100),@OLD_EXTR_RLTN_ID,1)
								exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_USR_EXTR_RLTN]', @param2=@primarykey_text, @param3=13234
							End
							Else
								exec sp_MSreplraiserror @errorid=20598
						End
					end
			END try
			begin catch
				SELECT
				ERROR_NUMBER() AS ERRORNUMBER,
				ERROR_STATE() AS ERRORSTATE,
				ERROR_SEVERITY() AS ERRORSEVERITY,
				ERROR_PROCEDURE() AS ERRORPROCEDURE,
				ERROR_LINE() AS ERRORLINE,
				ERROR_MESSAGE() AS ERRORMESSAGE;
			end catch
	else
		Begin
			BEGIN TRY
				IF EXISTS(SELECT * FROM [dbo].[UMS_USR_EXTR_RLTN] WHERE [EXTR_RLTN_ID] = @OLD_EXTR_RLTN_ID)
					if not (@OLD_EXTR_RLTN_ID = @EXTR_RLTN_ID)
					begin 
						select TOP 1 @RelationShipID = case when BusinessPartnerRole.RoleID = 1 then 115 else case when BusinessPartnerRole.RoleID = 14 then 10 else 0 end end from BusinessPartner 
						INNER JOIN BusinessPartnerRole ON BusinessPartner.BusinessPartnerID = BusinessPartnerRole.BusinessPartnerID AND BusinessPartner.CompanyID = BusinessPartnerRole.CompanyID
						and (BusinessPartnerRole.RoleID = 1 or BusinessPartnerRole.RoleID = 14) and BusinessPartner.BusinessPartnerID = @OLD_EXTR_BP_ID

						IF not (@RelationShipID = 0) and EXISTS(SELECT * FROM [dbo].Relationship WHERE ParentID = @OLD_EXTR_BP_ID and ChildID = @OLD_SYS_USR_ID and RelationshipID = @RelationShipID and CompanyID = @companyId)
							begin
								delete [dbo].Relationship WHERE ParentID = @OLD_EXTR_BP_ID and ChildID = @OLD_SYS_USR_ID and RelationshipID = @RelationShipID  and CompanyID = @companyId

								if @@rowcount = 0
									if @@microsoftversion>0x07320000
									Begin
									if exists (Select *
									from sys.all_parameters
									where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
									Begin

										set @primarykey_text = @primarykey_text + '[EXTR_RLTN_ID] = ' + convert(nvarchar(100),@OLD_EXTR_RLTN_ID,1)
										exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_USR_EXTR_RLTN]', @param2=@primarykey_text, @param3=13234
									End
									Else
										exec sp_MSreplraiserror @errorid=20598
								End

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
					end  
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
end
GO


