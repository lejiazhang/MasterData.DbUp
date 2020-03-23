IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboLKUP_DET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboLKUP_DET]
GO

CREATE procedure [dbo].[sp_MSupd_dboLKUP_DET]
		@LKUP_MAIN_ID int = NULL,
		@LKUP_DET_ID int = NULL,
		@EXTR_CODE varchar(10) = NULL,
		@NME nvarchar(200) = NULL,
		@CMPY_ID int = NULL,
		@ACT_IND bit = NULL,
		@INSR_DTE datetime = NULL,
		@UPDT_DTE datetime = NULL,
		@EXEC_DTE datetime = NULL,
		@FLAG char(1) = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@bitmap binary(2)
as
begin  
	DECLARE @PRIMARYKEY_TEXT NVARCHAR(100) = ''
	DECLARE @COMPANYID SMALLINT = '$CompanyId$'

		IF (@FLAG = 'D')
			BEGIN TRY
				IF EXISTS(SELECT * FROM LookupDetail WHERE LookupMainID = @PKC1 and LookupDetailID = @pkc2 and CompanyID = @COMPANYID)
					DELETE [DBO].LookupDetail WHERE LookupMainID = @PKC1 and LookupDetailID = @pkc2 and CompanyID = @COMPANYID
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
		ELSE
			BEGIN
				BEGIN TRY
					IF EXISTS(SELECT * FROM LookupDetail WHERE LookupMainID = @PKC1 and LookupDetailID = @pkc2 and CompanyID = @COMPANYID)
						if (substring(@bitmap,1,1) & 1 = 1) or (substring(@bitmap,1,1) & 2 = 2)
							begin 

							update [dbo].LookupDetail set
									LookupMainID = case substring(@bitmap,1,1) & 1 when 1 then @LKUP_MAIN_ID else LookupMainID end,
									LookupDetailID = case substring(@bitmap,1,1) & 2 when 2 then @LKUP_DET_ID else LookupDetailID end,
									ExternalCode = case substring(@bitmap,1,1) & 4 when 4 then @EXTR_CODE else ExternalCode end,
									Narration = case substring(@bitmap,1,1) & 8 when 8 then @NME else Narration end, 
									ActiveInd = case substring(@bitmap,1,1) & 32 when 32 then @ACT_IND else ActiveInd end
								where LookupMainID = @PKC1 and LookupDetailID = @pkc2 and CompanyID = @COMPANYID
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
			
										set @primarykey_text = @primarykey_text + '[LKUP_MAIN_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
										set @primarykey_text = @primarykey_text + '[LKUP_DET_ID] = ' + convert(nvarchar(100),@pkc2,1)
										exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_DET]', @param2=@primarykey_text, @param3=13233
									End
							end  
						else
							begin 

							update [dbo].LookupDetail set
									ExternalCode = case substring(@bitmap,1,1) & 4 when 4 then @EXTR_CODE else ExternalCode end,
									Narration = case substring(@bitmap,1,1) & 8 when 8 then @NME else Narration end, 
									ActiveInd = case substring(@bitmap,1,1) & 32 when 32 then @ACT_IND else ActiveInd end
								where LookupMainID = @PKC1 and LookupDetailID = @pkc2 and CompanyID = @COMPANYID
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
			
										set @primarykey_text = @primarykey_text + '[LKUP_MAIN_ID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
										set @primarykey_text = @primarykey_text + '[LKUP_DET_ID] = ' + convert(nvarchar(100),@pkc2,1)
										exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_DET]', @param2=@primarykey_text, @param3=13233
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
			END
end 

GO


