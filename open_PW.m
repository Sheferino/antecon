function [obj, st]= open_PW(ip_adres,port_number,ID)

flag = 1;

try
    obj = tcpip(ip_adres,port_number);
    fopen(obj);
catch
    flag = 0;
end;

if flag st = query(obj,'*IDN?'); end;

if (isempty(findstr(st,ID)))' 
    obj = ''; 
end;




