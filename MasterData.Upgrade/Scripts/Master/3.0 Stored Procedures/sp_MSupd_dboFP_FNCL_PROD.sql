USE [NPOS_PROD_Master_LC]
GO

/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboFP_FNCL_PROD]    Script Date: 2/22/2020 10:11:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_MSupd_dboFP_FNCL_PROD]
		@FNCL_PROD_ID		INT = NULL,
		@NME				VARCHAR(100) = NULL,
		@DSCR				VARCHAR(500) = NULL,
		@FNCL_PROD_GRP_ID	INT = NULL,
		@MIN_FNCL_TRMS		INT = NULL,
		@MAX_FNCL_TRMS		INT = NULL,
		@VLDY_STRT_DTE		DATETIME = NULL,
		@VLDY_END_DTE		DATETIME = NULL,
		@INSR_DTE			DATETIME = NULL,
		@UPDT_DTE			 DATETIME = NULL,
		@EXEC_DTE			 DATETIME = NULL,
		@FLAG				 CHAR(1) = NULL,
		@PKC1 INT = NULL,
		@BITMAP BINARY(2)
as
BEGIN  
	DECLARE @PRIMARYKEY_TEXT NVARCHAR(100) = ''
	DECLARE @COMPANYID SMALLINT = 1, @FINC_TYPE_KEY varchar(25);

	SET @FINC_TYPE_KEY = (SELECT FINC_TYPE_KEY FROM [dbo].[FP_FNCL_PROD_GRP] WHERE [FNCL_PROD_GRP_ID] = @FNCL_PROD_GRP_ID)
 
	IF (@FLAG = 'D')
		BEGIN Try
			IF EXISTS (SELECT 1 FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID)
				DELETE FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID
			
			IF EXISTS (SELECT 1 FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID)
				DELETE FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID

			DELETE FROM [dbo].[FinancialProductBP] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID
			DELETE FROM [dbo].[FinancialParameterChart] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID
			DELETE FROM [dbo].[FPAssetSelection] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID
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
						IF EXISTS (SELECT 1 FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID)
						UPDATE [DBO].FINANCIALPRODUCT SET
								FINANCIALPRODUCTID = CASE SUBSTRING(@BITMAP,1,1) & 1 WHEN 1 THEN @FNCL_PROD_ID ELSE FINANCIALPRODUCTID END,
								FinancialParameterID = CASE SUBSTRING(@BITMAP,1,1) & 1 WHEN 1 THEN @FNCL_PROD_ID ELSE FinancialParameterID END,
								PRODUCTNAME = CASE SUBSTRING(@BITMAP,1,1) & 2 WHEN 2 THEN @NME ELSE PRODUCTNAME END,
								PRODUCTFULLNAME = CASE SUBSTRING(@BITMAP,1,1) & 4 WHEN 4 THEN @DSCR ELSE PRODUCTFULLNAME END,
								FINANCIALGROUPID = CASE SUBSTRING(@BITMAP,1,1) & 8 WHEN 8 THEN @FNCL_PROD_GRP_ID ELSE FINANCIALGROUPID END,
								--[MIN_FNCL_TRMS] = CASE SUBSTRING(@BITMAP,1,1) & 16 WHEN 16 THEN @C5 ELSE [MIN_FNCL_TRMS] END,
								--[MAX_FNCL_TRMS] = CASE SUBSTRING(@BITMAP,1,1) & 32 WHEN 32 THEN @C6 ELSE [MAX_FNCL_TRMS] END,
								VALIDFROMDATE = CASE SUBSTRING(@BITMAP,1,1) & 64 WHEN 64 THEN @VLDY_STRT_DTE ELSE VALIDFROMDATE END,
								VALIDTODATE = CASE SUBSTRING(@BITMAP,1,1) & 128 WHEN 128 THEN @VLDY_END_DTE ELSE VALIDTODATE END,
								OperatingBusiness = @FINC_TYPE_KEY,
								LeaseType = @FINC_TYPE_KEY
								--[INSR_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 1 WHEN 1 THEN @C9 ELSE [INSR_DTE] END,
								--[UPDT_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 2 WHEN 2 THEN @C10 ELSE [UPDT_DTE] END,
								--[EXEC_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 4 WHEN 4 THEN @C11 ELSE [EXEC_DTE] END,
								--[FLAG] = CASE SUBSTRING(@BITMAP,2,1) & 8 WHEN 8 THEN @C12 ELSE [FLAG] END
						WHERE FINANCIALPRODUCTID = @PKC1
						IF @@ROWCOUNT = 0
							IF @@MICROSOFTVERSION>0X07320000
								BEGIN
			
									SET @PRIMARYKEY_TEXT = @PRIMARYKEY_TEXT + '[FINANCIALPRODUCTID] = ' + CONVERT(NVARCHAR(100),@PKC1,1) + '[COMPANYID] = ' + @COMPANYID
									EXEC SP_MSREPLRAISERROR @ERRORID=20598, @PARAM1=N'[DBO].[FINANCIALPRODUCT]', @PARAM2=@PRIMARYKEY_TEXT, @PARAM3=13233
								END
						IF EXISTS (SELECT 1 FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID)
						UPDATE [DBO].FinancialParameter SET
								FinancialParameterID = CASE SUBSTRING(@BITMAP,1,1) & 1 WHEN 1 THEN @FNCL_PROD_ID ELSE FinancialParameterID END,
								ParameterName = CASE SUBSTRING(@BITMAP,1,1) & 2 WHEN 2 THEN @NME ELSE ParameterName END, 
								MinimumLeaseTerm = CASE SUBSTRING(@BITMAP,1,1) & 16 WHEN 16 THEN @MIN_FNCL_TRMS ELSE MinimumLeaseTerm END,
								MaximumLeaseTerm = CASE SUBSTRING(@BITMAP,1,1) & 32 WHEN 32 THEN @MAX_FNCL_TRMS ELSE MaximumLeaseTerm END
						WHERE FinancialParameterID = @PKC1
						IF @@ROWCOUNT = 0
							IF @@MICROSOFTVERSION>0X07320000
								BEGIN
			
									SET @PRIMARYKEY_TEXT = @PRIMARYKEY_TEXT + '[FinancialParameterID] = ' + CONVERT(NVARCHAR(100),@PKC1,1) + '[COMPANYID] = ' + @COMPANYID
									EXEC SP_MSREPLRAISERROR @ERRORID=20598, @PARAM1=N'[DBO].[FinancialParameter]', @PARAM2=@PRIMARYKEY_TEXT, @PARAM3=13233
								END
					END  
				ELSE
					BEGIN
						IF EXISTS (SELECT 1 FROM [dbo].[FinancialProduct] WHERE [FinancialProductID] = @pkc1 and CompanyID = @COMPANYID)
						UPDATE [DBO].FINANCIALPRODUCT SET
								PRODUCTNAME = CASE SUBSTRING(@BITMAP,1,1) & 2 WHEN 2 THEN @NME ELSE PRODUCTNAME END,
								PRODUCTFULLNAME = CASE SUBSTRING(@BITMAP,1,1) & 4 WHEN 4 THEN @DSCR ELSE PRODUCTFULLNAME END,
								FINANCIALGROUPID = CASE SUBSTRING(@BITMAP,1,1) & 8 WHEN 8 THEN @FNCL_PROD_GRP_ID ELSE FINANCIALGROUPID END,
								--[MIN_FNCL_TRMS] = CASE SUBSTRING(@BITMAP,1,1) & 16 WHEN 16 THEN @C5 ELSE [MIN_FNCL_TRMS] END,
								--[MAX_FNCL_TRMS] = CASE SUBSTRING(@BITMAP,1,1) & 32 WHEN 32 THEN @C6 ELSE [MAX_FNCL_TRMS] END,
								VALIDFROMDATE = CASE SUBSTRING(@BITMAP,1,1) & 64 WHEN 64 THEN @VLDY_STRT_DTE ELSE VALIDFROMDATE END,
								VALIDTODATE = CASE SUBSTRING(@BITMAP,1,1) & 128 WHEN 128 THEN @VLDY_END_DTE ELSE VALIDTODATE END,
								OperatingBusiness = @FINC_TYPE_KEY,
								LeaseType = @FINC_TYPE_KEY
								--[INSR_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 1 WHEN 1 THEN @C9 ELSE [INSR_DTE] END,
								--[UPDT_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 2 WHEN 2 THEN @C10 ELSE [UPDT_DTE] END,
								--[EXEC_DTE] = CASE SUBSTRING(@BITMAP,2,1) & 4 WHEN 4 THEN @C11 ELSE [EXEC_DTE] END,
								--[FLAG] = CASE SUBSTRING(@BITMAP,2,1) & 8 WHEN 8 THEN @C12 ELSE [FLAG] END
						WHERE FINANCIALPRODUCTID = @PKC1
						IF @@ROWCOUNT = 0
							IF @@MICROSOFTVERSION>0X07320000
								BEGIN
			
									SET @PRIMARYKEY_TEXT = @PRIMARYKEY_TEXT + '[FINANCIALPRODUCTID] = ' + CONVERT(NVARCHAR(100),@PKC1,1) + '[COMPANYID] = ' + @COMPANYID
									EXEC SP_MSREPLRAISERROR @ERRORID=20598, @PARAM1=N'[DBO].[FINANCIALPRODUCT]', @PARAM2=@PRIMARYKEY_TEXT, @PARAM3=13233
								END
						
						IF EXISTS (SELECT 1 FROM [dbo].[FinancialParameter] WHERE [FinancialParameterID] = @pkc1 and CompanyID = @COMPANYID)
						UPDATE [DBO].FinancialParameter SET
								ParameterName = CASE SUBSTRING(@BITMAP,1,1) & 2 WHEN 2 THEN @NME ELSE ParameterName END, 
								MinimumLeaseTerm = CASE SUBSTRING(@BITMAP,1,1) & 16 WHEN 16 THEN @MIN_FNCL_TRMS ELSE MinimumLeaseTerm END,
								MaximumLeaseTerm = CASE SUBSTRING(@BITMAP,1,1) & 32 WHEN 32 THEN @MAX_FNCL_TRMS ELSE MaximumLeaseTerm END
						WHERE FinancialParameterID = @PKC1
						IF @@ROWCOUNT = 0
							IF @@MICROSOFTVERSION>0X07320000
								BEGIN
			
									SET @PRIMARYKEY_TEXT = @PRIMARYKEY_TEXT + '[FinancialParameterID] = ' + CONVERT(NVARCHAR(100),@PKC1,1) + '[COMPANYID] = ' + @COMPANYID
									EXEC SP_MSREPLRAISERROR @ERRORID=20598, @PARAM1=N'[DBO].[FinancialParameter]', @PARAM2=@PRIMARYKEY_TEXT, @PARAM3=13233
								END
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
END 
GO


