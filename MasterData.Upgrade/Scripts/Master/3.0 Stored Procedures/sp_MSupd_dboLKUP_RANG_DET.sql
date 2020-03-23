IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboLKUP_RANG_DET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboLKUP_RANG_DET]
GO

CREATE procedure [dbo].[sp_MSupd_dboLKUP_RANG_DET]
		@LKUP_RANG_ID int = NULL,
		@LKUP_MAIN_ID int = NULL,
		@EXTR_CODE nvarchar(20) = NULL,
		@MIN_RANG varchar(25) = NULL,
		@MAX_RANG varchar(25) = NULL,
		@ACT_IND bit = NULL,
		@INSR_DTE datetime = NULL,
		@UPDT_DTE datetime = NULL,
		@EXEC_DTE datetime = NULL,
		@FLAG char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin  

	DECLARE @PRIMARYKEY_TEXT NVARCHAR(100) = ''
	DECLARE @COMPANYID SMALLINT = '$CompanyId$'

	IF (@FLAG = 'D')
		BEGIN TRY
			IF EXISTS(SELECT * FROM LookupRangeDetail WHERE LookupRangeID = @pkc1) DELETE [DBO].LookupRangeDetail WHERE LookupRangeID = @PKC1
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
				IF EXISTS(SELECT * FROM LookupRangeDetail WHERE LookupRangeID = @pkc1)
					IF (SUBSTRING(@BITMAP,1,1) & 1 = 1)
						BEGIN 
							update [dbo].LookupRangeDetail set
									LookupRangeID = case substring(@bitmap,1,1) & 1 when 1 then @LKUP_RANG_ID else LookupRangeID end,
									LookupMainID = case substring(@bitmap,1,1) & 2 when 2 then @LKUP_MAIN_ID else LookupMainID end,
									ExternalCode = case substring(@bitmap,1,1) & 4 when 4 then @EXTR_CODE else ExternalCode end,
									MinimumRange = case substring(@bitmap,1,1) & 8 when 8 then @MIN_RANG else MinimumRange end,
									MaximumRange = case substring(@bitmap,1,1) & 16 when 16 then @MAX_RANG else MaximumRange end,
									ActiveInd = case substring(@bitmap,1,1) & 32 when 32 then @ACT_IND else ActiveInd end
							where LookupRangeID = @pkc1
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
										if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
										Begin
				
											set @primarykey_text = @primarykey_text + '[LKUP_RANG_ID] = ' + convert(nvarchar(100),@pkc1,1)
											exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_RANG_DET]', @param2=@primarykey_text, @param3=13233 
										End
										Else
											exec sp_MSreplraiserror @errorid=20598
									End
						END  
					ELSE
						BEGIN 
							update [dbo].LookupRangeDetail set
									LookupMainID = case substring(@bitmap,1,1) & 2 when 2 then @LKUP_MAIN_ID else LookupMainID end,
									ExternalCode = case substring(@bitmap,1,1) & 4 when 4 then @EXTR_CODE else ExternalCode end,
									MinimumRange = case substring(@bitmap,1,1) & 8 when 8 then @MIN_RANG else MinimumRange end,
									MaximumRange = case substring(@bitmap,1,1) & 16 when 16 then @MAX_RANG else MaximumRange end,
									ActiveInd = case substring(@bitmap,1,1) & 32 when 32 then @ACT_IND else ActiveInd end
							where LookupRangeID = @pkc1
							if @@rowcount = 0
								if @@microsoftversion>0x07320000
									Begin
										if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
										Begin
				
											set @primarykey_text = @primarykey_text + '[LKUP_RANG_ID] = ' + convert(nvarchar(100),@pkc1,1)
											exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[LKUP_RANG_DET]', @param2=@primarykey_text, @param3=13233 
										End
										Else
											exec sp_MSreplraiserror @errorid=20598
									End
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
		END 
end 
GO


