/****** Object:  StoredProcedure [dbo].[sp_MSins_dboCHRT_MSTR]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboCHRT_MSTR]
    @MSTR_ID int,
    @CHRT_NME varchar(100),
    @CHRT_TYPE_ID int,
    @ACT_IND bit,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin
    if (@c8 = 'I' and not EXISTS (SELECT 1 FROM [dbo].[ChartMain] WHERE [ChartMainID] = @c1))
    begin  
        insert into [dbo].[ChartMain](
            [ChartMainID],
            [ChartName],
            [TransactionTypeID],
            [ActiveIND],
            [CreationDate],
            [CompanyID]
        ) values (
        @MSTR_ID,
        @CHRT_NME,
        @CHRT_TYPE_ID,
        @ACT_IND,
        GETDATE(),
        2	) 
    end  

end

GO