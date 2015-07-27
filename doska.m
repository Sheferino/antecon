%proba NAP
obj=tcpip('192.168.18.73',8002);
fopen(obj);
char(fread(obj,[1,obj.BytesAvailable],'char'))
fwrite(obj,[char(13) char (10)],'char'); %login
char(fread(obj,[1,obj.BytesAvailable],'char'))
fwrite(obj,['javad' char(13) char (10)],'char'); %parol
char(fread(obj,[1,obj.BytesAvailable],'char'))
fwrite(obj,['print,/par/rcv/id' char(13) char (10)],'char'); %parol
char(fread(obj,[1,obj.BytesAvailable],'char'))