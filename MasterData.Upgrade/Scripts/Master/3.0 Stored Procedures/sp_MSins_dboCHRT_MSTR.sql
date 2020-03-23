IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboCHRT_MSTR]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboCHRT_MSTR]
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
    if (@FLAG = 'I' and not EXISTS (SELECT 1 FROM [dbo].[ChartMain] WHERE [ChartMainID] = @MSTR_ID))
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
        '$CompanyId$'	) 
    end  

end

GO