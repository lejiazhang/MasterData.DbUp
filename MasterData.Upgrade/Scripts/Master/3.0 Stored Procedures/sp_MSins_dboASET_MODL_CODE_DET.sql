IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_MODL_CODE_DET]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_MODL_CODE_DET]
GO

create procedure [dbo].[sp_MSins_dboASET_MODL_CODE_DET]
    @c1 int,
    @c2 varchar(500),
    @c3 int,
    @c4 int,
    @c5 varchar(20),
    @c6 int,
    @c7 bit,
    @c8 datetime,
    @c9 datetime,
    @c10 datetime,
    @c11 char(1)
as

begin
	if (@c11 = 'I' and not EXISTS (SELECT 1 FROM [dbo].AssetModelCompany WHERE [AssetModelExtDetailId] = @c1))
	begin  

		DECLARE 
			@AssetMakeId			INT,
			@AssetTypeID			INT,
			@AssetSubTypeID			INT,
			@AssetBrandTypeID		INT,
			@AssetBlazeTypeID		INT,
			@AssetModelID			INT,
			@AssetModelAscentID		VARCHAR(20),
			@BaumasterID			INT,
			@NST					NVARCHAR(20),
			@AssetModelExtId		INT,
			@ModelYear				INT,
			@AssetModelExtDetailId	INT;

		SET @AssetModelExtDetailId	= @c1 -- [MODL_DET_ID]
		SET @AssetModelExtId		= @c3 -- [MODL_ID]
		SET @ModelYear				= @c4 -- [MODL_YEAR_TYPE_ID]
		SET @NST					= @c5 -- [EXTR_CODE]

		SELECT
			@AssetMakeId			= [MAKE_TYPE_ID],
			@AssetTypeID			= [ASET_TYPE_ID],
			@AssetSubTypeID			= [ASET_SBTP_ID],
			@AssetBrandTypeID		= [BRND_TYPE_ID],
			@AssetBlazeTypeID		= [BLAZ_TYPE_ID],
			@AssetModelAscentID		= [EXTR_CODE]
		FROM  [dbo].[ASET_MODL_CODE] WHERE [MODL_ID] = @c3

		SELECT @AssetModelID FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @AssetModelExtId

		IF(ISNUMERIC(SUBSTRING(@NST,0,7)) = 1)
		begin
			SET @BaumasterID = SUBSTRING(@NST,0,7)
		end        
		
		insert into [dbo].[AssetModelCompany](
			[ID],
			[AssetModelExtID]
			,[AssetModelID]
			,[CompanyID]
			,[AssetMakeID]
			,[AssetTypeID]
			,[AssetSubTypeID]
			,[AssetBrandTypeID]
			,[AssetBlazeTypeID]
			,[NST]
			,[BaumasterID]
			,[ModelYear]
			,[AssetModelAscentID]
			,[AssetModelExtDetailId]) 
		values(
			@AssetModelExtDetailId,
			@AssetModelExtId,
			@AssetModelID,
			'$CompanyId$',
			@AssetMakeId,
			@AssetTypeID,
			@AssetSubTypeID,
			@AssetBrandTypeID,
			@AssetBlazeTypeID,
			@NST,
			@BaumasterID,
			@ModelYear,
			@AssetModelAscentID,
			@AssetModelExtDetailId) 
	end  
end

GO