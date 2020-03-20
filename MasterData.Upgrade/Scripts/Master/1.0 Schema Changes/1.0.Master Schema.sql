--USE NPOS_PROD_MASTER_AFC  -- LC also need excute.

-----------------------------------------------------------------------------------------------------
---- REMOVE NOT FOR REPLICATION FOR ID CLOUMN 
-----------------------------------------------------------------------------------------------------

--ALTER TABLE DBO.FINANCIALPRODUCT
--ALTER COLUMN [ID] DROP NOT FOR REPLICATION

-----------------------------------------------------------------------------------------------------
---- ADD FIMNARRATION COLUMN IN LOOKUPMAIN
-----------------------------------------------------------------------------------------------------

--IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='LOOKUPMAIN' AND COLUMN_NAME='FIMNARRATION')
--ALTER TABLE DBO.LOOKUPMAIN
--ADD FIMNARRATION NVARCHAR(255)

-----------------------------------------------------------------------------------------------------
---- ADD FIMLOOKUPDETAILID COLUMN IN LOOKUPDETAIL, CHANGE PK TO LOOKUPMAINID AND LOOKUPDETAILID
-----------------------------------------------------------------------------------------------------

--IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='LOOKUPDETAIL' AND COLUMN_NAME='FIMLOOKUPDETAILID')
--ALTER TABLE [DBO].[LOOKUPDETAIL]
--ADD FIMLOOKUPDETAILID INT

--ALTER TABLE [DBO].[LOOKUPDETAIL]
--ALTER COLUMN LOOKUPMAINID INT NOT NULL

--IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'PK_LOOKUP_DETAIL_ID')
--ALTER TABLE [DBO].[LOOKUPDETAIL] DROP CONSTRAINT [PK_LOOKUP_DETAIL_ID]

--CREATE NONCLUSTERED INDEX [PK_LOOKUP_DETAIL_ID]   
--    ON [DBO].[LOOKUPDETAIL] (LOOKUPMAINID, [LOOKUPDETAILID]);   

-----------------------------------------------------------------------------------------------------
---- REMOVE IDENTITY PROPERTY FROM LOOKUPRANGEDETAIL.LOOKUPRANGEID
-----------------------------------------------------------------------------------------------------

--BEGIN TRANSACTION

