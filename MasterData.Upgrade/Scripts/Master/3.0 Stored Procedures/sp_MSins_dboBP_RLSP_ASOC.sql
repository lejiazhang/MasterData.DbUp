IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboBP_RLSP_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboBP_RLSP_ASOC]
GO

create procedure [dbo].[sp_MSins_dboBP_RLSP_ASOC]
    @RLSP_ASOC_ID int,
    @BUSS_PTNR_ID int,
    @RLTN_MAIN_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin  
	insert into [dbo].[BP_RLSP_ASOC](
		[RLSP_ASOC_ID],
		[BUSS_PTNR_ID],
		[RLTN_MAIN_ID],
		[INSR_DTE],
		[UPDT_DTE],
		[EXEC_DTE],
		[FLAG]
	) values (
    @RLSP_ASOC_ID,
    @BUSS_PTNR_ID,
    @RLTN_MAIN_ID,
    @INSR_DTE,
    @UPDT_DTE,
    @EXEC_DTE,
    @FLAG	) 

	if (@FLAG = 'I' and not exists (select 1 from [dbo].[Relationship] where [RelationshipID] = @BUSS_PTNR_ID and [ParentID] = @RLTN_MAIN_ID))
	begin
		INSERT INTO [dbo].[Relationship]
			   ([ParentID]
			   ,[ChildID]
			   ,[RelationshipID]
			   ,[ActiveInd]
			   ,[CreationDate]
			   ,[CompanyID]
			   )
		 VALUES
			   (@BUSS_PTNR_ID
			   ,NULL
			   ,@RLTN_MAIN_ID
			   ,1
			   ,GETDATE()
			   ,'$CompanyId$'
			   )
	end
end  

GO