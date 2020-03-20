/****** Object:  StoredProcedure [dbo].[sp_MSins_dboASET_MODL_CODE]    Script Date: 2/11/2020 9:04:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboASET_MODL_CODE]
    @MODL_ID int,
    @NME nvarchar(200),
    @DSCR nvarchar(1000),
    @EXTR_MODL_CODE char(18),
    @MAKE_TYPE_ID int,
    @ASET_TYPE_ID int,
    @ASET_SBTP_ID int,
    @BRND_TYPE_ID int,
    @BLAZ_TYPE_ID int,
    @NST int,
    @MSRP nvarchar(40),
    @EXTR_CODE decimal(21,5),
    @ACT_IND varchar(10),
    @INSR_DTE bit,
    @UPDT_DTE datetime,
    @EXEC_DTE datetime,
    @FLAG char(1)
as

begin

    insert into [dbo].[ASET_MODL_CODE] (
		[MODL_ID],
		[NME],
		[DSCR],
		[EXTR_MODL_CODE],
		[MAKE_TYPE_ID],
		[ASET_TYPE_ID],
		[ASET_SBTP_ID],
		[BRND_TYPE_ID],
		[BLAZ_TYPE_ID],
		[NST],
		[MSRP],
		[EXTR_CODE],
		[ACT_IND],
		[INSR_DTE],
		[UPDT_DTE],
		[EXEC_DTE],
		[FLAG]
	) values (
		@MODL_ID,
		@NME,
		@DSCR,
		@EXTR_MODL_CODE,
		@MAKE_TYPE_ID,
		@ASET_TYPE_ID,
		@ASET_SBTP_ID,
		@BRND_TYPE_ID,
		@BLAZ_TYPE_ID,
		@NST,
		@MSRP,
		@EXTR_CODE,
		@ACT_IND,
		@INSR_DTE,
		@UPDT_DTE,
		@EXEC_DTE,
		@FLAG	) 

    if (@c17 = 'I' and not exists(SELECT 1 FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @MODL_ID))
    begin  
        insert into [dbo].[AssetModel](
            [AssetModelExternalID],
            [CarNameEN],
            [ActiveIND]
            
        ) values (
        @MODL_ID,
        @NME,
        @ACT_IND) 
    end 
end

GO