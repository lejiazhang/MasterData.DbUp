IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboUMS_SYS_USR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboUMS_SYS_USR]
GO

CREATE procedure [dbo].[sp_MSupd_dboUMS_SYS_USR]
	@SYS_USR_ID		int = NULL,
	@USR_LOGN_ID	varchar(100) = NULL,
	@USR_FIRT_NME	nvarchar(200) = NULL,
	@USR_LAST_NME	nvarchar(200) = NULL,
	@DEPT_ID		int = NULL,
	@DSIG_ID		int = NULL,
	@LANG_ID		int = NULL,
	@USR_EMAL		varchar(100) = NULL,
	@ACT_IND		bit = NULL,
	@INSR_DTE		datetime = NULL,
	@UPDT_DTE		datetime = NULL,
	@EXEC_DTE		datetime = NULL,
	@FLAG			char(1) = NULL,
	@pkc1			int = NULL,
	@bitmap			binary(2)
as
begin  
	DECLARE @PRIMARYKEY_TEXT NVARCHAR(100) = ''
	DECLARE @COMPANYID SMALLINT = '$CompanyId$'

	IF (@FLAG = 'D')
		BEGIN Try
			IF EXISTS (SELECT 1 FROM [dbo].UserDefinition WHERE ChildID = @pkc1 and CompanyID = @COMPANYID)
				DELETE FROM [dbo].UserDefinition WHERE ChildID = @pkc1 and CompanyID = @COMPANYID
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
				IF EXISTS (SELECT 1 FROM [dbo].UserDefinition WHERE ChildID = @pkc1 and CompanyID = @COMPANYID)
					IF (SUBSTRING(@BITMAP,1,1) & 1 = 1)
						BEGIN 
							update [dbo].UserDefinition set
									ChildID = case substring(@bitmap,1,1) & 1 when 1 then @SYS_USR_ID else ChildID end,
									BpIndividualID = case substring(@bitmap,1,1) & 1 when 1 then @SYS_USR_ID else BpIndividualID end,
									UserName = case substring(@bitmap,1,1) & 2 when 2 then @USR_LOGN_ID else UserName end,
									BPName = @USR_FIRT_NME + ' ' + @USR_LAST_NME,
									DepartmentID = case substring(@bitmap,1,1) & 16 when 16 then @DEPT_ID else DepartmentID end,
									DesignationID = case substring(@bitmap,1,1) & 32 when 32 then @DSIG_ID else DesignationID end,
									LanguageID = case substring(@bitmap,1,1) & 64 when 64 then @LANG_ID else LanguageID end,
									PosUserEmail = case substring(@bitmap,1,1) & 128 when 128 then @USR_EMAL else PosUserEmail end,
									ActiveInd = case substring(@bitmap,2,1) & 1 when 1 then @ACT_IND else ActiveInd end
								where ChildID = @pkc1
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
										if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
										Begin
				
											set @primarykey_text = @primarykey_text + '[SYS_USR_ID] = ' + convert(nvarchar(100),@pkc1,1)
											exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_SYS_USR]', @param2=@primarykey_text, @param3=13233 
										End
										Else
											exec sp_MSreplraiserror @errorid=20598
									End
						END  
					ELSE
						BEGIN 
							update [dbo].UserDefinition set
									UserName = case substring(@bitmap,1,1) & 2 when 2 then @USR_LOGN_ID else UserName end,
									BPName = @USR_FIRT_NME + ' ' + @USR_LAST_NME,
									DepartmentID = case substring(@bitmap,1,1) & 16 when 16 then @DEPT_ID else DepartmentID end,
									DesignationID = case substring(@bitmap,1,1) & 32 when 32 then @DSIG_ID else DesignationID end,
									LanguageID = case substring(@bitmap,1,1) & 64 when 64 then @LANG_ID else LanguageID end,
									PosUserEmail = case substring(@bitmap,1,1) & 128 when 128 then @USR_EMAL else PosUserEmail end,
									ActiveInd = case substring(@bitmap,2,1) & 1 when 1 then @ACT_IND else ActiveInd end
								where ChildID = @pkc1
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
										if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
										Begin
				
											set @primarykey_text = @primarykey_text + '[SYS_USR_ID] = ' + convert(nvarchar(100),@pkc1,1)
											exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_SYS_USR]', @param2=@primarykey_text, @param3=13233 
										End
										Else
											exec sp_MSreplraiserror @errorid=20598
									End
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


