-- Ca 2 - 23122013 - Đinh Đức Tài - Mã đề 002 --

USE QLHocVienCK;
GO

-- Q1 --

-- DROP FUNCTION fn_SoMonPhanCong_Sau2023

CREATE FUNCTION fn_SoMonPhanCong_Sau2023 (@MaGV_input NCHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @SoMon INT;
    DECLARE @TonTaiGV INT;

    -- Kiem tra GV ton tai
    SELECT @TonTaiGV = COUNT(*)
    FROM GIAOVIEN
    WHERE MaGV = @MaGV_input;

    IF @TonTaiGV = 0
    BEGIN
        RETURN -1;
    END

    -- Tinh so mon duoc phan cong
    SELECT @SoMon = COUNT(DISTINCT pc.MaMH)
    FROM PHANCONG pc, LOPHOC lh
    WHERE pc.MaLop = lh.MaLop
    and pc.MaGV = @MaGV_input AND lh.NamBatDau > 2023;

    RETURN @SoMon;
END
GO

SELECT dbo.fn_SoMonPhanCong_Sau2023(N'GV00006') AS SoMonDuocPhanCong
GO

-- Q2 --

-- DROP PROCEDURE sp_GiaoVienDayNhieuMon_Sau2023

CREATE PROCEDURE sp_GiaoVienDayNhieuMon_Sau2023
AS
BEGIN
    
    SELECT g.MaGV, g.TenGV
    FROM GIAOVIEN g
    WHERE dbo.fn_SoMonPhanCong_Sau2023(g.MaGV) >= 5;
END
GO

EXEC sp_GiaoVienDayNhieuMon_Sau2023
GO


-- Q3 --

-- DROP PROCEDURE sp_GVDayDuKhaNang
-- GO

CREATE PROCEDURE sp_GVDayDuKhaNang
AS
BEGIN
    SELECT g.MaGV, g.TenGV, g.NgaySinh
    FROM GIAOVIEN g
    WHERE
        -- Co it nhat 1 mon GV do day duoc
        EXISTS (SELECT 1 FROM GIAOVIEN_DAY_MONHOC GVDAYMON WHERE GVDAYMON.MaGV = g.MaGV)
        AND
        -- So mon co the day = so mon duoc phan cong day
        (
            SELECT COUNT(DISTINCT MaMH)
            FROM GIAOVIEN_DAY_MONHOC GDM
            WHERE GDM.MaGV = g.MaGV
        )
        =
        (
            SELECT COUNT(DISTINCT MaMH)
            FROM PHANCONG pc
            WHERE pc.MaGV = g.MaGV
        );
END
GO

EXEC sp_GVDayDuKhaNang
GO



-- Q4 --

-- DROP PROCEDURE sp_GVDayNhieuLopNhat
-- GO

CREATE PROCEDURE sp_GVDayNhieuLopNhat
AS
BEGIN
    -- Dem so lop hoc cua moi GV
    WITH SoLopDayCuaGV AS (
        SELECT
            MaGV,
            COUNT(DISTINCT MaLop) AS TongSoLopDay
        FROM PHANCONG
        GROUP BY MaGV
    )
    -- Lay so lop day GV = so lop day MAX
    SELECT
        g.TenGV,
        g.NgaySinh
    FROM GIAOVIEN g, SoLopDayCuaGV sld 
    WHERE g.MaGV = sld.MaGV
    and sld.TongSoLopDay = (
        SELECT MAX(TongSoLopDay)
        FROM SoLopDayCuaGV
    );
END
GO

EXEC sp_GVDayNhieuLopNhat
GO