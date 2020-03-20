/****** Object:  StoredProcedure [dbo].[sp_MSins_dboBP_RLSP_ASOC_DET]    Script Date: 2/24/2020 4:52:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSins_dboBP_RLSP_ASOC_DET]
    @RLSP_ASOC_DET_ID int,
    @SECY_BUSS_PTNR_ID int,
    @RLSP_ASOC_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as
begin  

	if(@FLAG = 'I')
	begin

		declare @BUSS_PTNR_ID int, @RLTN_MAIN_ID int;
		select 
			@BUSS_PTNR_ID = [BUSS_PTNR_ID], 
			@RLTN_MAIN_ID = [RLTN_MAIN_ID] 
		from [dbo].[BP_RLSP_ASOC] 
		where [RLSP_ASOC_ID] = @RLSP_ASOC_ID

		if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID)
		begin
			update [dbo].[Relationship] set [ChildID] = @SECY_BUSS_PTNR_ID where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID
		end

	end
	
end  
GO


