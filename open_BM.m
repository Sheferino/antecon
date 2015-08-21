function [obj, st]= open_BM(ip_adres,ID)

st = '';
port_number = 5025;
flag = 1;

try
    obj = tcpip(ip_adres,port_number);
    fopen(obj);
catch
    obj = '';
    flag = 0;
    st = 'BM tcp/ip opening error';
end;

if flag st = query(obj,'GET_IDN'); end;

if findstr(st,ID) == 0 
    obj = '';
    st = 'BM ID is not correct ' + ID; 
end;




