use QLGV
go

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
