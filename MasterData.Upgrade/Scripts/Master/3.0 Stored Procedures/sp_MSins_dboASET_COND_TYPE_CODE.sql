IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_COND_TYPE_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_COND_TYPE_CODE]
GO

create procedure [dbo].[sp_MSins_dboASET_COND_TYPE_CODE]
    @c1 varchar(10),
    @c2 varchar(500),
    @c3 varchar(10),
    @c4 bit,
    @c5 datetime,
    @c6 datetime,
    @c7 datetime,
    @c8 char(1)
as

begin
    if (@c8 = 'I' and not exists (select 1 from [dbo].[AssetConditionType] WHERE [AssetConditionTypeCode] = @c1))
    begin  
        insert into [dbo].[AssetConditionType](
            [AssetConditionTypeCode],
            [AssetConditionTypeDesc],
            [ExternalCode],
            [ActiveIndicator],
            [CompanyID]
        ) values (
        @c1,
        @c2,
        @c3,
        @c4,
        '$CompanyId$'   ) 
    end 
end

GO