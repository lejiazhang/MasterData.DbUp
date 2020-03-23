IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSupd_dboCHRT_DCSN_TABL]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSupd_dboCHRT_DCSN_TABL]
GO

create procedure [dbo].[sp_MSupd_dboCHRT_DCSN_TABL]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 varchar(25) = NULL,
		@c4 varchar(25) = NULL,
		@c5 varchar(25) = NULL,
		@c6 varchar(25) = NULL,
		@c7 varchar(25) = NULL,
		@c8 varchar(25) = NULL,
		@c9 varchar(25) = NULL,
		@c10 varchar(25) = NULL,
		@c11 varchar(25) = NULL,
		@c12 varchar(25) = NULL,
		@c13 varchar(25) = NULL,
		@c14 varchar(25) = NULL,
		@c15 varchar(25) = NULL,
		@c16 varchar(25) = NULL,
		@c17 varchar(25) = NULL,
		@c18 varchar(25) = NULL,
		@c19 varchar(25) = NULL,
		@c20 varchar(25) = NULL,
		@c21 varchar(25) = NULL,
		@c22 varchar(25) = NULL,
		@c23 varchar(25) = NULL,
		@c24 varchar(25) = NULL,
		@c25 varchar(25) = NULL,
		@c26 varchar(25) = NULL,
		@c27 varchar(25) = NULL,
		@c28 varchar(25) = NULL,
		@c29 varchar(25) = NULL,
		@c30 varchar(25) = NULL,
		@c31 varchar(25) = NULL,
		@c32 varchar(25) = NULL,
		@c33 varchar(25) = NULL,
		@c34 varchar(25) = NULL,
		@c35 varchar(25) = NULL,
		@c36 varchar(25) = NULL,
		@c37 varchar(25) = NULL,
		@c38 varchar(25) = NULL,
		@c39 varchar(25) = NULL,
		@c40 varchar(25) = NULL,
		@c41 datetime = NULL,
		@c42 datetime = NULL,
		@c43 datetime = NULL,
		@c44 char(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(6)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

if (@c44 = 'D' and EXISTS (SELECT 1 FROM [dbo].[ChartDetail] WHERE [ChartDetailSEQ] = @pkc1))
begin
	DELETE FROM [dbo].[ChartDetail] WHERE [ChartDetailSEQ] = @pkc1
end
else
begin
if EXISTS (SELECT 1 FROM [dbo].[ChartDetail] WHERE [ChartDetailSEQ] = @pkc1)
begin
	if (substring(@bitmap,1,1) & 1 = 1)
	begin 

	update [dbo].[ChartDetail] set
			[ChartDetailSEQ] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ChartDetailSEQ] end,
			[ChartMainID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ChartMainID] end,
			[VehicleTypeCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [VehicleTypeCode] end,
			[AssetMakeCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AssetMakeCode] end,
			[AssetBrandCode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AssetBrandCode] end,
			[AssetModelCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AssetModelCode] end,
			[AssetConditionCode] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AssetConditionCode] end,
			[RentalModeType] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RentalModeType] end,
			[MinimumRate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MinimumRate] end,
			[MaximumRate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MaximumRate] end,
			[ChartValue] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ChartValue] end,
			[StandardRate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StandardRate] end,
			[DownPaymentRangeID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [DownPaymentRangeID] end,
			[AgeRangeID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [AgeRangeID] end,
			[ModelYearCDE] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [ModelYearCDE] end,
			[ProductionYearCDE] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ProductionYearCDE] end,
			[MileagePerYearCDE] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [MileagePerYearCDE] end,
			[NfaPercentage] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [NfaPercentage] end,
			[AmountRangeID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [AmountRangeID] end,
			[TermRangeID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [TermRangeID] end,
			[NfaPercentage] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [NfaPercentage] end,
			[CommissionFixedAmount] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CommissionFixedAmount] end,
			[FCCommissionAmount] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [FCCommissionAmount] end,
			[FCCommissionPercentage] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [FCCommissionPercentage] end,
			[MinimumCommissionAmount] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [MinimumCommissionAmount] end,
			[EffStartDate] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [EffStartDate] end,
			[EffEndDate] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [EffEndDate] end,
			[NST] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [NST] end,
			[OptionPricePct] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [OptionPricePct] end

		where [ChartDetailSEQ] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[DCSN_TABL_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[CHRT_DCSN_TABL]', @param2=@primarykey_text, @param3=13233
			End
	end  
	else
	begin 

	update [dbo].[ChartDetail] set
			[ChartMainID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ChartMainID] end,
			[VehicleTypeCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [VehicleTypeCode] end,
			[AssetMakeCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AssetMakeCode] end,
			[AssetBrandCode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AssetBrandCode] end,
			[AssetModelCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AssetModelCode] end,
			[AssetConditionCode] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AssetConditionCode] end,
			[RentalModeType] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RentalModeType] end,
			[MinimumRate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MinimumRate] end,
			[MaximumRate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MaximumRate] end,
			[ChartValue] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ChartValue] end,
			[StandardRate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StandardRate] end,
			[DownPaymentRangeID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [DownPaymentRangeID] end,
			[AgeRangeID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [AgeRangeID] end,
			[ModelYearCDE] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [ModelYearCDE] end,
			[ProductionYearCDE] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ProductionYearCDE] end,
			[MileagePerYearCDE] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [MileagePerYearCDE] end,
			[NfaPercentage] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [NfaPercentage] end,
			[AmountRangeID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [AmountRangeID] end,
			[TermRangeID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [TermRangeID] end,
			[NfaPercentage] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [NfaPercentage] end,
			[CommissionFixedAmount] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CommissionFixedAmount] end,
			[FCCommissionAmount] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [FCCommissionAmount] end,
			[FCCommissionPercentage] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [FCCommissionPercentage] end,
			[MinimumCommissionAmount] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [MinimumCommissionAmount] end,
			[EffStartDate] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [EffStartDate] end,
			[EffEndDate] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [EffEndDate] end,
			[NST] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [NST] end,
			[OptionPricePct] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [OptionPricePct] end

		where [ChartDetailSEQ] = @pkc1
	if @@rowcount = 0
		if @@microsoftversion>0x07320000
			Begin
			
				set @primarykey_text = @primarykey_text + '[DCSN_TABL_ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[CHRT_DCSN_TABL]', @param2=@primarykey_text, @param3=13233
			End
	end 
	end 
end
end
GO