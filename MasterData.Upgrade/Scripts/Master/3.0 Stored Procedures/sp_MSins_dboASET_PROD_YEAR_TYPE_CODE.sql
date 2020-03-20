/****** Object:  StoredProcedure [dbo].[sp_MSins_dboASET_PROD_YEAR_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboASET_PROD_YEAR_TYPE_CODE]
    @c1 int,
    @c2 nvarchar(200),
    @c3 nvarchar(1000),
    @c4 varchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 datetime,
    @c8 datetime,
    @c9 char(1)
as

BEGIN
    if(@c9 = 'I' and NOT EXISTS (SELECT 1 FROM [dbo].[AssetProductionYearType] WHERE [AssetProductionYearTypeID] = @c1))
    begin  
        insert into [dbo].[AssetProductionYearType](
            [AssetProductionYearTypeID],
            [AssetProductionYearTypeName],
            [AssetProductionYearTypeDesc],
            [ExternalCode],
            [ActiveIndicator],
            [CompanyID]
        ) values (
        @c1,
        @c2,
        @c3,
        @c4,
        @c5,
        2	) 
    end  
END

GO