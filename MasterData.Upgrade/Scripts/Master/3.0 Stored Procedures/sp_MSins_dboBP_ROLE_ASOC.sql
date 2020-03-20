/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_ROLE_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboBP_ROLE_ASOC]
    @ROLE_ASOC_ID int,
    @BP_ROLE_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1),
    @BUSS_PTNR_ID int,
    @ACT_IND bit not null
as

begin
    insert into [dbo].[BP_ROLE_ASOC](
            [ROLE_ASOC_ID],
            [BP_ROLE_ID],
            [INSR_DTE],
            [UPDT_DTE],
            [EXEC_DTE],
            [FLAG],
            [BUSS_PTNR_ID],
            [ACT_IND]
        ) values (
        @ROLE_ASOC_ID,
        @BP_ROLE_ID,
        @INSR_DTE,
        @UPDT_DTE,
        @EXEC_DTE,
        @FLAG,
        @BUSS_PTNR_ID,
        @ACT_IND	) 

    if (@c6 = 'I' and not exists (select 1 from [dbo].[BusinessPartnerRole] where [RoleID] = @c2 and [BusinessPartnerID] = @c7))
    begin  
        insert into [dbo].[BusinessPartnerRole](
            [RoleID],
            [BusinessPartnerID],
            [CompanyId],
            [ActivateInd]
        ) values (
        @BP_ROLE_ID,
        @BUSS_PTNR_ID,
        2,
        @ACT_IND	) 
    end  
end
GO