/****** Object:  StoredProcedure [dbo].[sp_MSdel_dboUMS_USR_EXTR_RLTN]    Script Date: 2/24/2020 8:04:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_MSdel_dboUMS_USR_EXTR_RLTN]
    @EXTR_RLTN_ID int,
    @EXTR_BP_ID int,
    @SYS_USR_ID int,
    @INSR_DTE datetime,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as

begin
    declare @companyId smallint = 1

    IF EXISTS(SELECT * FROM [dbo].[UMS_USR_EXTR_RLTN] WHERE [EXTR_RLTN_ID] = @EXTR_RLTN_ID)
		begin
			declare @primarykey_text nvarchar(100) = ''
			--declare @ParentID int
			--declare @ChildID int
			--SELECT @ParentID = EXTR_BP_ID, @ChildID = SYS_USR_ID  FROM [dbo].[UMS_USR_EXTR_RLTN] WHERE [EXTR_RLTN_ID] = @pkc1

			if  EXISTS(SELECT * FROM [dbo].Relationship WHERE ParentID = @EXTR_BP_ID and ChildID = @SYS_USR_ID and CompanyID = @companyId)
				begin
					delete [dbo].Relationship WHERE ParentID = @EXTR_BP_ID and ChildID = @SYS_USR_ID and CompanyID = @companyId

					if @@rowcount = 0
						if @@microsoftversion>0x07320000
						Begin
						if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
							Begin

								set @primarykey_text = @primarykey_text + '[EXTR_RLTN_ID] = ' + convert(nvarchar(100),@EXTR_RLTN_ID,1)
								exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[UMS_USR_EXTR_RLTN]', @param2=@primarykey_text, @param3=13234
							End
						Else
							exec sp_MSreplraiserror @errorid=20598
					End
				end
		end
end 
 