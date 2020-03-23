IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboBP_RLSP_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboBP_RLSP_ASOC]
GO

create procedure [dbo].[sp_MSdel_dboBP_RLSP_ASOC]
		@RLSP_ASOC_ID int,
		@BUSS_PTNR_ID int,
		@RLTN_MAIN_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1)
as
begin  

if exists (select 1 from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID)
begin
	delete from [dbo].[Relationship] where [ParentID] = @BUSS_PTNR_ID and [RelationshipID] = @RLTN_MAIN_ID
end


	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[BP_RLSP_ASOC] 
	where [RLSP_ASOC_ID] = @RLSP_ASOC_ID
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[RLSP_ASOC_ID] = ' + convert(nvarchar(100),@RLSP_ASOC_ID,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_RLSP_ASOC]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
GO


