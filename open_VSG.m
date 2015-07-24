function [obj, st]= open_VSG(ip_adres,port_number,ID)

flag = 1;

try
    obj = tcpip(ip_adres,port_number);
    fopen(obj);
catch
    flag = 0;
end;

if flag st = query(obj,'*IDN?'); end;

if (isempty(findstr(st,ID)))' 
    obj = 0; 
end;




