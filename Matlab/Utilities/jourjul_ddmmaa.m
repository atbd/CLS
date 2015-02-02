function [dd mm aa] = jourjul_ddmmaa (jourjulien)

strdate = jourjul2jourgreg (jourjulien);

dd = str2num(strdate(1:2));
mm = str2num(strdate(4:5));
aa = str2num(strdate(7:10));


