IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboBP_ADDR_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboBP_ADDR_ASOC]
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
		'$CompanyId$'	) 
	end
end  

GO

 