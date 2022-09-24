%create objects from connected instruments
scope = ividev("AgInfiniiVision","USB0::0x0957::0x1796::MY57231553::0::INSTR");
generator = ividev("Ag3352x","USB0::0x0957::0x5707::MY53802060::0::INSTR");
%initialize scope & Channel
reset(scope);

scope.Channel("Channel1").ChannelEnabled = true;
scope.Channel("Channel1").ProbeAttenuation = 1;

scope.Channel("Channel2").ChannelEnabled = true;
scope.Channel("Channel2").ProbeAttenuation = 1;

maxTimeMilliseconds = 1e5;

statusClear(generator);
reset(generator);

%generate figure
figure(1);
grid on;
hold on;

%generate square wave on 33600a function generator
%channel 1 increments DC offset, channel 2 increments frequency
 
for i=0:0.1:0.5
    
    %config & output sq wave. increment dc offset by 0.1 to 0.5
    configureStandardWaveform(generator,"Channel1","WFM_SQUARE",0.2,0.1+i,1000,0);
    
    configureOutputEnabled(generator,"Channel1",true);
    

%extract data
 scope.autoSetup();
 recordLength = actualRecordLength(scope);
 [waveformArray,actualPoints] = readWaveform(scope,"Channel2",recordLength,maxTimeMilliseconds);

 
 %graph data
    n = numel(waveformArray);
    dt = scope.Acquisition.HorizontalTimePerRecord/scope.Acquisition.HorizontalRecordLength;
    t = (0:n-1) *dt;
    plot (t,waveformArray,'r');
    hold on;
    xlabel('Time(s)');
    ylabel('Voltage(V)');

   
end

%square wave stepping from 1kHz to 100kHz

for i=0:0.1:0.5

%config & output sq. wave 
configureStandardWaveform(generator, "Channel2", "WFM_SQUARE", 0.2,-0.1-i,1000,0);
configureOutputEnabled(generator,"Channel2",true);

%extract data

 recordLength = actualRecordLength(scope);
 [waveformArray,actualPoints] = readWaveform(scope,"Channel2",recordLength,maxTimeMilliseconds);
 
 
 %graph data
    n = numel(waveformArray);
    dt = scope.Acquisition.HorizontalTimePerRecord/scope.Acquisition.HorizontalRecordLength;
    t = (0:n-1) *dt;
    plot (t,waveformArray,'b');
    hold on;
    xlabel('Time(s)');
    ylabel('Voltage(V)');

end

