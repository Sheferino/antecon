%proba NAP
obj=tcpip('192.168.18.73',8002,'InputBufferSize',10240,'ByteOrder','littleEndian');

%avtomaticheskaya vydacha poluchennyh dannyh v konsol;
%set(obj,'BytesAvailableFcn','disp(char(fread(obj,[1,obj.BytesAvailable],''char'')));','BytesAvailableFcnCount',1,'BytesAvailableFcnMode','byte');

fopen(obj);
fwrite(obj,[char(13) char (10)],'char'); %login
fwrite(obj,['javad' char(13) char (10)],'char'); %parol
pause(0.1);char(fread(obj,[1,obj.BytesAvailable],'char')); %ochistka bufera

fprintf(obj,'print,/par/rcv/id'); %chitaem nomer
pause(0.1);
ID=char(fread(obj,[1,obj.BytesAvailable],'char'));

%Ustanovka flagov i neobhodimogo SV
flag_EphExist=0;
TargetSV=4;

%% Zapros efemerid GLO
fread(obj,[1,obj.BytesAvailable],'char'); %ochistka bufera
fprintf(obj,'em,,/msg/jps/NE:{0.1,0,1}');
pause(0.1);
while obj.BytesAvailable>0
    msg_ID=char(fread(obj,[1 2],'char')); %message ID
    if strcmp(msg_ID,'NE')
        msg_length=hex2dec(char(fread(obj,3,'uint8'))); %message length
        msg_length=msg_length(1)*256+msg_length(2)*16+msg_length(3)+1;
        GLOEphStruct={'SV' 'frqNUM' 'dne' 'tk' 'tb' 'health' 'age' 'flags' 'x' 'y' 'z' 'vx' 'vy' 'vz' 'ax' 'ay' 'az';
            'uint8' 'int8' 'int16' 'int32' 'int32' 'uint8' 'uint8' 'uint8' 'float64' 'float64' 'float64' 'float32' 'float32' 'float32' 'float32' 'float32' 'float32';
            1 1 2 4 4 1 1 1 8 8 8 4 4 4 4 4 4};
        for k=1:length(GLOEphStruct(1,:))
            assignin('base',GLOEphStruct{1,k},fread(obj,1,GLOEphStruct{2,k}));
            msg_length=msg_length-GLOEphStruct{3,k};
        end
        if SV==TargetSV 
            flag_EphExist=1;
            break;
        end;
        fread(obj,msg_length,'uint8');
    end
    pause(0.1);
end
char(fread(obj,[1,obj.BytesAvailable],'char'));
fprintf(obj,'dm,,/msg/jps/NE:{1,0,1}');
fclose(obj);
if flag_EphExist
    disp('Ephemeris 1');
else
    disp('Ephemeris 0');
end

