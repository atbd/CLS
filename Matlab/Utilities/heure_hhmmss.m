function [hh mm ss] = heure_hhmmss (temps)

strtemps = sec2heure(num2str(temps));
hh = str2num(strtemps(1:2));
mm = str2num(strtemps(4:5));
ss = str2num(strtemps(7:8));




