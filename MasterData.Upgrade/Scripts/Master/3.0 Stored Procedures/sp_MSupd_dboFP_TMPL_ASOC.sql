IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_TMPL_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_TMPL_ASOC]
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_ASOC]
		@c1 int,
		@c2 int,
		@c3 int,
		@c4 int,
		@c5 int,
		@c6 datetime,
		@c7 datetime,
		@c8 datetime,
		@c9 char(1),
		@c10 int,
		@c11 int,
		@c12 int,
		@c13 int,
		@c14 int,
		@c15 datetime,
		@c16 datetime,
		@c17 datetime,
		@c18 char(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if not (@c10 = @c1)
begin 
update [dbo].[FP_TMPL_ASOC] set
		[TMPL_ASOC_ID] = @c10,
		[FNCL_PROD_ID] = @c11,
		[TMPL_ATCH_ID] = @c12,
		[TMPL_TYPE_ID] = @c13,
		[TMPL_PRTY_TYPE_ID] = @c14,
		[INSR_DTE] = @c15,
		[UPDT_DTE] = @c16,
		[EXEC_DTE] = @c17,
		[FLAG] = @c18
	where [TMPL_ASOC_ID] = @c1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@c1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_ASOC]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 
update [dbo].[FP_TMPL_ASOC] set
		[FNCL_PROD_ID] = @c11,
		[TMPL_ATCH_ID] = @c12,
		[TMPL_TYPE_ID] = @c13,
		[TMPL_PRTY_TYPE_ID] = @c14,
		[INSR_DTE] = @c15,
		[UPDT_DTE] = @c16,
		[EXEC_DTE] = @c17,
		[FLAG] = @c18
	where [TMPL_ASOC_ID] = @c1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@c1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_ASOC]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end 
GO


