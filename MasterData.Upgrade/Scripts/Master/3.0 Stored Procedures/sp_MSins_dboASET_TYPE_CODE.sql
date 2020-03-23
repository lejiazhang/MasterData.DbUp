IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_TYPE_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_TYPE_CODE]
GO

create procedure [dbo].[sp_MSins_dboASET_TYPE_CODE]
    @c1 int,
    @c2 int,
    @c3 nvarchar(200),
    @c4 nvarchar(1000),
    @c5 varchar(10),
    @c6 bit,
    @c7 datetime,
    @c8 datetime,
    @c9 datetime,
    @c10 char(1)
as
begin
    if (@c10 = 'I' and NOT EXISTS (SELECT 1 FROM [dbo].[AssetType] WHERE [AssetTypeID] = @c1))
    begin  
        insert into [dbo].[AssetType](
            [AssetTypeID],
            [AssetTypeName],
            [AssetTypeDesc],
            [ExternalCode],
            [ActiveIndicator],
            [CompanyID]
        ) values (
        @c1,
        @c3,
        @c4,
        @c5,
        @c6,
        '$CompanyId$'	) 
    end  
end

GO