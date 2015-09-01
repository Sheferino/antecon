function [obj, st]= open_PWUSB(usb_adres,ID)

st = '';
%port_number = 5025;
flag = 1;

try
    obj = visa('agilent',usb_adres);
    fopen(obj);
catch
    obj = '';
    flag = 0;
    st = 'PW tcp/ip opening error';
end;

if flag st = query(obj,'*IDN?'); end;

if findstr(st,ID) == 0
    obj = '';
    st = 'PW ID is not correct: ' + ID;
end;




