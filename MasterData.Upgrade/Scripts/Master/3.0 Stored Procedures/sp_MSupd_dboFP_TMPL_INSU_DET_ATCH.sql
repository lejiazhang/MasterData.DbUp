IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboFP_TMPL_INSU_DET_ATCH]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboFP_TMPL_INSU_DET_ATCH]
GO

create procedure [dbo].[sp_MSupd_dboFP_TMPL_INSU_DET_ATCH]
		@INSU_DET_ATCH_ID_OLD int,
		@TMPL_INSU_ATCH_ID_OLD int,
		@INSU_TYPE_ID_OLD int,
		@INRT_RATE_TYPE_ID_OLD int,
		@INSR_DTE_OLD datetime,
		@UPDT_DTE_OLD datetime,
		@EXEC_DTE_OLD datetime,
		@FLAG_OLD char(11),
		@TMPL_ASOC_ID_OLD int,
		@INSU_DET_ATCH_ID int,
		@TMPL_INSU_ATCH_ID int,
		@INSU_TYPE_ID int,
		@INRT_RATE_TYPE_ID int,
		@INSR_DTE datetime,
		@UPDT_DTE datetime,
		@EXEC_DTE datetime,
		@FLAG char(11),
		@TMPL_ASOC_ID int
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	declare @FinancialProductId int, @FinancialParameterId int;
	select @FinancialProductId = [FNCL_PROD_ID] from [dbo].[FP_TMPL_ASOC] where [TMPL_ASOC_ID] = @TMPL_ASOC_ID
	
	if @FLAG = 'D' AND NOT (@FinancialProductId is null)
	begin
		if @INSU_TYPE_ID = 1  -- Compulsory Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCompInsInd]		    = '0',
				[SubsidyCompInsInd]	    = '0',
			    [ZeroCompInsInd]	    = '0'
			where [FinancialProductID]  = @FinancialProductId
		end

		if @INSU_TYPE_ID = 3  -- Commercial Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCommInsInd]			= '0',
				[SubsidyCommInsInd]		= '0',
			    [ZeroCommInsInd]	    = '0'
			where [FinancialProductID]  = @FinancialProductId
		end

		if @INSU_TYPE_ID = 4  -- Vessel Tax
		begin
			update [dbo].[FinancialProduct] set
				[AppVtInd]				= '0',
				[SubsidyVtInd]			= '0',
			    [ZeroVtInd]				= '0'
			where [FinancialProductID]  = @FinancialProductId
		end
	end
	else
	begin

		if @INSU_TYPE_ID = 1  -- Compulsory Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCompInsInd]	   = '1',
				[SubsidyCompInsInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroCompInsInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end

		if @INSU_TYPE_ID = 3  -- Commercial Insurance
		begin
			update [dbo].[FinancialProduct] set
				[AppCommInsInd]	   = '1',
				[SubsidyCommInsInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroCommInsInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end

		if @INSU_TYPE_ID = 4  -- Vessel Tax
		begin
			update [dbo].[FinancialProduct] set
				[AppVtInd]	   = '1',
				[SubsidyVtInd] = case @INRT_RATE_TYPE_ID when 1 then '1' else '0' end,
			    [ZeroVtInd]	   = case @INRT_RATE_TYPE_ID when 3 then '1' else '0' end
			where [FinancialProductID] = @FinancialProductId
		end
	end

	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
				if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
				Begin
				
					set @primarykey_text = @primarykey_text + '[INSU_DET_ATCH_ID] = ' + convert(nvarchar(100),@INSU_DET_ATCH_ID_OLD,1) + ', '
					set @primarykey_text = @primarykey_text + '[TMPL_ASOC_ID] = ' + convert(nvarchar(100),@TMPL_ASOC_ID_OLD,1)
					exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FP_TMPL_INSU_DET_ATCH]', @param2=@primarykey_text, @param3=13233 
				End
				Else
					exec sp_MSreplraiserror @errorid=20598
			End
 
end 
GO