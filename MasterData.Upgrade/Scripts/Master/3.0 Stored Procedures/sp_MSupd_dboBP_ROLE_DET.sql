/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboBP_ROLE_DET]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboBP_ROLE_DET]
		@c1 int = NULL,
		@c2 varchar(50) = NULL,
		@c3 bit = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
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

if (@c9 = 'D')
begin
	if (@BuinessPartnerId IS NOT NULL AND @RoleId IS NOT NULL)
	begin
		update [dbo].[BusinessPartner]
			set [PMSDealerNbr] = '',
				[DealerPaymentCategoryId] = NULL
		where [BusinessPartnerID] = @BuinessPartnerId
	end
end
else
begin
	declare @primarykey_text nvarchar(100) = ''

	if (@BuinessPartnerId IS NOT NULL AND @RoleId IS NOT NULL)
	begin
		update [dbo].[BusinessPartner]
			set [PMSDealerNbr] = @c2,
				[DealerPaymentCategoryId] = @c4
		where [BusinessPartnerID] = @BuinessPartnerId
	end

	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[ROLE_DET_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ROLE_DET]', @param2=@primarykey_text, @param3=13233
			End
	end  
end

GO