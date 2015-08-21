function [obj, st]= open_VSA(ip_adres,ID)

st = '';
port_number = 5025;
flag = 1;

try
    obj = tcpip(ip_adres,port_number,'InputBufferSize',1E4);
    % obj = tcpip(ip_adres,port_number,'InputBufferSize',1E5,'ByteOrder','littleEndian','Timeout', 10);
    fopen(obj);
catch
    obj = '';
    flag = 0;
    st = 'VSA tcp/ip opening error';
end;

if flag 
    st = query(obj,'*IDN?');
    %fprintf(obj,':CAL:AUTO OFF');   %mover from calib_path
    %pause(0.1);
    fprintf(obj,':CAL');
end;

if findstr(st,ID) == 0
    obj = '';
    st = 'VSA ID is not correct ' + ID;
end;




