function [ obj, error ] = open_NAP(IP_NAP, ID_NAP)
%% DESCRIPTION
% Function opens NAP object for acces
% SYNTAX
%[ obj_NAP, str ] = open_NAP(IP_NAP, ID_NAP)
% INPUT
% IP_NAP - IP-string of receiver
% ID_NAP - ID-string of receiver
% OUTPUT
% obj_NAP - object
% error - status string

%ID_NAP=3VOGAHW998VM03VQGCI7UEJPS7;
error=0;
obj=tcpip(IP_NAP,8002,'InputBufferSize',10240,'ByteOrder','littleEndian');
fopen(obj);

fwrite(obj,[char(13) char (10)],'char'); % login
fwrite(obj,['javad' char(13) char (10)],'char'); % password
pause(0.1);char(fread(obj,[1,obj.BytesAvailable],'char')); % ochistka bufera

fprintf(obj,'print,/par/rcv/id'); %chitaem nomer
pause(0.1);
ID=char(fread(obj,[1,obj.BytesAvailable],'char'));

if isempty(strfind(ID, ID_NAP))
    fclose(obj);
    obj_NAP='';
    error='NAP ne tot';
end
    



end

