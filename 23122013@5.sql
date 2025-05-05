use QLGV
go

--Q35-- 
-- Mức lương cao nhất của các giảng viên
select max(gv.luong) LuongGVCaoNhat
from giaovien gv

--Q36--
-- Những giáo viên có lương lớn nhất
select gv.hoten, gv.luong
from giaovien gv
where gv.luong = 
( -- mức lương cao nhất của các giảng viên
select max(gv.luong) LuongGVCaoNhat
from giaovien gv
)

--Q37--
-- Lương cao nhất trong bộ môn HTTT
select max(gv.luong) LuongGVCaoNhatHTTT
from giaovien gv, bomon bm
where gv.mabm = bm.mabm and bm.mabm = 'HTTT'

--Q38--
-- Tên giáo viên lớn tuổi nhất của bộ môn hệ thống thông tin
select gv.hoten
from giaovien gv, bomon bm
where gv.mabm = bm.mabm and bm.tenbm = N'Hệ thống thông tin' 
and year(gv.ngsinh) = ( -- giáo viên lớn tuổi nhất của bm hệ thống thông tin
select min(year(gv1.ngsinh))
from giaovien gv1, bomon bm1
where gv1.mabm = bm1.mabm and bm1.tenbm = N'Hệ thống thông tin'
) 

--Q39--
-- Tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin
select GV.HOTEN, GV.NGSINH
from GIAOVIEN GV, BOMON BM, KHOA K
where GV.MABM = BM.MABM and BM.MAKHOA = K.MAKHOA and K.TENKHOA = N'Công nghệ thông tin'
and year(GV.NGSINH) 
>= all ( -- năm sinh của các gv khoa CNTT --
select year(GV1.NGSINH)
from GIAOVIEN GV1, BOMON BM1
where GV1.MABM = BM1.MABM and BM1.MAKHOA = K.MAKHOA -- K.MAKHOA là từ truy vấn cha --
) 

--Q40--
-- Tên giáo viên và tên khoa của giáo viên có lương cao nhất
select GV.HOTEN, K.TENKHOA
from GIAOVIEN GV, BOMON BM, KHOA K
where GV.MABM = BM.MABM and BM.MAKHOA = K.MAKHOA
and GV.LUONG = ( -- Lương cao nhất của giáo viên
select max(GV1.LUONG)
from GIAOVIEN GV1
)

--Q41--
-- Những giáo viên có lương lớn nhất trong bộ môn của họ
select GV.HOTEN TenGiaoVien, GV.LUONG Luong, GV.MABM MaBoMon
from GIAOVIEN GV
where gv.LUONG = (select max(GV1.LUONG) from GIAOVIEN GV1 where GV1.MABM = GV.MABM);

--Q42--
-- Tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia
select DT.TENDT
from DETAI DT
where DT.MADT not in (-- Mã đề tài giáo viên Nguyễn Hoài An tham gia
select distinct DT1.MADT
from DETAI DT1, GIAOVIEN GV, THAMGIADT TGDT
where GV.HOTEN = N'Nguyễn Hoài An' and GV.MAGV = TGDT.MAGV and TGDT.MADT = DT1.MADT
)

--Q43--
-- Tên những đề tài và chủ nhiệm đề tài mà giáo viên Nguyễn Hoài An chưa tham gia
select DT.TENDT TenDeTai, GVCN.HOTEN ChuNhiem
from DETAI DT, GIAOVIEN GVCN
where DT.MADT not in (-- Mã đề tài giáo viên Nguyễn Hoài An tham gia
select distinct DT1.MADT
from DETAI DT1, GIAOVIEN GV, THAMGIADT TGDT
where GV.HOTEN = N'Nguyễn Hoài An' and GV.MAGV = TGDT.MAGV and TGDT.MADT = DT1.MADT
) 
and DT.GVCNDT = GVCN.MAGV

--Q44--
-- Tên những giáo viên khoa CNTT (thay bằng Hóa học) mà chưa tham gia đề tài nào
select GV.HOTEN
from GIAOVIEN GV, BOMON BM, KHOA K
where BM.MABM = GV.MABM 
and BM.MAKHOA = K.MAKHOA and K.TENKHOA = N'Hóa học'
and GV.MAGV not in (-- tham gia đề tài > 0
select distinct TGDT.MAGV 
from THAMGIADT TGDT 
group by TGDT.MAGV
having count(TGDT.MAGV) > 0
)

--Q45--
-- Những giáo viên không tham gia bất kỳ đề tài nào
select GV.HOTEN
from GIAOVIEN GV
where GV.MAGV not in (-- tham gia đề tài > 0
select distinct TGDT.MAGV 
from THAMGIADT TGDT 
--group by TGDT.MAGV
--having count(TGDT.MAGV) > 0
)

--Q46--
-- Giáo viên có lương > lương Nguyễn Hoài An
select GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where GV.LUONG > (--lương Nguyễn Hoài An
select GVAn.LUONG
from GIAOVIEN GVAn
where GVAn.HOTEN = N'Nguyễn Hoài An'
)

--Q47--
select GV.HOTEN, BM.TENBM
from GIAOVIEN GV, BOMON BM
where BM.TRUONGBM = GV.MAGV 
and ( -- số lượng đề tài mà GV tham gia
select count (distinct TG.MADT)
from THAMGIADT TG
where TG.MAGV = GV.MAGV
) >= 1

--Q48--
-- Tìm giáo viên trùng tên, giới tính với giáo viên khác trong cùng bộ môn
select distinct GV1.MAGV, GV1.HOTEN, GV1.PHAI
from GIAOVIEN GV1, GIAOVIEN GV2
where GV1.MAGV != GV2.MAGV -- 2 gv khác nhau
and GV1.HOTEN = GV2.HOTEN and GV1.PHAI = GV2.PHAI
and GV1.MABM = GV2.MABM

