USE ABCASSET

/****** Object:  Table [dbo].[STORE_ASSET_temp2]    Script Date: 2026-10-28 오후 12:05:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[STORE](
	[STORE_CD] [varchar](4) NOT NULL,
	[STORE_NM_KOR] [varchar](30) NOT NULL,
	[OPEN_STORE_DT] [date] NULL,
	[RENEWAL_STORE_DT] [date] NULL,
	[CLOSE_STORE_DT] [date] NULL,
	[STORE_ST] [varchar](50) NULL,
	[DIR_JOIN_FLAG] [varchar](50) NULL,
	[DIRECT_TYPE] [varchar](50) NULL,
	[STORE_CHANNEL] [varchar](50) NULL,
	[SENDR_ADDR] [varchar](200) NULL,
	[SENDR_DETAIL_ADDR] [varchar](200) NULL,
	[SENDR_ZIP_NO] [varchar](10) NULL,
	[X_POINT] [numeric](10, 5) NULL,
	[Y_POINT] [numeric](10, 5) NULL,

	CONSTRAINT PK_STORE PRIMARY KEY (STORE_CD)
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매장코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'STORE_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매장명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'STORE_NM_KOR'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'오픈일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'OPEN_STORE_DT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'리뉴얼일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'RENEWAL_STORE_DT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'폐점일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'CLOSE_STORE_DT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'STORE_ST'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운영채널' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'DIR_JOIN_FLAG'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직영여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'DIRECT_TYPE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매장채널' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'STORE_CHANNEL'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'SENDR_ADDR'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소상세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'SENDR_DETAIL_ADDR'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'SENDR_ZIP_NO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'X좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'X_POINT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Y좌표' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STORE', @level2type=N'COLUMN',@level2name=N'Y_POINT'

/****** Object:  Table [dbo].[ASSET_CATEGORY]    Script Date: 2026-10-29 오전 9:19:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSET_CATEGORY](
	[ASSET_CATEGORY_CD] [int] NOT NULL,
	[ASSET_CATEGORY_NM] [varchar](100) NOT NULL,
	[ASSET_CATEGORY_PARENT_CD] [int] NULL,
	[ASSET_CATEGORY_LEVEL] [int] NOT NULL,
	CONSTRAINT PK_ASSET_CATEGORY PRIMARY KEY ([ASSET_CATEGORY_CD])
) ON [PRIMARY]
GO

ALTER TABLE DBO.[ASSET_CATEGORY] ADD 
CONSTRAINT FK_ASSET_CATEGORY
FOREIGN KEY (ASSET_CATEGORY_PARENT_CD)
REFERENCES dbo.ASSET_CATEGORY(ASSET_CATEGORY_CD);

ALTER TABLE dbo.ASSET_CATEGORY
ADD CONSTRAINT CK_ASSET_CATEGORY_PARENT
CHECK (
    ASSET_CATEGORY_PARENT_CD IS NULL
    OR ASSET_CATEGORY_PARENT_CD <> ASSET_CATEGORY_CD
);



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_CATEGORY', @level2type=N'COLUMN',@level2name=N'ASSET_CATEGORY_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'카테고리명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_CATEGORY', @level2type=N'COLUMN',@level2name=N'ASSET_CATEGORY_NM'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상위카테고리코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_CATEGORY', @level2type=N'COLUMN',@level2name=N'ASSET_CATEGORY_PARENT_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_CATEGORY', @level2type=N'COLUMN',@level2name=N'ASSET_CATEGORY_LEVEL'

/****** Object:  Table [dbo].[ASSET_ITEM]    Script Date: 2026-10-29 오전 9:19:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSET_ITEM](
	[ASSET_ITEM_CD] [int] NOT NULL,
	[ASSET_ITEM_NM] [varchar](250) NOT NULL,
	CONSTRAINT PK_ASSET_ITEM PRIMARY KEY ([ASSET_ITEM_CD])
) ON [PRIMARY]
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이템코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_ITEM', @level2type=N'COLUMN',@level2name=N'ASSET_ITEM_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아이템명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_ITEM', @level2type=N'COLUMN',@level2name=N'ASSET_ITEM_NM'

/****** Object:  Table [dbo].[ASSET_USER]    Script Date: 2026-10-29 오전 9:19:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSET_USER](
	[USER_ID] [varchar](30) NOT NULL,
	[USER_NM] [varchar](50) NOT NULL,
	[USER_TITLE] [varchar](50) NULL,
	[STORE_CD] [varchar](04) NULL,
	[USE_YN] [char](1) NULL,
	
	CONSTRAINT PK_ASSET_USER PRIMARY KEY ([USER_ID])
) ON [PRIMARY]
GO

ALTER TABLE DBO.ASSET_USER ADD 
CONSTRAINT FK_ASSET_USER
FOREIGN KEY (STORE_CD)
REFERENCES dbo.STORE(STORE_CD);

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_USER', @level2type=N'COLUMN',@level2name=N'USER_ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_USER', @level2type=N'COLUMN',@level2name=N'USER_NM'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'직책' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_USER', @level2type=N'COLUMN',@level2name=N'USER_TITLE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET_USER', @level2type=N'COLUMN',@level2name=N'USE_YN'
EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'소속 매장코드',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'ASSET_USER',
    @level2type=N'COLUMN', @level2name=N'STORE_CD';

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSET](
	[ASSET_CODE] [varchar](50) NOT NULL,
	[ASSET_ITEM_CD] [int] NOT NULL,
	[ASSET_CATEGORY_CD] [int] NULL,
	[ASSET_STATUS_CD] [char](2) NOT NULL,
	[ASSET_STATUS_NM] [varchar](4) NOT NULL,
	[ASSET_USER] [varchar](30) NULL,
	[NOTE] [varchar](500) NULL,
	[NOTE2] [varchar](500) NULL,
	[NOTE3] [varchar](500) NULL,
	[REG_DATE] DATE NULL,
	[REG_NM] [varchar](50) NOT NULL,
	[UPT_DATE] DATE NULL,
	[UPT_NM] [varchar](50) NULL,
	CONSTRAINT PK_ASSET PRIMARY KEY ([ASSET_CODE])

) ON [PRIMARY]
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_CODE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산아이템코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_ITEM_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산카테고리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_CATEGORY_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_STATUS_CD'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산상태명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_STATUS_NM'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'자산사용자ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'ASSET_USER'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'NOTE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'NOTE2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'NOTE3'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'REG_DATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'등록자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'REG_NM'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'UPT_DATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSET', @level2type=N'COLUMN',@level2name=N'UPT_NM'


ALTER TABLE DBO.ASSET ADD 
	CONSTRAINT FK_ASSET_ASSET_USER
        FOREIGN KEY (ASSET_USER)
        REFERENCES dbo.ASSET_USER(USER_ID),
	CONSTRAINT FK_ASSET_ASSET_CATEGORY_CD
        FOREIGN KEY (ASSET_CATEGORY_CD)
        REFERENCES dbo.ASSET_CATEGORY(ASSET_CATEGORY_CD),
    CONSTRAINT FK_ASSET_ASSET_ASSET_ITEM
        FOREIGN KEY (ASSET_ITEM_CD)
        REFERENCES dbo.ASSET_ITEM(ASSET_ITEM_CD);


