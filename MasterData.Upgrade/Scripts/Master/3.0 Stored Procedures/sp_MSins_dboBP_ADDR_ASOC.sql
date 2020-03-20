/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_ADDR_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboBP_ADDR_ASOC]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 datetime,
    @c7 datetime,
    @c8 datetime,
    @c9 char(1)
as
begin  
	if (@c9 = 'I' and not exists (select 1 from [dbo].[BPAddressAssiocation] where [Id] = @c1))
	begin
		insert into [dbo].[BPAddressAssiocation](
			[Id],
			[BusinessPartnerId],
			[AddressSeq],
			[AddressTypeId],
			[BPAddressId],
			[CompanyId]
		
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

 