% Initialization

obj = tcpip('192.168.18.49',5025);    
fopen(obj);
disp(query(obj,'*IDN?'));               %who are you?
