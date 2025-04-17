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
select GV.HOTEN, GV.NGSINH
from GIAOVIEN GV, BOMON BM, Khoa K
where GV.MABM = BM.MABM and BM.MAKHOA = K.MAKHOA and K.TENKHOA = N'Công nghệ thông tin'
and year(GV.NGSINH) 
>= all ( -- năm sinh của các gv khoa CNTT --
select year(GV1.NGSINH)
from GIAOVIEN GV1, BOMON BM1
where GV1.MABM = BM1.MABM and BM1.MAKHOA = K.MAKHOA -- K.MAKHOA là từ truy vấn cha --
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

--Q49--
select GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where (--số lượng của giáo viên bộ môn CNPM có lương < lương của GV
select count(*)
from GIAOVIEN GV1, BOMON BM1
where GV1.MABM = BM1.MABM and BM1.TENBM = N'Hệ thống thông tin' and GV1.LUONG < GV.LUONG -- GV.LUONG là từ truy vấn cha
) >= 1
