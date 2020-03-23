IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboFP_TMPL_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboFP_TMPL_ASOC]
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_ASOC]
		@c1 int,
		@c2 int,
		@c3 int,
		@c4 int,
		@c5 int,
		@c6 datetime,
		@c7 datetime,
		@c8 datetime,
		@c9 char(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[FP_TMPL_ASOC] 
	where [TMPL_ASOC_ID] = @c1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@c1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_ASOC]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
GO


