SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_MSins_dboLKUP_RANG_DET]
    @LKUP_RANG_ID int,
    @LKUP_MAIN_ID int,
    @EXTR_CODE nvarchar(20),
    @MIN_RANG varchar(25),
    @MAX_RANG varchar(25),
    @ACT_IND bit,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin  
		DECLARE @COMPANYID INT = 2

	    IF (@FLAG = 'I')
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM LookupRangeDetail WHERE LookupRangeID = @LKUP_RANG_ID)
					BEGIN
						insert into [dbo].LookupRangeDetail (
							LookupRangeID,
							CompanyID,
							LookupMainID,
							ExternalCode,
							MinimumRange,
							MaximumRange,
							ActiveInd
						) values (
							@LKUP_RANG_ID,
							@COMPANYID,
							@LKUP_MAIN_ID,
							@EXTR_CODE,
							@MIN_RANG,
							@MAX_RANG,
							@ACT_IND
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