--CREATE TABLE [DBO].[LOOKUPRANGEDETAIL_TEMP](
--	[LOOKUPRANGEID] [INT] NOT NULL,
--	[COMPANYID] [TINYINT] NULL,
--	[LOOKUPMAINID] [INT] NULL,
--	[EXTERNALCODE] [NVARCHAR](10) NULL,
--	[MINIMUMRANGE] [DECIMAL](18, 5) NULL,
--	[MAXIMUMRANGE] [DECIMAL](18, 5) NULL,
--	[ACTIVEIND] [BIT] NULL,
--	[SYSTEMIND] [BIT] NULL,
-- CONSTRAINT [PK_LOOKUP_RANGE_DTL_ID_TEMP] PRIMARY KEY NONCLUSTERED 
--(
--	[LOOKUPRANGEID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
--) ON [PRIMARY]
--GO
--IF EXISTS(SELECT * FROM DBO.LOOKUPRANGEDETAIL)
--EXEC('INSERT INTO DBO.LOOKUPRANGEDETAIL_TEMP 
--SELECT * FROM DBO.LOOKUPRANGEDETAIL WITH (HOLDLOCK TABLOCKX)')
--GO
--DROP TABLE DBO.LOOKUPRANGEDETAIL
--GO
--EXECUTE SP_RENAME N'DBO.LOOKUPRANGEDETAIL_TEMP', N'LOOKUPRANGEDETAIL', 'OBJECT'
--EXECUTE SP_RENAME @OBJNAME = N'[LOOKUPRANGEDETAIL].[PK_LOOKUP_RANGE_DTL_ID_TEMP]', @NEWNAME = N'PK_LOOKUP_RANGE_DTL_ID'
--GO
--COMMIT

---------------------------------------------------------------------------------------------------
-- MODIFY [BusinessPartner].[BPTypeID] FROM NOT NULL TO NULL
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='BusinessPartner' AND COLUMN_NAME='BPTypeID')
ALTER TABLE [dbo].[BusinessPartner]
ALTER COLUMN [BPTypeID] NUMERIC(11,0) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetBrandType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetBrandType' AND COLUMN_NAME='AssetBrandTypeName')
ALTER TABLE [dbo].[AssetBrandType]
	ALTER COLUMN [AssetBrandTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetBrandType' AND COLUMN_NAME='AssetBrandTypeDesc')
ALTER TABLE [dbo].[AssetBrandType]
	ALTER COLUMN [AssetBrandTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetBlazeType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetBlazeType' AND COLUMN_NAME='AssetBlazeTypeName')
ALTER TABLE [dbo].[AssetBlazeType]
	ALTER COLUMN [AssetBlazeTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetBlazeType' AND COLUMN_NAME='AssetBlazeTypeDesc')
ALTER TABLE [dbo].[AssetBlazeType]
	ALTER COLUMN [AssetBlazeTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetMakeType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetMakeType' AND COLUMN_NAME='AssetMakeTypeName')
ALTER TABLE [dbo].[AssetMakeType]
	ALTER COLUMN [AssetMakeTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetMakeType' AND COLUMN_NAME='AssetMakeTypeDesc')
ALTER TABLE [dbo].[AssetMakeType]
	ALTER COLUMN [AssetMakeTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetTransmissionType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetTransmissionType' AND COLUMN_NAME='AssetTransmissionTypeDesc')
ALTER TABLE [dbo].[AssetTransmissionType]
	ALTER COLUMN [AssetTransmissionTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetType' AND COLUMN_NAME='AssetTypeName')
ALTER TABLE [dbo].[AssetType]
	ALTER COLUMN [AssetTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetType' AND COLUMN_NAME='AssetTypeDesc')
ALTER TABLE [dbo].[AssetType]
	ALTER COLUMN [AssetTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetSubType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetSubType' AND COLUMN_NAME='AssetSubTypeName')
ALTER TABLE [dbo].[AssetSubType]
	ALTER COLUMN [AssetSubTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetSubType' AND COLUMN_NAME='AssetSubTypeDesc')
ALTER TABLE [dbo].[AssetSubType]
	ALTER COLUMN [AssetSubTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetUsageType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetUsageType' AND COLUMN_NAME='AssetUsageTypeName')
ALTER TABLE [dbo].[AssetUsageType]
	ALTER COLUMN [AssetUsageTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetUsageType' AND COLUMN_NAME='AssetUsageTypeDesc')
ALTER TABLE [dbo].[AssetUsageType]
	ALTER COLUMN [AssetUsageTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetProductionYearType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetProductionYearType' AND COLUMN_NAME='AssetProductionYearTypeName')
ALTER TABLE [dbo].[AssetProductionYearType]
	ALTER COLUMN [AssetProductionYearTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetProductionYearType' AND COLUMN_NAME='AssetProductionYearTypeDesc')
ALTER TABLE [dbo].[AssetProductionYearType]
	ALTER COLUMN [AssetProductionYearTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetModelYearType]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetModelYearType' AND COLUMN_NAME='AssetModelYearTypeName')
ALTER TABLE [dbo].[AssetModelYearType]
	ALTER COLUMN [AssetModelYearTypeName] NVARCHAR(200) NULL
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetModelYearType' AND COLUMN_NAME='AssetModelYearTypeDesc')
ALTER TABLE [dbo].[AssetModelYearType]
	ALTER COLUMN [AssetModelYearTypeDesc] NVARCHAR(1000) NULL
GO

---------------------------------------------------------------------------------------------------
-- [AssetModel]
---------------------------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AssetModel' AND COLUMN_NAME='CarNameEN')
ALTER TABLE [dbo].[AssetModel]
	ALTER COLUMN [CarNameEN] NVARCHAR(200) NULL
GO
