function [obj, st]= open_VSG(ip_adres,ID)

st = ''; 
port_number = 5025;
flag = 1;

try
    obj = tcpip(ip_adres,port_number);
    fopen(obj);
catch
    flag = 0;
end;

if flag 
    st = query(obj,'*IDN?'); 
end;

if findstr(st,ID) == 0 
    obj = '';
    st = '';
end;




