/****** Object:  StoredProcedure [dbo].[sp_MSupd_dboCHRT_MSTR]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_dboCHRT_MSTR]
		@c1 int = NULL,
		@c2 varchar(100) = NULL,
		@c3 int = NULL,
		@c4 bit = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin  
	declare @primarykey_text nvarchar(100) = ''


if (@c8 = 'D' and EXISTS (SELECT 1 FROM [dbo].[ChartMain] WHERE [ChartMainID] = @pkc1))
begin
	DELETE FROM [dbo].[ChartMain] WHERE [ChartMainID] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[ChartMain] WHERE [ChartMainID] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[ChartMain] set
			[ChartMainID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ChartMainID] end,
			[ChartName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ChartName] end,
			[TransactionTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TransactionTypeID] end,
			[ActiveIND] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActiveIND] end,
			[CreationDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreationDate] end
		
		where [ChartMainID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MSTR_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[CHRT_MSTR]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[ChartMain] set
			[ChartName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ChartName] end,
			[TransactionTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TransactionTypeID] end,
			[ActiveIND] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActiveIND] end,
			[CreationDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreationDate] end
		
		where [ChartMainID] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[MSTR_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[CHRT_MSTR]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end
end 
end
GO