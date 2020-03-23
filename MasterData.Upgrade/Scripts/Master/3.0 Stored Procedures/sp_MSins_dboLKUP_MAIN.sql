IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboLKUP_MAIN]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboLKUP_MAIN]
GO

CREATE procedure [dbo].[sp_MSins_dboLKUP_MAIN]
    @LKUP_MAIN_ID int,
    @NME nvarchar(200),
    @LKUP_TYPE char(1),
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin 
		DECLARE @COMPANYID INT = '$CompanyId$'

	    IF (@FLAG = 'I')
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM LookupMain WHERE LookupMainID = @LKUP_MAIN_ID)
					BEGIN
						insert into [dbo].LookupMain (
							LookupMainID,
							Narration,
							LookupType
						) values (
							@LKUP_MAIN_ID,
							@NME,
							@LKUP_TYPE
						) 
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
			END CATCH
end  
GO


