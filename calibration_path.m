function [fi1,fi246,fi248,fi39,fi311,fin,fi257,fi2510,fi12,LL,LKu,delta_A19_VSA,delta_A5_VSA] = ...
calibration_path(Ant,PW1,PW2,PW3,PW4,Baum,VSA,VSG,path,f_sig,P0,PA6,PA7)
%% Ant - handle to ant system,
% PW1, PW2, PW3, PW4 - handles to powermeters, PW1 - A19, PW2 - A15, PW3 - A5, PW4 - A21
% Baum - handle to Bauman reciever
% VSA - handle to N9030A
% VSG - handle to N5172B
% path - only 'low' or 'high' - way parameter
% f_sig - calib signal frequency
% P0 - calib signal power
% PA6 - NG1 power
% PA7 - NG2 power


    function key = open_key(Ant,Key_adr)    %just check connection with key
        %B = [hex2dec('68686868') hex2dec('5') hex2dec('12') hex2dec('0') hex2dec(Key)];
        B = ['68686868' '00000005' '00000012' '00000000' Key_adr];
        
        %fprintf(Ant,'%08X %08X %08X %08X %08X\n',B);
        %key = 1;
        
        %fprintf(Ant,'%08X%08X%08X%08X%08X\n',B);
        %key = 1;
        
        st = query(Ant,B);
        if findstr(st,'1012') key = 1;
        else key = 0;
        end;
    end

    function NG = open_NG(Ant,NG_adr)       %just check connection with NG
        B = ['68686868' '00000005' '00000014' '00000000' NG_adr];
        st = query(Ant,B);
        if findstr(st,'1014') NG = 1;
        else NG = 0;
        end
    end
    
    function k = turn_key(Ant,Key_adr,komand)   %turn key to position 'komand'
        st = '';
        B = ['68686868' '00000005' '00000012' '00000000' Key_adr];
        st = query(Ant,B);
        disp(st);
        if findstr(st,komand) ~= 0
            k = 1;
        else
            B = ['68686868' '00000006' '00000011' '00000000' Key_adr komand];
            st = query(Ant,B);
            if findstr(st,komand) k = 1;
            else k = 0;
            end;
        end;
    end
    
    function NG = turn_NG(Ant,NG_adr,komand)    %turn NG to position 'komand'
        st = '';
        B = ['68686868' '00000005' '00000014' '00000000' NG_adr];
        st = query(Ant,B);
        disp(st);
        if findstr(st,komand) ~= 0
            NG = 1;
        else
            B = ['68686868' '00000006' '00000013' '00000000' NG_adr komand];
            st = query(Ant,B);
            if findstr(st,komand) NG = 1;
            else NG = 0;
            end;
        end;
    end

    function k = calib_PW(PW)               %PW self-calibration
                    
       st = query(PW,':CAL?');
       flag = str2double(st);
       if flag == 1
           k = 0;
           fprintf(PW,':CAL:ZERO:NORM:AUTO ONCE');
           while str2double(query(PW,'*OPC?')) ~= 1
           end;
           fprintf(PW,':CAL');
           while str2double(query(PW,'*OPC?')) ~= 1
           end;
           st = query(PW,':CAL?');
           if str2double(st) == 0 
               k = 1;
           end;
       else
           st = query(PW,'*IDN?');
           disp(st);
           k = 0;
       end;
       
       if k == 1
           fprintf(PW,'CALC1:FEED1 "POW:AVER"');
           %fprintf(PW,'');
           fprintf(PW,'FORM REAL');
       else
           disp('Calibration is failed for:');
           disp(st);
           disp(PW);
       end;
          
    end %end calib_PW

    function P = get_PW(PW)                 %get PW data (power, 1 val)
        st = query(PW,'MEAS1?');
        P = str2double(st);
    end

    function P = ask_VSA(VSA)
        st = query(VSA,':CALC:SPEC:MARK1:FUNC:RES?');   %get VSA data (power, 1 val)
        P = str2double(st);
    end


    if ~(strcmp(path,'low')) && ~(strcmp(path,'high'))
        error('Wrong value for path name: only "low" or "high" are possible');
    end;

    Key3_adr = '00000011';  %W3
    Key9_adr = '00000012';  %W9
    Key25_adr = '00000013';  %W25
    Key26_adr = '00000014';  %W26
    Key28_adr = '00000015';  %W28
    Key31_adr = '00000016';  %W31
    Key32_adr = '00000017';  %W32
    Key2_adr = '00000018';  %W2
    Key8_adr = '00000019';  %W5
    Key23_adr = '0000001A'; %W23
    
    NG1_adr = '00000021'; %A6
    NG2_adr = '00000022'; %A7
    
    %keys and NG check1
    k1 = open_key(Ant,Key3_adr);
    k2 = open_key(Ant,Key9_adr);
    k3 = open_key(Ant,Key25_adr);
    k4 = open_key(Ant,Key26_adr);
    k5 = open_key(Ant,Key28_adr);
    k6 = open_key(Ant,Key31_adr);
    k7 = open_key(Ant,Key32_adr);
    k8 = open_key(Ant,Key2_adr);
    k9 = open_key(Ant,Key8_adr);
    k10 = open_key(Ant,Key23_adr);
    k11 = open_NG(Ant,NG1_adr);
    k12 = open_NG(Ant,NG2_adr);
        
    k_sum_keys = k1*k2*k3*k4*k5*k6*k7*k8*k9*k10*k11*k12;
    
    %PW self-calibration
    k1 = calib_PW(PW1);
    k2 = calib_PW(PW2);
    k3 = calib_PW(PW3);
    k4 = calib_PW(PW4);
    
    k_sum_PW = k1*k2*k3*k4;
         
    k_sum_keys = 1; %switch it off in real function
    k_sum_PW = 1;   %switch it off in real function
    
    if (k_sum_keys == 1) && (k_sum_PW == 1) 
        
        %calibration procedure
               
        %for analyser -------------------------------
        fprintf(VSA,':SYST:PRES');  %switch off in real operating %rly?
        pause(0.1);                 %switch off in real operating
        
        fprintf(VSA,':INST:SEL BASIC'); %turn to basic IQ mode
        pause(0.1);
        fprintf(VSA,':CONF:SPEC');
        pause(0.1);
        
        B = [':FREQ:CENT ' f_sig ' MHz'];    %central freq setting
        fprintf(VSA,B);
        pause(0.1);
        
        fprintf(VSA,':SPEC:FREQ:SPAN 40 MHz');  %bands
        pause(0.1);
        fprintf(VSA,':SPECtrum:DIF:BANDwidth 40 MHz');
        pause(0.1);
        fprintf(VSA,':SPEC:BAND:RES 100 kHz');
        pause(0.1);
        
        fprintf(VSA,'CALC:SPEC:MARK1:TRAC ASP');
        pause(0.1);
        B = [':CALC:SPEC:MARK1:X ' f_sig ' MHz'];
        fprintf(VSA,B);  %marker to center freq
        pause(0.1);
        fprintf(VSA,':CALC:SPEC:MARK1:FUNC BPOW');  %marker on in band power mode
        pause(0.1);
        fprintf(VSA,':CALC:SPEC:MARK1:FUNC:BAND:SPAN 20 MHz'); %measuring in 20 MHz
        pause(0.1);
        %fprintf(VSA,':CAL:AUTO OFF');   %moved to open
        %pause(0.1);
        %fprintf(VSA,':CAL');    %needs very long time to CAL VSA
                
        %for generator -------------------------------
        
        B = [':FREQ ' f_sig 'MHz'];
        fprintf(VSG,B);
        pause(0.1);
        fprintf(VSG,':UNIT:POW dBm');
        pause(0.1);
        fprintf(VSG,':POW:LEV -20'); %output power = 0 dBm
        pause(0.1);
        fprintf(VSG,':OUTP:MOD OFF');   %without modulation
        pause(0.1);
        fprintf(VSG,':OUTP ON');
        pause(0.1);
        
        % -------------------------------
         %part 1
        disp('calib part 1');
              
        k1 = turn_key(Ant,Key32_adr,'00000001'); %key W32 to BC/AD
        k2 = turn_key(Ant,Key25_adr,'00000000'); %key W25 to AB/CD
        k3 = turn_key(Ant,Key9_adr,'00000000'); %key W9 to AB/CD
        k4 = turn_key(Ant,Key28_adr,'00000001'); %key W28 to DC/AD
        k5 = turn_key(Ant,Key26_adr,'00000000'); %key W26 to AB/CD
      
        if k1 * k2 * k3 * k4 * k5 ~= 0 
            P_A19_1 = get_PW(PW1);
            fi1 = P0-P_A19_1;
            kalib1 = 1;            
        else
            P_A19_1 = 0;
            fi1 = 0;
            kalib1 = 0;
        end
        
        %part 2
        
        disp('calib part 2');
        
        if strcmp(path,'low')
        
            k1 = turn_key(Ant,Key32_adr,'00000000'); %key W32 to AB/CD
            k2 = turn_key(Ant,Key25_adr,'00000000'); %key W25 to AB/CD
            k3 = turn_key(Ant,Key9_adr,'00000000'); %key W9 to AB/CD
            k4 = turn_key(Ant,Key28_adr,'00000000'); %key W28 to AB/CD
        
            if k1 * k2 * k3 * k4 ~= 0 
                P_A15_2 = get_PW(PW2);
                kalib2 = 1;            
            else
                P_A15_2 = 0;
                kalib2 = 0;
            end
            
        end;    %end if 'low' 2 part
        
        if strcmp(path,'high')
            
            k5 = turn_key(Ant,Key25_adr,'00000001'); %key W25 to AD/BC
            k6 = turn_key(Ant,Key8_adr,'00000001'); %key W8 to In1Out2
            k7 = turn_key(Ant,Key23_adr,'00000001'); %key W23 to In1Out2
        
            if k5 * k6 * k7 ~= 0 
                P_A5_2 = get_PW(PW3);
                kalib2 = 1;            
            else
                P_A5_2 = 0;
                kalib2 = 0;
            end
            
        end;    %end if 'high' 2 part
                        
        %part 3
        
        disp('calib part 3');
        
        if strcmp(path,'low')
            
            k1 = turn_key(Ant,Key32_adr,'00000000'); %key W32 to AB/CD
            k2 = turn_key(Ant,Key25_adr,'00000000'); %key W25 to AB/CD
            k3 = turn_key(Ant,Key28_adr,'00000001'); %key W28 to BC/AD
            k4 = turn_key(Ant,Key9_adr,'00000001'); %key W9 to BC/AD
            k5 = turn_key(Ant,Key3_adr,'00000001'); %key W3 to BC/AD
            k6 = turn_key(Ant,Key26_adr,'00000000'); %key W26 to AB/CD
        
            if k1 * k2 * k3 * k4 * k5 * k6 ~= 0 
                P_A15_3 = get_PW(PW2);
                kalib3 = 1;            
            else
                P_A15_3 = 0;
                kalib3 = 0;
            end
            
        end; % end if 'low' 3 part
        
        if strcmp(path,'high')
            
            k7 = turn_key(Ant,Key25_adr,'00000001'); %key W25 to BC/AD
            k8 = turn_key(Ant,Key23_adr,'00000000'); %key W23 to In1Out1
            k9 = turn_key(Ant,Key8_adr,'00000000'); %key W8 to In1Out1
            k10 = turn_key(Ant,Key2_adr,'00000001'); %key W2 to In1Out2
        
            if k7 * k8 * k9 * k10 ~= 0 
                
                P_A5_3 = get_PW(PW3);
                
                B = [':FREQ:CENT ' '14033' ' MHz'];    %VSA to 14.3 GHz
                fprintf(VSA,B);                         %!! need to cpecif
                pause(0.1);
                
                B = [':CALC:SPEC:MARK1:X ' '14033' ' MHz'];
                fprintf(VSA,B);  %marker to center freq
                                
                pause(3);
                
                P_VSA_3 = ask_VSA(VSA);
                pause(0.1);
                
                B = [':FREQ:CENT ' f_sig ' MHz'];    %VSA to f_dis
                fprintf(VSA,B);
                pause(0.1);
                
                B = [':CALC:SPEC:MARK1:X ' f_sig ' MHz'];
                fprintf(VSA,B);  %marker to center freq
                pause(0.1);
                
                kalib3 = 1;            
            else
                P_A5_3 = 0;
                P_VSA_3 = 0;
                kalib3 = 0;
            end
        
        end; %end if 'high' 3 part
        
        %part 3v
        
        disp('calib part 3v');
        
        if strcmp(path,'low')
            
            k1 = turn_key(Ant,Key32_adr,'00000000'); %key W32 to AB/CD
            k2 = turn_key(Ant,Key25_adr,'00000000'); %key W25 to AB/CD
            k3 = turn_key(Ant,Key9_adr,'00000000'); %key W9 to AB/CD
            k4 = turn_key(Ant,Key28_adr,'00000001'); %key W28 to BC/AD
            k5 = turn_key(Ant,Key26_adr,'00000001'); %key W26 to BC/AD
        
            if k1 * k2 * k3 * k4 * k5 ~= 0 
                P_A19_3v = get_PW(PW1);
                P_A15_3v = get_PW(PW2);
                pause(3);
                P_VSA_3v = ask_VSA(VSA);
                kalib3v = 1;            
            else
                P_A19_3v = 0;
                P_A15_3v = 0;
                P_VSA_3v = 0;
                kalib3v = 0;
            end
            
        end;    %end if 'low' 3v part
        
        if strcmp(path,'high') 
            
            k7 = turn_key(Ant,Key25_adr,'00000001'); %key W25 to BC/AD
            k8 = turn_key(Ant,Key23_adr,'00000001'); %key W23 to In1Out2
            k9 = turn_key(Ant,Key8_adr,'00000001'); %key W8 to In1Out2
               
            if k7 * k8 * k9 ~= 0 
                P_A5_3v = get_PW(PW3);
                kalib3v_1 = 1;            
            else
                P_A5_3v = 0;
                kalib3v_1 = 0;
            end
        
            k10 = turn_key(Ant,Key23_adr,'00000000'); %key W23 to In1Out1
            k11 = turn_key(Ant,Key31_adr,'00000000'); %key W31 to AB/CD
        
            if k10 * k11 ~= 0 
                P_A21_3v = get_PW(PW4);
                kalib3v_2 = 1;            
            else
                P_A21_3v = 0;
                kalib3v_2 = 0;
            end
        
            kalib3v = kalib3v_1 * kalib3v_2;
        end; %end if 'high' 3v path    
        
        %part 4
        
        disp('calib part 4');
        
        if strcmp(path,'low')
            
            k1 = turn_key(Ant,Key32_adr,'00000000'); %key W32 to AB/CD
            k2 = turn_key(Ant,Key25_adr,'00000000'); %key W25 to AB/CD
            k3 = turn_key(Ant,Key28_adr,'00000001'); %key W28 to BC/AD
            k4 = turn_key(Ant,Key26_adr,'00000000'); %key W26 to AB/CD
            k5 = turn_key(Ant,Key9_adr,'00000001'); %key W9 to BC/AD
            k6 = turn_key(Ant,Key3_adr,'00000001'); %key W3 to BC/AD
        
            if k1 * k2 * k3 * k4 * k5 * k6 ~= 0 
                
                pause(1);
                
                P_A19_4 = get_PW(PW1);
                P_A15_4 = get_PW(PW2);
                
                fprintf(VSG,':OUTP OFF');
                
                fprintf(Baum,'setgenerator ON');
                pause(1);
                
                fprintf(Baum,'A2:3->2'); %A2 - 3->2
                fprintf(Baum,'A3:3->2'); %A3 - 3->2
                pause(4);
                fprintf(Baum,'A2:3->C'); %A2 - 3->C
                fprintf(Baum,'A3:3->C'); %A3 - 3->C
                
                fprintf(Baum, 'setgenerator OFF');
                
                kalib4 = 1;            
            else
                P_A19_4 = 0;
                P_A15_4 = 0;
                kalib4 = 0;
            end
            
        end; %end if 'low' 4 part
        
        if strcmp(path,'high')
            
            k7 = turn_key(Ant,Key25_adr,'00000001'); %key W25 to BC/AD
            k8 = turn_key(Ant,Key23_adr,'00000001'); %key W23 to In1Out2
            k9 = turn_key(Ant,Key8_adr,'00000000'); %key W8 to In1Out1
            k10 = turn_key(Ant,Key2_adr,'00000001'); %key W2 to In1Out2
            k11 = turn_key(Ant,Key31_adr,'00000000'); %key W31 to AB/CD
        
            if k7 * k8 * k9 * k10 * k11 ~= 0 
                P_A21_4 = get_PW(PW4);
                kalib4_1 = 1;            
            else
                P_A21_4 = 0;
                kalib4_1 = 0;
            end
            
            k12 = turn_key(Ant,Key23_adr,'00000000'); %key W23 to In1Out1
        
            if k12 ~= 0 
                P_A5_4 = get_PW(PW3);
                kalib4_2 = 1;            
            else
                P_A5_4 = 0;
                kalib4_2 = 0;
            end
            
            fprintf(VSG,':OUTP OFF');
            
            k10 = turn_key(Ant,Key23_adr,'00000001'); %key W23 to In1Out2
            k11 = turn_key(Ant,Key31_adr,'00000001'); %key W31 to AD/BC
            
                       
            if k10 * k11 ~=0
                
                fprintf(Baum,'setgenerator ON');
                pause(1);
                
                fprintf(Baum,'A3:3->2'); %A3 3->2
                pause(4);
                
                fprintf(Baum, 'setgenerator OFF');
                
                kalib4_3 = 1;
            else
                kalib4_3 = 0;
            end;
        
            kalib4 = kalib4_1 * kalib4_2 * kalib4_3;
        end; %end if 'high' 4 part 
        
        %fprintf(VSG,':OUTP OFF');
        
        %part 5
        
        disp('calib part 5');
        
        if strcmp(path,'low')
            
            k1 = turn_NG(Ant,NG1_adr,'00000001');
            k2 = turn_key(Ant,Key9_adr,'00000000'); %key W9 to AB/CD
            k3 = turn_key(Ant,Key3_adr,'00000001'); %key W3 to BC/AD
            k4 = turn_key(Ant,Key26_adr,'00000000'); %key W26 to AB/CD
            k5 = turn_key(Ant,Key28_adr,'00000001'); %key W28 to BC/AD
            k6 = turn_key(Ant,Key32_adr,'00000000'); %key W32 to AB/CD
            
            if k1 * k2 * k3 * k4 * k5 * k6 ~= 0 
                P_A19_5 = get_PW(PW1);
                P_A15_5 = get_PW(PW2);
                fprintf(Baum,'A3:3->2'); %A3 - 3->2
                pause(4);
                fprintf(Baum,'A3:3->C'); %A3 - 3->C
                kalib5 = 1;            
            else
                P_A19_5 = 0;
                P_A15_5 = 0;
                kalib5 = 0;
            end
            
        end; %ens if 'low' 5 part
        
        if strcmp(path,'high')
            k7 = turn_NG(Ant,NG2_adr,'00000001');
            k8 = turn_key(Ant,Key8_adr,'00000001'); %key W8 to In1Out2
            k9 = turn_key(Ant,Key2_adr,'00000001'); %key W2 to In1Out2
            k10 = turn_key(Ant,Key9_adr,'00000000'); %key W9 to AB/CD
            k11 = turn_key(Ant,Key23_adr,'00000000'); %key W23 to In1Out1
        
            if k7 * k8 * k9 * k10 * k11 ~= 0 
                P_A5_5 = get_PW(PW3);
                kalib5_1 = 1;            
            else
                P_A5_5 = 0;
                kalib5_1 = 0;
            end
        
            k12 = turn_key(Ant,Key23_adr,'00000001'); %key W23 to In1Out2
            k1 = turn_key(Ant,Key31_adr,'00000000'); %key W31 to AB/CD
        
            if k12 * k1 ~= 0 
                P_A21_5 = get_PW(PW4);
                kalib5_2 = 1;            
            else
                P_A21_5 = 0;
                kalib5_2 = 0;
            end
            
            k1 = turn_key(Ant,Key31_adr,'00000001'); %key W31 to AD/BC
            
            if k1 ~= 0
                fprintf(Baum,'A3:3->2'); %A3 - 3->2
                pause(4);
                fprintf(Baum,'A3:3->C'); %A3 - 3->C
                kalib5_3 = 1;
            else
                kalib5_3 = 0;
            end;
            
            kalib5 = kalib5_1 * kalib5_2 * kalib5_3;
        end; %end if 'high' 5 part
        
                
        k1 = turn_NG(Ant,NG1_adr,'00000000');   %turn off NG1
        k2 = turn_NG(Ant,NG2_adr,'00000000');   %turn off NG2
                               
        %calculations
        
        disp('calib calc');
        
        %-------------- del in real oper
        kalib1 = 1;
        kalib2 = 1;
        kalib3 = 1;
        kalib3v = 1;
        kalib4 = 1;
        kalib5 = 1;
        %---------------
        
        if (kalib1 * kalib2 * kalib3 * kalib3v * kalib4 * kalib5) ~= 0
        
            %added constants are switch parameters
            %they might be specified with real switches  
            if strcmp(path,'low')
                fi246 = P0 - P_A15_2 - 0.04; % - LW28AB
                fin = 0.04 + 0.05; % LW28BC + LK23
                fi39 = P0 - P_A15_3v - fi246 - fin;
                LL = PA6 - P_A15_5 - fi39 - 0.04; % - LW9CD
                fi311 = PA6 - P_A19_5 - LL - 0.04 - PA6; % - LW9CD
                fi248 = P0 - P_A15_3 - LL - fi39;
                
                delta_A19_VSA = P_A19_3v - P_VSA_3v;
            
                fi257 = 0;
                LKu = 0;
                fi12 = 0;
                fi2510 = 0;
            end; %end if 'low' calc
            
            if strcmp(path,'high')
                fi246 = 0;
                fin = 0;
                fi39 = 0;
                LL = 0;
                fi311 = 0;
                fi248 = 0;
                
                delta_A5_VSA = P_A5_3 - P_VSA_3;
            
                fi257 = P0 - P_A5_2 - 0.04; % - LW23In1Out2
                LKu = PA7 - P_A5_5 - 0.04; % - LW8In1Out2
                fi12 = P0 - P_A21_3v - fi257 - 0.04; % - LW23In2Out2
                fi2510 = P0 - P_A5_4 - LKu - 0.04; % - LW23In1Out1
            end; %end if 'high' calc
            
            %not used P_A19_3v, P_A19_4, P_A15_4, P_A5_3, P_A5_3v, P_A21_4,
            %P_A21_5
                                   
        else
            disp('Something is wrong!');
            disp(kalib1);
            disp(kalib2);
            disp(kalib3);
            disp(kalib3v);
            disp(kalib4);
            disp(kalib5);
                        
            fi1 = 0;
            fi246 = 0;
            fi248 = 0;
            fi39 = 0;
            fi311 = 0;
            fin = 0;
            fi257 = 0;
            fi2510 = 0;
            fi12 = 0;
            LL = 0;
            LKu = 0;
        end
        
        
    else
        %escape from calib procedure
        disp('connection is failed');
        disp(k_sum_keys);
        disp(k_sum_PW);
        
        fi1 = 0;
        fi246 = 0;
        fi248 = 0;
        fi39 = 0;
        fi311 = 0;
        fin = 0;
        fi257 = 0;
        fi2510 = 0;
        fi12 = 0;
        LL = 0;
        LKu = 0;
  end;
  
end

% !!! fprintf(komp,'%04X\n',hex2dec('00FF'));
% !!! fprintf(komp,'%04X%04X\n',B);