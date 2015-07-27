%% Target

%% Constants

%=========obrazets
sn_VSA='12345';
IP_VSA='192.168.0.1';
%=========konets



%% Equipment initialization

%=========obrazets
[obj_VSA,~]=open_VSA(IP_VSA,sn_VSA);
%=========konets



%% Ephemeris calculation
%% Angles calculation