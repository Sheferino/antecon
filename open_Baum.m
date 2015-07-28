function [obj, st]= open_Baum(ip_adres,port_number,ID)

st = '';
%port_number = 5025;
flag = 1;

try
    obj = tcpip(ip_adres,port_number);
    fopen(obj);
catch
    flag = 0;
end;

if flag st = query(obj,'GET_IDN'); end;

if findstr(st,ID) == 0 
    obj = '';
    st = ''; 
end;




