IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboBP_RLSP_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboBP_RLSP_ASOC]
GO

create procedure [dbo].[sp_MSupd_dboBP_RLSP_ASOC]
		@RLSP_ASOC_ID_Old int,
		@BUSS_PTNR_ID_Old int,
		@RLTN_MAIN_ID_Old int,
		@INSR_DTE_Old datetime,
		@UPDT_DTE_Old datetime,
		@EXEC_DTE_Old datetime,
		@FLAG_Old char(1),
		@RLSP_ASOC_ID int,
		@BUSS_PTNR_ID int,
		@RLTN_MAIN_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@FLAG = 'D')
begin
	if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID)
	begin
		delete from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID
	end
end

if (@FLAG = 'U')
begin
	if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID_Old and [RelationshipID] = @RLTN_MAIN_ID_Old)
	begin
		update [dbo].[Relationship] set [ParentID] = @BUSS_PTNR_ID, [RelationshipID] = @RLTN_MAIN_ID
	end
	if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID)
	begin
		update [dbo].[Relationship] set [ParentID] = @BUSS_PTNR_ID, [RelationshipID] = @RLTN_MAIN_ID
	end
end

if not (@RLSP_ASOC_ID = @RLSP_ASOC_ID_Old)
begin 
update [dbo].[BP_RLSP_ASOC] set
		[RLSP_ASOC_ID] = @RLSP_ASOC_ID,
		[BUSS_PTNR_ID] = @BUSS_PTNR_ID,
		[RLTN_MAIN_ID] = @RLTN_MAIN_ID,
		[INSR_DTE] = @INSR_DTE,
		[UPDT_DTE] = @UPDT_DTE,
		[EXEC_DTE] = @EXEC_DTE,
		[FLAG] = @FLAG
	where [RLSP_ASOC_ID] = @RLSP_ASOC_ID_Old
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[RLSP_ASOC_ID] = ' + convert(nvarchar(100),@RLSP_ASOC_ID_Old,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_RLSP_ASOC]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 
update [dbo].[BP_RLSP_ASOC] set
		[BUSS_PTNR_ID] = @BUSS_PTNR_ID,
		[RLTN_MAIN_ID] = @RLTN_MAIN_ID,
		[INSR_DTE] = @INSR_DTE,
		[UPDT_DTE] = @UPDT_DTE,
		[EXEC_DTE] = @EXEC_DTE,
		[FLAG] = @FLAG
	where [RLSP_ASOC_ID] = @RLSP_ASOC_ID_Old
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[RLSP_ASOC_ID] = ' + convert(nvarchar(100),@RLSP_ASOC_ID_Old,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_RLSP_ASOC]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end 
GO


