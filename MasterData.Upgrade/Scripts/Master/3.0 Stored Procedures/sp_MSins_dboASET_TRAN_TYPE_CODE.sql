/****** Object:  StoredProcedure [dbo].[sp_MSins_dboASET_TRAN_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
        2	) 
    end 
end

GO