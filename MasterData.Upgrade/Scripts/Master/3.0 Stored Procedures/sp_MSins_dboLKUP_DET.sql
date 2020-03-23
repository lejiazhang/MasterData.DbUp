IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboLKUP_DET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboLKUP_DET]
GO

CREATE  procedure [dbo].[sp_MSins_dboLKUP_DET]
    @LKUP_MAIN_ID int,
    @LKUP_DET_ID int,
    @EXTR_CODE varchar(10),
    @NME nvarchar(200),
    @CMPY_ID int,
    @ACT_IND bit,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
	begin
	DECLARE @COMPANYID INT = '$CompanyId$'

	    IF (@FLAG = 'I')
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM LookupDetail WHERE LookupMainID = @LKUP_MAIN_ID and LookupDetailID = @LKUP_DET_ID and CompanyID = @COMPANYID)
					BEGIN
						insert into [dbo].LookupDetail (
							LookupMainID,
							LookupDetailID,
							ExternalCode,
							Narration,
							CompanyID,
							ParentID,
							FIMLookupDetailID,
							ActiveInd,
							SystemInd,
							CharValue
						) values (
							@LKUP_MAIN_ID,
							@LKUP_DET_ID,
							@EXTR_CODE,
							@NME,
							@COMPANYID,
							null,
							null,
							@ACT_IND,
							null,
							null	
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


