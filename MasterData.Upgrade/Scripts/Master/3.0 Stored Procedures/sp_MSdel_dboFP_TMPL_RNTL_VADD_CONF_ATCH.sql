IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSdel_dboFP_TMPL_RNTL_VADD_CONF_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSdel_dboFP_TMPL_RNTL_VADD_CONF_ATCH]
GO

create procedure [dbo].[sp_MSdel_dboFP_TMPL_RNTL_VADD_CONF_ATCH]
		@RNTL_VADD_CONF_ATCH_ID int,
		@TMPL_RNTL_ATCH_ID int,
		@CMPT_APLC_IND bit,
		@INRT_RATE_TYPE_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(1),
		@TMPL_ASOC_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''

	declare @FinancialProductId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID

	if not (@FinancialProductId is null)
	begin
		update [dbo].[FinancialProduct] set
				[AppPtInd]	   = '0',
				[SubsidyPtInd] = '0',
			    [ZeroPtInd]	   = '0'
		where [FinancialProductID] = @FinancialProductId
		if @@rowcount = 0
			if @@microsoftversion>0x07320000
				Begin
					if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
					Begin
				
						set @primarykey_text = @primarykey_text + '[RNTL_VADD_CONF_ATCH_ID] = ' + convert(nvarchar(100),@RNTL_VADD_CONF_ATCH_ID,1) + ', '
						set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID,1)
						exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_RNTL_VADD_CONF_ATCH]', @param2=@primarykey_text, @param3=13234 
					End
					Else
						exec sp_MSreplraiserror @errorid=20598
				End
	end

end  
GO
