%% Target
SV='R02';

%% Constants
%sn_NAP='3VOGAHW998VM03VQGCI7UEJPS7'; % SIGMA 083 iz 621
%IP_NAP='192.168.18.73';
sn_NAP='3VRX0CW0GCJRC3VLU21OGAKNSB'; %Sigma na signale
IP_NAP='192.168.5.63'; 

% x_ant=1234;
% y_ant=43214;
% z_ant=54325;

%% Equipment initialization

 [ obj_NAP, error ] = open_NAP(IP_NAP, sn_NAP); %otkryvaem svyaz' s NAP
 if isempty(obj_NAP) %standartnaya obrabotka
     disp(error); %vydacha oshibki
     close_NAP(obj_NAP); % zakryvaem ob'ekty
     return; %ostanovka
 else
     disp('AnteCon: ustanovlena svyaz s NAP');
 end
 
%% Ephemeris calculation
[x,y,z,error]=get_NAP(obj_NAP,SV); % schitaem koordinaty NKA
if isempty(x)
    disp(error);
    close_NAP(obj_NAP);
    return;
end

%% Angles calculation
%[az, el]=calc_angles(x,y,z,x_ant,y_ant,z_ant);

%% Antenna steering

%% Calibration

%% Measurements

%% All deinitialization
close_NAP(obj_NAP);
disp('AnteCon: razorvana svyaz s NAP');

%% End of script