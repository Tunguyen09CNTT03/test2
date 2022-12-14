-- CAU 1 --
CREATE DATABASE QLHANG
GO
USE QLHANG
GO

CREATE TABLE VATTU(
    MAVT varchar(10) PRIMARY KEY, 
    TENVT nvarchar(50),
    DVTINH nvarchar(50),
    SLCON INT
);

CREATE TABLE HDBAN(
    MAHD varchar(10) PRIMARY KEY, 
    NGAYXUAT DATE,
    HOTENKHACH nvarchar(50)
);

CREATE TABLE HANGXUAT(
    MAHD varchar(10),
    MAVT varchar(10),
    DONGIA INT,
    SLBAN INT,
    CONSTRAINT HANGXUAT_PK PRIMARY KEY (MAHD, MAVT)
);

ALTER TABLE HANGXUAT ADD CONSTRAINT FK_HANGXUAT_HDBAN
FOREIGN KEY (MAHD) REFERENCES HDBAN (MAHD);
ALTER TABLE HANGXUAT ADD CONSTRAINT FK_HANGXUAT_VATTU
FOREIGN KEY (MAVT) REFERENCES VATTU (MAVT);

INSERT INTO VATTU VALUES
('VT01', 'GACH', 'VIEN', 100000),
('VT02', 'XI-MANG', 'BAO', 3000);

INSERT INTO HDBAN VALUES
('HD01', '2022-10-10', 'VO VAN KHUONG'),
('HD02', '2022-10-15', 'PHAM QUYNH GIANG');

INSERT INTO HANGXUAT VALUES
('HD01', 'VT01', 7000, 500),
('HD01', 'VT02', 35000, 30),
('HD02', 'VT01', 7200, 100),
('HD02', 'VT02', 38000, 40);


-- CAU 2 --
SELECT TOP 1
MAHD, SUM(SLBAN * DONGIA) AS N'Tổng Tiền'
FROM HANGXUAT
GROUP BY MAHD
ORDER BY SUM(SLBAN * DONGIA) Desc;

-- CAU 3 --
CREATE FUNCTION getThu(@ngay DATETIME) 
	RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @songaytrongtuan int;
	SET @songaytrongtuan = DATEPART(WEEKDAY, @ngay);
	DECLARE @thu NVARCHAR(100);

	IF (@songaytrongtuan = 0)
	BEGIN
	SET @thu = 'Thu hai'
	END

	IF (@songaytrongtuan = 1)
	BEGIN
	SET @thu = 'Thu ba'
	END

	IF (@songaytrongtuan = 2)
	BEGIN
	SET @thu = 'Thu tu'
	END

	IF (@songaytrongtuan = 3)
	BEGIN
	SET @thu = 'Thu nam'
	END

	IF (@songaytrongtuan = 4)
	BEGIN
	SET @thu = 'Thu sau'
	END

	IF (@songaytrongtuan = 5)
	BEGIN
	SET @thu = 'Thu bay'
	END

	IF (@songaytrongtuan = 6)
	BEGIN
	SET @thu = 'Chu nhat'
	END
END


CREATE FUNCTION B3(@MAHD INT)
RETURNS TABLE
AS
	RETURN 
		SELECT dbo.HDBAN.MAHD, NgayXuat, MaVT, DonGia,SLBan, dbo.getThu(NgayXuat) AS 'NGAYTHU'
		from dbo.HANGXUAT, dbo.HDBAN
		where dbo.HDBAN.MAHD = dbo.HANGXUAT.MAHD and
		dbo.HANGXUAT.MAHD = @MAHD
Go
select * from dbo.B3

-- CAU 4 --
CREATE PROCEDURE p4 
@thang int, @nam int 
AS
SELECT 
SUM(SLBAN * DONGIA)
FROM HANGXUAT HX
INNER JOIN HDBAN HD ON HX.MAHD = HD.MAHD
where MONTH(HD.NGAYXUAT) = @THANG AND YEAR(HD.NGAYXUAT) = @NAM;