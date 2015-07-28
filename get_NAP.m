function [ x_sat,y_sat,z_sat,error ] = get_NAP(obj,TargetSV)
%% DESCRIPTION
% Function gets coordinates of target SV
% SYNTAX
%[ x,y,z ] = get_NAP(obj)
% INPUT
% obj - receiver object
% TargetSV -SV string in RINEX format (for example 'G12', 'R05')
% OUTPUT
% x,y,z - [1,3600] arrays of SV coordinates

%% Ustanovka flagov i opredelenie neobhodimogo SV
flag_EphExist=0;
error='';
SV_num=str2double(TargetSV(2:3));
switch TargetSV(1)
    case 'G'
        %% Zapros efemerid GPS
        %% Raschet koordinat GPS
        if ~flag_EphExist %proverka nalichiya efemerid
            error='Net efemerid';
            return
        end
        
    case 'R'
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
                    eval([GLOEphStruct{1,k} '=fread(obj,1,''' GLOEphStruct{2,k} ''');']);
                    msg_length=msg_length-GLOEphStruct{3,k};
                end
                if SV==SV_num
                    flag_EphExist=1;
                    break;
                end;
                fread(obj,msg_length,'uint8');
            end
            pause(0.1);
        end
        char(fread(obj,[1,obj.BytesAvailable],'char'));
        fprintf(obj,'dm,,/msg/jps/NE:{1,0,1}');
        %% Raschet koordinat GLO
        if ~flag_EphExist %proverka nalichiya efemerid
            error='Net efemerid';
            return
        end
        x_sat=x+vx+ax;
        y_sat=y+vy+ay;
        z_sat=z+vz+az;
        
end

end

