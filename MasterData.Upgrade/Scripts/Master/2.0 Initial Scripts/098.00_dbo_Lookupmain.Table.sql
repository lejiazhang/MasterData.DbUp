BEGIN TRY
	-- Clear data
	TRUNCATE TABLE [dbo].[LookupMain]

	-- Create a temporary table to hold the updated or inserted values
	-- from the OUTPUT clause.  
	IF OBJECT_ID ('TEMPDB..#TEMP_LookupMain') IS NOT NULL
		DROP TABLE #TEMP_LookupMain
		 
	CREATE TABLE #TEMP_LookupMain
	(
		[LookupMainID_Old] int NULL,
		[Narration_Old] nvarchar (255) NULL,
		[LookupType_Old] char (1) NULL,
		[FIMNARRATION_Old] nvarchar (255) NULL,
		[FIMLookupMainID_Old] int NULL,
		[ActionTaken] nvarchar(10),
		[LookupMainID] int NULL,
		[Narration] nvarchar (255) NULL,
		[LookupType] char (1) NULL,
		[FIMNARRATION] nvarchar (255) NULL,
		[FIMLookupMainID] int NULL,
	);  

	-- FIM LookupMain Table
	;WITH Mapping ([LOOKUP_MAIN_ID], [NARRATION], [NARRATION_STAGE], [LOOKUP_TYPE]) AS
    (
        SELECT [LOOKUP_MAIN_ID], [NARRATION], [NARRATION_STAGE], [LOOKUP_TYPE]
        FROM
        (
            VALUES
				(1, N'ACCESSORY_CODE', NULL, N'D'),
				(2, N'ACCOUNT_TYPE_CODE', N'Account Type Code', N'D'),
				(4, N'APPLICATION_TYPE_CODE', N'Application Type', N'D'),
				(5, N'APPLICATION_APPROVE_STATUS', N'ConditionCode', N'D'),
				(6, N'ASSET_CODE', N'AssetCode', N'D'),
				(7, N'ASSET_COLOR_CODE', N'Asset Color', N'D'),
				(8, N'CHARGE_TYPE_CODE', N'ChargeReceivableTypeCode', N'D'),
				(10, N'REQUEST_STATUS_CODE', N'Request Status Code', N'D'),
				(11, N'ADDRESS_TYPE_CODE', N'Address Type', N'D'),
				(13, N'BUSINESS_TYPE_CODE', N'Business Type', N'D'),
				(14, N'BUSINESS_NATURE_CODE', N'Business Nature', N'D'),
				(15, N'CAPACITY_TO_PAY', N'CapacityToPay', N'D'),
				(16, N'OCCUPATION_CODE', N'Occupation Type', N'D'),
				(17, N'RACE_CODE', N'Citizenship Status', N'D'),
				(18, N'COUNTRY_CODE', N'CountryCode', N'D'),
				(19, N'STATE_CODE', N'StateCode', N'D'),
				(20, N'CITY_CODE', N'CityCode', N'D'),
				(21, N'RESIDENCE_TYPE_CODE', N'Residence', N'D'),
				(22, N'REGISTRATION_TYPE', NULL, N'D'),
				(23, N'REGISTRATION_CITY', N'Registration City', N'D'),
				(25, N'BP_CREDIT_RATING_CODE', N'Credit Rating', N'D'),
				(26, N'DECISION_REASON_CODE', N'Reason Type Code', N'D'),
				(27, N'BP_DESIGNATION_CODE', N'Designation Type', N'D'),
				(28, N'APPLICANT_EDUCATION_CODE', N'Educational Qualifications', N'D'),
				(29, N'EMPLOYMENT_TYPE_CODE', N'Employment Type', N'D'),
				(31, N'ID_CARD_TYPE', N'ID Type Code', N'D'),
				(32, N'INDUSTRY_TYPE_CODE', N'Industry Type', N'D'),
				(33, N'INDUSTRY_SUBTYPE_CODE', N'Industry Sub Type', N'D'),
				(37, N'MARITAL_STATUS_CODE', N'Marital Status', N'D'),
				(38, N'NATIONALITY_CODE', N'Nationality', N'D'),
				(39, N'PAYMENT_FREQUENCY_CODE', N'RentalFrequencyTypeCodes', N'D'),
				(40, N'PAYMENT_MODE_CODE', N'PaymentModeCode', N'D'),
				(42, N'PHONE_TYPE_CODE', N'Phone Type', N'D'),
				(43, N'PROPERTY_TYPE_CODE', N'Property Type', N'D'),
				(45, N'RELATIONSHIP_CODE', N'Relationship Code', N'D'),
				(47, N'TITLE_CODE', N'TitleCode', N'D'),
				(52, N'BUSINESS_PARTNER_TYPE', N'Legal Status Code', N'D'),
				(53, N'BP_ROLE_CODE', N'BpRoleTypeCode', N'D'),
				(54, N'BP_DEPARTMENT_CODE', N'Department Code', N'D'),
				(55, N'LANGUAGE_CODE', N'LanguageForSync', N'D'),
				(56, N'CHART_TRANSACTION_TYPE', N'Chart Type Code', N'D'),
				(57, N'SECURITY_RULE_TYPE', NULL, N'D'),
				(58, N'AGE_CODE', N'Asset Age', N'R'),
				(59, N'TERM_CODE', N'Contract Terms', N'R'),
				(60, N'AMOUNT_CODE', N'Finance Amount Range', N'R'),
				(61, N'DOWNPAYMENT_RANGE_CODE', N'DownPayment%', N'R'),
				(64, N'REGION', N'Region Code', N'D'),
				(65, N'TITLE_CODE_LOCAL', NULL, N'D'),
				(66, N'DTS_MODEL_CODE', N'DtsModelCode', N'D'),
				(67, N'EVENT_CODE', N'RequestTypeCode', N'D'),
				(69, N'CAP_MODULE_CODE', NULL, N'D'),
				(73, N'APPLICATIONFORMTYPE_CODE', N'Application Form Type', N'D')
        ) AS M ([LOOKUP_MAIN_ID], [NARRATION], [NARRATION_STAGE], [LOOKUP_TYPE])
    )

	-- Merge from STAGE_DB_AFC to NPOS_PROD_Master_LC
	MERGE INTO [dbo].[LookupMain] AS Target
	USING
	(
		SELECT LKUP_MAIN.LKUP_MAIN_ID, LKUP_MAIN.NME, LKUP_MAIN.LKUP_TYPE, Mapping.NARRATION as FIM_NARRATION, Mapping.LOOKUP_MAIN_ID as FIM_LOOKUP_MAIN_ID
		FROM [dbo].[LKUP_MAIN] 
		left join Mapping on [LKUP_MAIN].NME = Mapping.NARRATION_STAGE
	)
	AS [Source] (LKUP_MAIN_ID, NME, LKUP_TYPE, FIM_NARRATION, FIM_LOOKUP_MAIN_ID) 
		ON 
		(
			[Target].[LookupMainID] = [Source].[LKUP_MAIN_ID] 
		)

	WHEN MATCHED THEN
		-- row found : udpate existing rows
		UPDATE SET 
			[Target].[Narration] = [Source].[NME],
			[Target].[LookupType] = [Source].[LKUP_TYPE],
			[Target].[FIMNARRATION] = [Source].[FIM_NARRATION],
			[Target].[FIMLOOKUPMAINID] = [Source].[FIM_LOOKUP_MAIN_ID]

	WHEN NOT MATCHED BY TARGET  THEN
		-- insert new rows 
		INSERT ([LookupMainID], [Narration], [LookupType], [FIMNARRATION],[FIMLOOKUPMAINID])
		VALUES ([Source].[LKUP_MAIN_ID], [Source].[NME], [Source].[LKUP_TYPE], [Source].[FIM_NARRATION], [Source].[FIM_LOOKUP_MAIN_ID])

	WHEN NOT MATCHED BY SOURCE THEN 
		-- delete rows that are in the target but not the source 
		DELETE
	OUTPUT
		deleted.[LookupMainID], deleted.[Narration], deleted.[LookupType], deleted.[FIMNARRATION], deleted.[FIMLOOKUPMAINID],
		$action,
		inserted.LookupMainID, inserted.Narration, inserted.LookupType, inserted.FIMNARRATION, inserted.[FIMLOOKUPMAINID]
	INTO #TEMP_LookupMain;

	PRINT 'Lookupmain merge script ran successfully.'
END TRY
BEGIN CATCH
	--  SELECT  
    --  ERROR_NUMBER() AS ErrorNumber  
    -- ,ERROR_SEVERITY() AS ErrorSeverity  
    -- ,ERROR_STATE() AS ErrorState  
    -- ,ERROR_PROCEDURE() AS ErrorProcedure  
    -- ,ERROR_LINE() AS ErrorLine  
    -- ,ERROR_MESSAGE() AS ErrorMessage;  
	 PRINT 'Problem in dbo.Lookupmain.Table.sql'

END CATCH;