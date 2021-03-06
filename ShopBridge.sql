USE [master]
GO
/****** Object:  Database [ShopBridge]    Script Date: 6/4/2022 12:28:42 AM ******/
CREATE DATABASE [ShopBridge]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ShopBridge', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS2014\MSSQL\DATA\ShopBridge.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ShopBridge_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS2014\MSSQL\DATA\ShopBridge_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ShopBridge] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ShopBridge].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ShopBridge] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ShopBridge] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ShopBridge] SET ARITHABORT OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ShopBridge] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ShopBridge] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ShopBridge] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ShopBridge] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ShopBridge] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ShopBridge] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ShopBridge] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ShopBridge] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ShopBridge] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ShopBridge] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ShopBridge] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ShopBridge] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ShopBridge] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ShopBridge] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ShopBridge] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ShopBridge] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ShopBridge] SET  MULTI_USER 
GO
ALTER DATABASE [ShopBridge] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ShopBridge] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ShopBridge] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ShopBridge] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ShopBridge] SET DELAYED_DURABILITY = DISABLED 
GO
USE [ShopBridge]
GO
/****** Object:  Table [dbo].[T_Error_Log]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Error_Log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorMessage] [varchar](500) NOT NULL,
	[ErrorDate] [datetime] NOT NULL,
	[ErrorLine] [int] NOT NULL,
	[ErrorNumber] [int] NOT NULL,
 CONSTRAINT [PK_T_Error_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Item_Master]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Item_Master](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemCode] [varchar](50) NOT NULL,
	[ItemDescription] [varchar](150) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[UOMID] [int] NOT NULL,
	[ConversionFactor] [int] NOT NULL,
 CONSTRAINT [PK_T_Item_Master] PRIMARY KEY CLUSTERED 
(
	[ItemCode] ASC,
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T_Uom_Master]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Uom_Master](
	[UOMID] [int] IDENTITY(1,1) NOT NULL,
	[UOMCode] [varchar](100) NOT NULL,
 CONSTRAINT [PK_T_Uom_Master] PRIMARY KEY CLUSTERED 
(
	[UOMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T_Error_Log] ADD  CONSTRAINT [DF_T_Error_Log_ErrorDate]  DEFAULT (getdate()) FOR [ErrorDate]
GO
ALTER TABLE [dbo].[T_Item_Master]  WITH CHECK ADD  CONSTRAINT [FK_T_Item_Master_T_Uom_Master] FOREIGN KEY([UOMID])
REFERENCES [dbo].[T_Uom_Master] ([UOMID])
GO
ALTER TABLE [dbo].[T_Item_Master] CHECK CONSTRAINT [FK_T_Item_Master_T_Uom_Master]
GO
/****** Object:  StoredProcedure [dbo].[P_Create_New_Item]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[P_Create_New_Item]
(
@ItemCode varchar(50),
@ItemDescription varchar(150),
@Price decimal(18, 2),
 @UOM varchar(10),
 @ConversionFactor int
 )
AS
BEGIN
 
BEGIN TRY
INSERT INTO T_Uom_Master([UOMCode]) VALUES(@UOM)

INSERT INTO T_Item_Master([ItemCode],[ItemDescription],[Price],[UOMID],[ConversionFactor]) VALUES(@ItemCode,@ItemDescription,@Price,SCOPE_IDENTITY(),@ConversionFactor)
END TRY
BEGIN CATCH
 INSERT INTO T_Error_Log ([ErrorMessage],[ErrorLine],[ErrorNumber]) VALUES(ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER())
END CATCH;

END
GO
/****** Object:  StoredProcedure [dbo].[P_Delete_Item]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Delete_Item]
(
@ItemID INT
 )
AS
BEGIN
BEGIN TRY
DELETE FROM T_Item_Master WHERE ItemID=@ItemID
END TRY
BEGIN CATCH
 INSERT INTO T_Error_Log ([ErrorMessage],[ErrorLine],[ErrorNumber]) VALUES(ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER())
END CATCH;

END
GO
/****** Object:  StoredProcedure [dbo].[P_Get_Items]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[P_Get_Items]

AS
BEGIN
BEGIN TRY
SELECT * FROM T_Item_Master 
END TRY
BEGIN CATCH
 INSERT INTO T_Error_Log ([ErrorMessage],[ErrorLine],[ErrorNumber]) VALUES(ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER())
END CATCH;

END
GO
/****** Object:  StoredProcedure [dbo].[P_Update_Item]    Script Date: 6/4/2022 12:28:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[P_Update_Item]
(
@ItemID INT,
@ItemDescription varchar(150),
@Price decimal(18, 2),
@UOMID int ,
@ConversionFactor int
 )
AS
BEGIN
BEGIN TRY
UPDATE T_Item_Master SET [ItemDescription] =@ItemDescription,[Price]=@Price, [UOMID]=@UOMID,[ConversionFactor] =@ConversionFactor WHERE ItemID=@ItemID
END TRY
BEGIN CATCH
 INSERT INTO T_Error_Log ([ErrorMessage],[ErrorLine],[ErrorNumber]) VALUES(ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER())
END CATCH;

END
GO
USE [master]
GO
ALTER DATABASE [ShopBridge] SET  READ_WRITE 
GO
