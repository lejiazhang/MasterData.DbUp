IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboASET_MODL_CODE]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboASET_MODL_CODE]
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

    if (@FLAG = 'I' and not exists(SELECT 1 FROM [dbo].[AssetModel] WHERE [AssetModelExternalID] = @MODL_ID))
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