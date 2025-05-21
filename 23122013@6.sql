use QLGV
go

--Q58--
--Tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề
select GV.HOTEN
from GIAOVIEN GV
where not exists ( -- Kiểm tra xem có tồn tại chủ đề nào (CD_ALL)
    select CD_ALL.MACD
    from CHUDE CD_ALL
    where not exists ( -- mà giáo viên này (GV) KHÔNG tham gia không
        select *
        from THAMGIADT TG, DETAI DT
        where TG.MADT = DT.MADT and TG.MAGV = GV.MAGV and DT.MACD = CD_ALL.MACD
    )
);

--Q59--
-- Tên đề tài nào mà được tất cả các giáo viên của bộ môn "Hệ thống thông tin" tham gia
select D.TENDT
from DETAI D
where not exists ( -- GV_HTTT
    select GV_HTTT.MAGV
    from GIAOVIEN GV_HTTT, BOMON BM_HTTT
    where GV_HTTT.MABM = BM_HTTT.MABM and BM_HTTT.TENBM = N'Hệ thống thông tin'
    and not exists ( -- GV_HTTT tham gia vào đề tài D
        select *
        from THAMGIADT TG_D
        where TG_D.MADT = D.MADT and TG_D.MAGV = GV_HTTT.MAGV
    )
);

--Q60--
-- Tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia
-- -> đề tài không tồn tại giảng viên thuộc HTTT không tham gia vào đề tài
select D.TENDT
from DETAI D
where not exists ( -- GV_HTTT
    select GV_HTTT.MAGV
    from GIAOVIEN GV_HTTT, BOMON BM_HTTT
    where GV_HTTT.MABM = BM_HTTT.MABM and BM_HTTT.TENBM = N'Hệ thống thông tin'
    and not exists ( -- GV_HTTT tham gia vào đề tài D
        select *
        from THAMGIADT TG_D
        where TG_D.MADT = D.MADT and TG_D.MAGV = GV_HTTT.MAGV
    )
);

--Q61--
-- Giáo viên đã tham gia tất cả các đề tài có mã chủ đề là QLGD.
-- -> không tồn tại đề tài thuộc chủ đề qlgd mà giáo viên này không tham gia
select GV.HOTEN, GV.MAGV
from GIAOVIEN GV
where not exists ( -- DT_QLGD
    select DT_QLGD.MADT
    from DETAI DT_QLGD
    where DT_QLGD.MACD = 'QLGD'
    and not exists ( -- GV tham gia vào DT_QLGD
        select *
        from THAMGIADT TG
        where TG.MAGV = GV.MAGV
          and TG.MADT = DT_QLGD.MADT
    )
);

--Q62--
-- tên giáo viên tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia.
-- -> không tồn tại đề tài mà giáo viên TTH tham gia mà giáo viên đó không tham gia

declare @MagvTTH nvarchar(3);
select @MagvTTH = MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương';

select GV.HOTEN, GV.MAGV
from GIAOVIEN GV
where GV.MAGV <> @MagvTTH
  and not exists (  -- đề tài mà giáo viên TTH tham gia
    select DT_TTH.MADT
    from (
        -- MADT mà TTH tham gia
        select MADT from THAMGIADT where MAGV = @MagvTTH
        union -- UNION
        select MADT from DETAI where GVCNDT = @MagvTTH
    ) as DT_TTH
    where not exists ( -- GV đó tham gia
        select *
        from THAMGIADT TG_GV 
        where TG_GV.MAGV = GV.MAGV
          and TG_GV.MADT = DT_TTH.MADT 
    )
);

--Q63--
--Tên đề tài mà được tất cả các giáo viên của môn Mạng máy tính tham gia.
-- -> tên đề tài mà không tồn tại giáo viên của môn Mạng máy tính không tham gia

declare @MabmX nvarchar(3);
select @MabmX = MABM from BOMON where TENBM = N'Mạng máy tính';

select D.TENDT, D.MADT
from DETAI D
where not exists ( -- giáo viên BM X
    select GV_HHC.MAGV
    from GIAOVIEN GV_HHC
    where GV_HHC.MABM = @MabmX
    and not exists ( -- giáo viên BM X tham gia vào đề tài D
        select *
        from THAMGIADT TG
        where TG.MADT = D.MADT
          and TG.MAGV = GV_HHC.MAGV
    )
)
and exists (select * from GIAOVIEN GV_CHECK where GV_CHECK.MABM = @MabmX)
;

--Q64--
-- tên giáo viên tham gia tất cả các công việc của đề tài 006
-- -> tên giáo viên không một công việc nào của đề tài 006 mà không tham gia
select GV.HOTEN, GV.MAGV
from GIAOVIEN GV
where not exists ( -- công việc đề tài '006'
    select CV_006.STT
    from CONGVIEC CV_006
    where CV_006.MADT = '006'
    and not exists ( -- gv này tham gia vào công việc đề tài 006
        select *
        from THAMGIADT TG
        where TG.MAGV = GV.MAGV
          and TG.MADT = '006'
          and TG.STT = CV_006.STT
    )
)
and exists (select * from CONGVIEC where MADT = '006');
;