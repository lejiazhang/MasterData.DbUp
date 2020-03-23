IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_SBTP_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_SBTP_CODE]
GO

create procedure [dbo].[sp_MSins_dboASET_SBTP_CODE]
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
    if (@c10 = 'I' and NOT EXISTS (SELECT 1 FROM [dbo].[AssetSubType] WHERE [AssetSubTypeID] = @c1))
    begin  
        insert into [dbo].[AssetSubType](
            [AssetSubTypeID],
            [AssetSubTypeName],
            [AssetSubTypeDesc],
            [AssetTypeID],
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
        '$CompanyId$'	) 
    end  

end
GO