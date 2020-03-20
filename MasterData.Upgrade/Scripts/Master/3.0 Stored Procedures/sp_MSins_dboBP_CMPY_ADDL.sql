/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_CMPY_ADDL]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboBP_CMPY_ADDL]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 datetime,
    @c6 datetime,
    @c7 char(1)
as

begin
    if (@c7 = 'I')
    begin  
        if exists (select 1 from [dbo].[BusinessPartnerCompany] where [BusinessPartnerID] =  @c2)
        begin
            
            update [dbo].[BusinessPartnerCompany] set
                    
                    [BusinessTypeCDE] =  @c3

            where [BusinessPartnerID] = @c2
            
        end
    end 

end

GO