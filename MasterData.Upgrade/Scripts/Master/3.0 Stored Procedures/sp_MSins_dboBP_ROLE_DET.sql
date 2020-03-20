/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_ROLE_DET]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboBP_ROLE_DET]
    @c1 int,
    @c2 varchar(50),
    @c3 bit,
    @c4 int,
    @c5 int,
    @c6 datetime,
    @c7 datetime,
    @c8 datetime,
    @c9 char(1)
as

begin
	if (@c9 = 'I')
	begin  

		declare @BuinessPartnerId int, @RoleId int;
		
		select top 1  @BuinessPartnerId = [BP_ROLE].[BUSS_PTNR_ID], @RoleId = [BP_ROLE].[BP_ROLE_ID]
		from [dbo].[BP_ROLE_ASOC] [BP_ROLE] 
		where [BP_ROLE].[ROLE_ASOC_ID] = @c4 
			and [BP_ROLE].[BP_ROLE_ID] = 
			(
				select top 1 LKUP_DET_ID from LKUP_DET where 
				LKUP_MAIN_ID = (select top 1 LKUP_MAIN_ID from LKUP_MAIN where NME = 'BpRoleTypeCode')
				AND NME = 'Dealer'
			)

		if (@BuinessPartnerId IS NOT NULL AND @RoleId IS NOT NULL)
		begin
			update [dbo].[BusinessPartner]
				set [PMSDealerNbr] = @c2
			where [BusinessPartnerID] = @BuinessPartnerId
		end
		
	end  
end

GO