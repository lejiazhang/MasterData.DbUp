IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_TRAN_TYPE_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_TRAN_TYPE_CODE]
GO

create procedure [dbo].[sp_MSins_dboASET_TRAN_TYPE_CODE]
    @c1 varchar(10),
    @c2 nvarchar(1000),
    @c3 varchar(10),
    @c4 bit
as
begin
    if (@c4 = 'I' and NOT EXISTS (SELECT 1 FROM [dbo].[AssetTransmissionType] WHERE [AssetTransmissionTypeName] = @c1))
    begin  
        insert into [dbo].[AssetTransmissionType](
            [AssetTransmissionTypeName],
            [AssetTransmissionTypeDesc],
            [ExternalCode],
            [ActiveIndicator],
            [CompanyID]
        ) values (
        @c1,
        @c2,
        @c3,
        @c4,
        '$CompanyId$'	) 
    end 
end

GO