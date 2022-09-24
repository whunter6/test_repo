%connect generator and scope and poll for command, which specifies which
%circuit was selected on the MCU. Data will display on screen for 10
%seconds, and write to a csv file. Whole circuit will reset after 10 second
%period.Functions defined @bottom of code


%write to ccertain file num corres to test num for rad dose

%connect scope and multimeter
scope = ividev("AgInfiniiVision","USB0::0x0957::0x1796::MY57231553::0::INSTR");
generator = ividev("Ag3352x","USB0::0x0957::0x5707::MY53802060::0::INSTR");

initialize_channels(scope,generator); %enables channels and attenuates probes

prompt = "Input Gate: ";
gate = input(prompt,"s");


%operate according to each gate
switch gate
    case "1.8V BiCMOS OTA"
    case "1.8V CMOS OTA"
    case "OR3"
        
        params = input("Input Square Wave Parameters: [channel_num,amplitude,dc-offset, frequency, phase-offset]"); %seperate function and prompt each param
        cnum = strcat("Channel",num2str(params(1)));
        disp(cnum);
        configureStandardWaveform(generator,cnum,"WFM_SQUARE",params(2),params(3),params(4),params(5));
        configureOutputEnabled(generator,cnum,true)
      
        %test scope_cnum
        scope_cnum = "Channel1";
        %read data from scope
        %read(scope,scope_cnum);
        read(scope,scope_cnum);
        %add more scope channels

    case "1.8V ECL INV"
    case "1.8V ECL OR2"
    case "1.8V ECL OR3"
    case "1.8V PTAT Parallel HBT"
    case "10uA INV"
    %Cur1_2V BUS
    case "D Flip Flop"
    case "Frequency Divider"
    case "OPRRPRESS_INH1"
    case "OPRRPRESS_INH2"
    %REF_1V BUS
    case "Ring Oscillator 31"
    
end



function [] = initialize_channels(scope,generator)

    reset(scope);
    scope.Channel("Channel1").ChannelEnabled = true;
    scope.Channel("Channel2").ChannelEnabled = true;
    scope.Channel("Channel3").ChannelEnabled = true;
    scope.Channel("Channel4").ChannelEnabled = true;



    scope.Channel("Channel1").ProbeAttenuation = 10;
    scope.Channel("Channel2").ProbeAttenuation = 10;
    scope.Channel("Channel3").ProbeAttenuation = 10;
    scope.Channel("Channel4").ProbeAttenuation = 10;

   

    statusClear(generator);
    reset(generator);

end

function [] = read(scope,cnum)
    %initialize scope & extract data to [waveformArray, actual points]
    scope.autoSetup();
    maxTimeMilliseconds = 1e3;
    recordLength = actualRecordLength(scope);
    [waveformArray,actualPoints] = readWaveform(scope,cnum,recordLength,maxTimeMilliseconds);
    

    %graph data
    n = numel(waveformArray);
    dt = scope.Acquisition.HorizontalTimePerRecord/scope.Acquisition.HorizontalRecordLength;
    t = (0:n-1) *dt;
    plot (t,waveformArray,'r');
    hold on;
    xlabel('Time(s)');
    ylabel('Voltage(V)');
    
    
end

function [] = read_ten_seconds(scope,scope_cnum)
    
    start = now;
    while (now - start) < 10/60/24
    %do something for a minute
    
    scope.autoSetup();
    maxTimeMilliseconds = 1e3;
    recordLength = actualRecordLength(scope);
    [waveformArray,actualPoints] = readWaveform(scope,scope_cnum,recordLength,maxTimeMilliseconds);
    
    
    n = numel(waveformArray);
    dt = scope.Acquisition.HorizontalTimePerRecord/scope.Acquisition.HorizontalRecordLength;
    t = (0:n-1) *dt;
    plot (t,waveformArray,'r');
    hold on;
    xlabel('Time(s)');
    ylabel('Voltage(V)');

    start = start + 10000;

    end 
end
