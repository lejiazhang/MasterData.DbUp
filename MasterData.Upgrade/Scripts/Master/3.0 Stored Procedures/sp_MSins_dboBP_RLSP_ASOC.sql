/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_RLSP_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
			   ,2
			   )
	end
end  

GO