IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboBP_ADDR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboBP_ADDR]
GO

create procedure [dbo].[sp_MSins_dboBP_ADDR]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 varchar(50),
    @c6 varchar(50),
    @c7 varchar(255),
    @c8 varchar(50),
    @c9 varchar(50),
    @c10 int,
    @c11 int,
    @c12 varchar(1000),
    @c13 datetime,
    @c14 datetime,
    @c15 datetime,
    @c16 char(1)
as
begin  
	if(@c16 = 'I' and not exists (select 1 from [dbo].[BPAddress] where [Id] = @c1))
	begin
		insert into [dbo].[BPAddress](
			[Id],
			[ContryId],
			[StateId],
			[CityId],
			[StreetName],
			[PostalCode],
			[BuildingName],
			[StreetNumber],
			[UnitNumber],
			[StayInYear],
			[StayInMonth],
			[AttentionToName],
			[CompanyId]
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
end  

GO

 