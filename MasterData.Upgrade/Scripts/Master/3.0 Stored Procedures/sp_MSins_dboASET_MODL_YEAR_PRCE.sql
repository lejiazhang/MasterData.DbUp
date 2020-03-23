IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_MODL_YEAR_PRCE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_MODL_YEAR_PRCE]
GO

create procedure [dbo].[sp_MSins_dboASET_MODL_YEAR_PRCE]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 varchar(10),
    @c6 int,
    @c7 decimal(21,5),
    @c8 decimal(21,5),
    @c9 decimal(8,5),
    @c10 decimal(8,5),
    @c11 int,
    @c12 int,
    @c13 datetime,
    @c14 datetime,
    @c15 datetime,
    @c16 char(1)
as

BEGIN

    if (@c16 = 'I' AND NOT EXISTS (SELECT 1 FROM [dbo].[AssetModelYearPrice] WHERE [AssetYearPriceId] = @c1))
    begin  
        insert into [dbo].[AssetModelYearPrice](
            [AssetYearPriceId],
            [AssetModelExtId],
            [AssetSequenceNumber],
            [EffectDate],
            [TransmissionTypeCode],
            [CRCY_ID],
            [RetailPrice],
            [WholeSalePrice],
            [WARG_PCNT],
            [REJN_PCNT],
            [AssetModelExtDetailId],
            [AssetModelYearTypeId],
            [CompnayId]
        ) values (
        @c1,
        @c2,
        @c3,
        @c4,
        @c5,
        @c6,
        @c7,
        @c8,
        @c9,
        @c10,
        @c11,
        @c12,
        '$CompanyId$'	) 
    end  

END

GO