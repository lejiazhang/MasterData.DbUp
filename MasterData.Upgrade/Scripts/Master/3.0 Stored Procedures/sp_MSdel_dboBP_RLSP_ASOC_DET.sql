/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboBP_RLSP_ASOC_DET]    Script Date: 2/24/2020 5:34:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_MSdel_dboBP_RLSP_ASOC_DET]
		@RLSP_ASOC_DET_ID int,
		@SECY_BUSS_PTNR_ID int,
		@RLSP_ASOC_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1)
as
begin  

	declare @BUSS_PTNR_ID int, @RLTN_MAIN_ID int;
	select 
		@BUSS_PTNR_ID = [BUSS_PTNR_ID], 
		@RLTN_MAIN_ID = [RLTN_MAIN_ID] 
	from [dbo].[BP_RLSP_ASOC] 
	where [RLSP_ASOC_ID] = @RLSP_ASOC_ID

	if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID)
	begin
		update [dbo].[Relationship]  set [ChildID] = NULL 
		where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID
	end

	declare @primarykey_text nvarchar(100) = ''
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
				
					set @primarykey_text = @primarykey_text + '[RLSP_ASOC_DET_ID] = ' + convert(nvarchar(100),@RLSP_ASOC_DET_ID,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_RLSP_ASOC_DET]', @param2=@primarykey_text, @param3=13234 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End
end  
GO


