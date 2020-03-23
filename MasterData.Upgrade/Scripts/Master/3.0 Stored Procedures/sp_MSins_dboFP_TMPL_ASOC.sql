IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MSins_dboFP_TMPL_ASOC]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sp_MSins_dboFP_TMPL_ASOC]
GO

create procedure [dbo].[sp_MSins_dboFP_TMPL_ASOC]
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
	insert into [dbo].[FP_TMPL_ASOC] (
		[TMPL_ASOC_ID],
		[FNCL_PROD_ID],
		[TMPL_ATCH_ID],
		[TMPL_TYPE_ID],
		[TMPL_PRTY_TYPE_ID],
		[INSR_DTE],
		[UPDT_DTE],
		[EXEC_DTE],
		[FLAG]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	) 
end  
GO
