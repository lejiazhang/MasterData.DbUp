/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboBP_ROLE_ASOC]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboBP_ROLE_ASOC]
		@ROLE_ASOC_ID int,
		@BP_ROLE_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@BUSS_PTNR_ID int,
   		@ACT_IND bit not null,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
if (@FLAG = 'D' AND exists(select 1 from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @BUSS_PTNR_ID and [RoleID] = @BP_ROLE_ID))
begin
	delete from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @BUSS_PTNR_ID and [RoleID] = @BP_ROLE_ID
end 
else
begin
	if exists(select 1 from [dbo].[BusinessPartnerRole] where [BusinessPartnerID] = @BUSS_PTNR_ID and [RoleID] = @BP_ROLE_ID)
	begin
		update [dbo].[BusinessPartnerRole] set
				[RoleID] = case substring(@bitmap,1,1) & 2 when 2 then @BP_ROLE_ID else [RoleID] end,
				[BusinessPartnerID] = case substring(@bitmap,1,1) & 64 when 64 then @BUSS_PTNR_ID else [BusinessPartnerID] end,
				[ActivateInd] = case substring(@bitmap,1,1) & 128 when 128 then @ACT_IND else [ActivateInd] end
		where [BusinessPartnerID] = @BUSS_PTNR_ID
	end
end
begin
		declare @primarykey_text nvarchar(100) = ''
		if (substring(@bitmap,1,1) & 1 = 1)
		begin 

		update [dbo].[BP_ROLE_ASOC] set
				[ROLE_ASOC_ID] = case substring(@bitmap,1,1) & 1 when 1 then @ROLE_ASOC_ID else [ROLE_ASOC_ID] end,
				[BP_ROLE_ID] = case substring(@bitmap,1,1) & 2 when 2 then @BP_ROLE_ID else [BP_ROLE_ID] end,
				[INSR_DTE] = case substring(@bitmap,1,1) & 4 when 4 then @INSR_DTE else [INSR_DTE] end,
				[UPDT_DTE] = case substring(@bitmap,1,1) & 8 when 8 then @UPDT_DTE else [UPDT_DTE] end,
				[EXEC_DTE] = case substring(@bitmap,1,1) & 16 when 16 then @EXEC_DTE else [EXEC_DTE] end,
				[FLAG] = case substring(@bitmap,1,1) & 32 when 32 then @FLAG else [FLAG] end,
				[BUSS_PTNR_ID] = case substring(@bitmap,1,1) & 64 when 64 then @BUSS_PTNR_ID else [BUSS_PTNR_ID] end,
				[ACT_IND] = case substring(@bitmap,1,1) & 128 when 128 then @ACT_IND else [ACT_IND] end
			where [ROLE_ASOC_ID] = @pkc1

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
			
					set @primarykey_text = @primarykey_text + '[ROLE_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ROLE_ASOC]', @param2=@primarykey_text, @param3=13233
				End
		end  
		else
		begin 

		update [dbo].[BP_ROLE_ASOC] set
				[BP_ROLE_ID] = case substring(@bitmap,1,1) & 2 when 2 then @BP_ROLE_ID else [BP_ROLE_ID] end,
				[INSR_DTE] = case substring(@bitmap,1,1) & 4 when 4 then @INSR_DTE else [INSR_DTE] end,
				[UPDT_DTE] = case substring(@bitmap,1,1) & 8 when 8 then @UPDT_DTE else [UPDT_DTE] end,
				[EXEC_DTE] = case substring(@bitmap,1,1) & 16 when 16 then @EXEC_DTE else [EXEC_DTE] end,
				[FLAG] = case substring(@bitmap,1,1) & 32 when 32 then @FLAG else [FLAG] end,
				[BUSS_PTNR_ID] = case substring(@bitmap,1,1) & 64 when 64 then @BUSS_PTNR_ID else [BUSS_PTNR_ID] end,
				[ACT_IND] = case substring(@bitmap,1,1) & 128 when 128 then @ACT_IND else [ACT_IND] end
			where [ROLE_ASOC_ID] = @pkc1

		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
			
					set @primarykey_text = @primarykey_text + '[ROLE_ASOC_ID] = ' + convert(nvarchar(100),@pkc1,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[BP_ROLE_ASOC]', @param2=@primarykey_text, @param3=13233
				End
		end 
	end
end
GO

