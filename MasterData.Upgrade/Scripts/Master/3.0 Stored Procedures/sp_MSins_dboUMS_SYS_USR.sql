/****** Object:  StoredProcedure [dbo].[sp_MSins_dboUMS_SYS_USR]    Script Date: 2/23/2020 12:18:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_MSins_dboUMS_SYS_USR]
    @SYS_USR_ID		int,
    @USR_LOGN_ID	varchar(100),
    @USR_FIRT_NME	nvarchar(200),
    @USR_LAST_NME	nvarchar(200),
    @DEPT_ID		int,
    @DSIG_ID		int,
    @LANG_ID		int,
    @USR_EMAL		varchar(100),
    @ACT_IND		bit,
    @INSR_DTE		datetime,
    @UPDT_DTE		datetime,
    @EXEC_DTE		datetime,
    @FLAG			char(1)
as
begin 
	DECLARE @COMPANYID INT = 2
	    IF (@FLAG = 'I')
		BEGIN TRY
			IF NOT EXISTS(SELECT * FROM UserDefinition WHERE ChildID = @SYS_USR_ID AND COMPANYID = @COMPANYID)
				BEGIN
					declare @TempUserID int
					SELECT TOP 1 @TempUserID = UserID + 1 FROM UserDefinition WHERE CompanyID = 1 order by userid desc

					insert into [dbo].UserDefinition (
						UserID,
						CompanyID,
						UserName,
						ChildID,
						BpIndividualID,
						BPName,
						DepartmentID,
						DesignationID,
						LanguageID,
						PosUserEmail,
						ActiveInd 
					) values (
						@TempUserID,
						@COMPANYID,
						@USR_LOGN_ID,
						@SYS_USR_ID,
						@SYS_USR_ID,
						@USR_FIRT_NME + ' ' + @USR_LAST_NME,
						@DEPT_ID,
						@DSIG_ID,
						@LANG_ID,
						@USR_EMAL,
						@ACT_IND) 
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
