/****** Object:  StoredProcedure [dbo].[sp_MSins_dboASET_BRND_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboASET_BRND_TYPE_CODE]
    @c1 int,
    @c2 nvarchar(200),
    @c3 nvarchar(1000),
    @c4 int,
    @c5 varchar(10),
    @c6 bit,
    @c7 datetime,
    @c8 datetime,
    @c9 datetime,
    @c10 char(1)
as

begin  
    if (@c10 = 'I' and not exists (select 1 from [dbo].[AssetBrandType] where [AssetBrandTypeID] = @c1))
    begin 
        insert into [dbo].[AssetBrandType](
            [AssetBrandTypeID],
            [AssetBrandTypeName],
            [AssetBrandTypeDesc],
            [AssetMakeTypeID],
            [ExternalCode],
            [ActiveIndicator],
            [CompanyID]        
        ) values (
        @c1,
        @c2,
        @c3,
        @c4,
        @c5,
        @c6,
        2  ) 
    end
end  

GO