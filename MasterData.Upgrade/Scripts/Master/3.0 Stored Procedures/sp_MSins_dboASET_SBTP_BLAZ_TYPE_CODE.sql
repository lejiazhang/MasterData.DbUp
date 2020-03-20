/****** Object:  StoredProcedure [dbo].[sp_MSins_dboASET_SBTP_BLAZ_TYPE_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboASET_SBTP_BLAZ_TYPE_CODE]
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
begin 

if (@c9 = 'I' and NOT EXISTS (SELECT 1 FROM [dbo].[AssetBlazeType] WHERE [AssetBlazeTypeID] = @c1))
begin
    insert into [dbo].[AssetBlazeType](
		[AssetBlazeTypeID],
		[AssetBlazeTypeName],
		[AssetBlazeTypeDesc],
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
	
end  

GO