IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_FNCL_PROD_GRP]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_FNCL_PROD_GRP]
GO

CREATE procedure [dbo].[sp_MSupd_dboFP_FNCL_PROD_GRP]
		@FNCL_PROD_GRP_ID INT,
		@SHRT_NME VARCHAR(100),
		@LONG_NME VARCHAR(100),
		@FINC_TYPE_KEY VARCHAR(25),
		@INSR_DTE DATETIME,
		@UPDT_DTE DATETIME,
		@EXEC_DTE DATETIME,
		@FLAG CHAR(1),
		@pkc1 int = NULL,
		@bitmap binary(1)
as

BEGIN  
	DECLARE @PRIMARYKEY_TEXT NVARCHAR(100) = ''
	DECLARE @COMPANYID SMALLINT = 1
 
	IF (@FLAG = 'D')
		BEGIN Try
			IF EXISTS (SELECT 1 FROM [dbo].[FinancialGroup] WHERE FinancialGroupID = @pkc1 and CompanyID = @COMPANYID)
				DELETE FROM [dbo].[FinancialGroup] WHERE FinancialGroupID = @pkc1 and CompanyID = @COMPANYID
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
				IF (SUBSTRING(@BITMAP,1,1) & 1 = 1)
					BEGIN 
						update [dbo].[FinancialGroup] set
								FinancialGroupID = case substring(@bitmap,1,1) & 1 when 1 then @FNCL_PROD_GRP_ID else FinancialGroupID end,
								GroupName = case substring(@bitmap,1,1) & 2 when 2 then @SHRT_NME else GroupName end,
								GroupFullName = case substring(@bitmap,1,1) & 4 when 4 then @LONG_NME else GroupFullName end,
								CreationDate = case substring(@bitmap,1,1) & 16 when 16 then @INSR_DTE else CreationDate end
							where FinancialGroupID = @pkc1
						if @@rowcount = 0
							if @@microsoftversion>0x07320000
								Begin
			
									set @primarykey_text = @primarykey_text + '[FNCL_PROD_GRP_ID] = ' + convert(nvarchar(100),@pkc1,1)
									exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_FNCL_PROD_GRP]', @param2=@primarykey_text, @param3=13233
								End
					END  
				ELSE
					BEGIN 
						update [dbo].[FinancialGroup] set
								GroupName = case substring(@bitmap,1,1) & 2 when 2 then @SHRT_NME else GroupName end,
								GroupFullName = case substring(@bitmap,1,1) & 4 when 4 then @LONG_NME else GroupFullName end,
								CreationDate = case substring(@bitmap,1,1) & 16 when 16 then @INSR_DTE else CreationDate end
						where FinancialGroupID = @pkc1
						if @@rowcount = 0
							if @@microsoftversion>0x07320000
								Begin
			
									set @primarykey_text = @primarykey_text + '[FNCL_PROD_GRP_ID] = ' + convert(nvarchar(100),@pkc1,1)
									exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_FNCL_PROD_GRP]', @param2=@primarykey_text, @param3=13233
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
END 
GO