--Q49--
select GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where (--số lượng của giáo viên bộ môn CNPM có lương < lương của GV
select count(*)
from GIAOVIEN GV1, BOMON BM1
where GV1.MABM = BM1.MABM and BM1.TENBM = N'Hệ thống thông tin' and GV1.LUONG < GV.LUONG -- GV.LUONG là từ truy vấn cha
) >= 1

--Q50--
-- Giáo viên có lương > (thay bằng >=) lương của tất cả giáo viên bộ môn HTTT
select GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where GV.LUONG >= (-- max lương GV HTTT
select max(GV1.LUONG)
from GIAOVIEN GV1, BOMON BM
where GV1.MABM = BM.MABM and BM.TENBM = N'Hệ thống thông tin'
)

--Q51--
-- Tên khoa có đông giáo viên nhất
select K.TENKHOA
from GIAOVIEN GV, BOMON BM, KHOA K
where GV.MABM = BM.MABM and BM.MAKHOA = K.MAKHOA
group by K.TENKHOA
having count(GV.MAGV) = (-- số lượng gv lớn nhất
select max(SoLuongGV)
from (select count(distinct GV1.MAGV) SoLuongGV -- đếm GV
from GIAOVIEN GV1, BOMON BM1, KHOA K1
where GV1.MABM = BM1.MABM and BM1.MAKHOA = K1.MAKHOA
group by K1.TENKHOA) BangSoLuong
)

--Q52--
-- Tên GVCN nhiều đề tài nhất
select GV.HOTEN
from GIAOVIEN GV
where GV.MAGV in (-- mã GV nhiều đề tài nhất
select DT.GVCNDT
from DETAI DT
group by DT.GVCNDT
having count(DT.GVCNDT) = (
select max(SoDeTai) -- Số đề tài nhiều nhất của 1 GVCN
from(
select count(DT.GVCNDT) SoDeTai -- Đếm số đề tài của các GVCN
from DETAI DT
group by DT.GVCNDT
) DemSoDeTai
)
)

--Q53--
-- Mã bộ môn có nhiều giáo viên nhất
select GV.MABM, count(GV.MABM) SoLuongGV
from GIAOVIEN GV
group by GV.MABM
having count(GV.MABM) = (
select max(DemGV)
from (select count(GV.MABM) DemGV
from GIAOVIEN GV
group by GV.MABM
) MaxGV
)

--Q54--
-- Tên GV + tên BM của giáo viên tham gia nhiều đề tài nhất
select GV.HOTEN, BM.TENBM
from GIAOVIEN GV, BOMON BM
where GV.MABM = BM.MABM
and GV.MAGV in (-- các mã GV tham gia nhiều đề tài nhất

select TGDT1.MAGV
from THAMGIADT TGDT1
group by TGDT1.MAGV
having count(TGDT1.MAGV) = (-- số lượng đề tài lớn nhất
select max(DemGV)
from (select count(TGDT.MAGV) DemGV
from THAMGIADT TGDT
group by TGDT.MAGV
) MaxGV
)

)

--Q55--
-- Tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT
select GV.HOTEN
from GIAOVIEN GV, BOMON BM
where GV.MABM = BM.MABM and BM.TENBM = N'Hệ thống thông tin'
and GV.MAGV in (-- các mã gv tham gia nhiều đề tài nhất bm httt

select TGDT1.MAGV
from THAMGIADT TGDT1, GIAOVIEN GV1, BOMON BM1
where TGDT1.MAGV = GV1.MAGV and GV1.MABM = BM1.MABM 
and BM1.TENBM = N'Hệ thống thông tin'
group by TGDT1.MAGV
having count(TGDT1.MAGV) = (-- số lượng đề tài lớn nhất bm HTTT
select max(DemGV)
from (select count(TGDT.MAGV) DemGV
from THAMGIADT TGDT, GIAOVIEN GVHTTT, BOMON BMHTTT
where TGDT.MAGV = GVHTTT.MAGV and GVHTTT.MABM = BMHTTT.MABM 
and BMHTTT.TENBM = N'Hệ thống thông tin'
group by TGDT.MAGV
) MaxGV
)

)

--Q56--
-- Tên giáo viên và tên bộ môn của gv có nhiều người thân nhất
select GV.HOTEN, BM.TENBM
from GIAOVIEN GV, BOMON BM
where GV.MABM = BM.MABM
and GV.MAGV in ( -- danh sách mã GV có nhiều người thân nhất
select NT.MAGV
from NGUOITHAN NT
group by NT.MAGV
having count (NT.MAGV) = (-- số người thân nhiều nhất của 1 GV
select max(MaxNT)
from (
select count(NT1.MAGV) MaxNT
from NGUOITHAN NT1
group by NT1.MAGV
) DemNT
)

)

--Q57--
-- Tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất

select GV.HOTEN
from GIAOVIEN GV
where GV.MAGV in (-- mã GVCN là trưởng bộ môn nhiều đề tài nhất
----
select DT.GVCNDT
from DETAI DT
group by DT.GVCNDT
having count(DT.GVCNDT) = (
---
select max(SoDeTai) -- Số đề tài nhiều nhất của 1 GVCN là trưởng bộ môn
from(
select count(DT.GVCNDT) SoDeTai -- Đếm số đề tài của các GVCN là trưởng bộ môn
from DETAI DT
where DT.GVCNDT in 
( -- Mã GV của các trưởng bộ môn
select distinct BM.TRUONGBM
from BOMON BM
)
group by DT.GVCNDT
) DemSoDeTai
---
)
----
)