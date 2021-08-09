%% Load Files

copyfile('/Users/jschools/Documents/MATLAB/output_1','/Users/jschools/Desktop/PBOutput/output_1')
copyfile('/Users/jschools/Documents/MATLAB/output_2','/Users/jschools/Desktop/PBOutput/output_2')

file1='/Users/jschools/Documents/MATLAB/output_2/Solid_comp_tbl.txt';
file2='/Users/jschools/Documents/MATLAB/output_2/Bulk_comp_tbl.txt';
file3='/Users/jschools/Documents/MATLAB/output_2/Phase_mass_tbl.txt';
file4='/Users/jschools/Documents/MATLAB/LithDepth.txt';

fid = fopen(file1);
delimiterIn=' ';

A = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',' ','TreatAsEmpty',{'---'},'HeaderLines',4);
B = importdata(file2,delimiterIn,4);
mass = B.data(1,3);

Dl = A{1,1}(1)/54;


%% Bulk Crystalization Rate

figure 
hold on
%try
Temp = (A{1,2});
Depth = (A{1,1})/54; %For Io
%Depth = (A.data(:,1))/284.20; %For Earth
n1=length(Depth);
MinPeakHeight = 0.01;
Threshold = 3e-5;

start=2; %Start of calculation

Pressure_Step = A{1,1}(n1-1)-A{1,1}(n1);
Depth_Step = Pressure_Step/0.054; % ~185 km/GPa on Io
%Depth_Step = Pressure_Step/0.10762; % ~92 km/GPa on Mars

for i=start:n1
    Percent(i) =(A{1,3}(i)-A{1,3}(i-1)).*(100./mass);
    Rate1(i) = (Percent(i)./Depth_Step); 
end

    plot(Depth,Rate1)
    xlabel('Depth (km)')
    ylabel('Crystallization Rate (%/bar)')
    axis([-inf,Dl,0,inf])
    set(gca,'FontSize',24)
    box on
    savefig('/Users/jschools/Desktop/PBOutput/BulkComp.fig');
    PBRate=[Depth'; Rate1];

    print -dpdf /Users/jschools/Desktop/PBOutput/BulkComp.pdf
%catch
    disp('Failure in Displaying Bulk Cyrstallization')
%end

%% Mineral Crystalization Rates

figure 
hold on
C = importdata(file3,delimiterIn,4);
Clength=length(C.colheaders);
Depth2 = (C.data(:,1))/54;

try
    n=length(C.data(:,1));
    for i=5:Clength
        for j=start:n
            Percent(j) = (C.data(j,i)-C.data(j-1,i))*(100/mass);
            Rate2(j) = Percent(j)/Pressure;
        end
        Line(i)=plot(Depth2,Rate2,'linewidth',2);
        legendinfo(i)=C.colheaders(i);
    end
    legendinfo(4)=[];
    legendinfo(3)=[];
    legendinfo(2)=[];
    legendinfo(1)=[];
    legend(legendinfo,'location','southwest','fontsize',18)
    set(gca,'FontSize',24)
    xlabel('Depth (km)')
    ylabel('Crystallization Rate (%/bar)')
    axis([-inf,Dl,-inf,inf])
    set(gca,'FontSize',24)
    box on
    savefig('/Users/jschools/Desktop/PBOutput/MineralComp.fig');

    print -dpdf /Users/jschools/Desktop/PBOutput/MineralComp.pdf
catch
    disp('Mineral Crystallization Failed')
end

figure 
hold on
D = importdata(file1,delimiterIn,4);
Dlength=length(D.colheaders);

n=length(D.data(:,1));
for i=4:Dlength
   for j=start:n
       Percent(j) = (D.data(j,i)-D.data(j-1,i))*(100/mass);
       Rate(j) = Percent(j)/Pressure;
   end
       Line(i)=plot(Depth,Rate,'linewidth',2);
       legendinfo(i)=D.colheaders(i);
end

try
    fileID = fopen('/Users/jschools/Desktop/PBOutput/PBRate.txt','w');
    fprintf(fileID,'%12.8f %12.8f\n',PBRate);
    fclose(fileID);

    Peaks=[Depth(loc)';Temp(loc)'; pks];
    fileID = fopen('/Users/jschools/Desktop/PBOutput/Peaks.txt','w');
    fprintf(fileID,'%6s %6s %12s\n','Depth','Temp','Rate');
    fprintf(fileID,'%8f %4f %8f\n',Peaks);
    fclose(fileID);
catch
    disp('PBRate.txt and Peaks.txt failed to write')
end

%% Save Files

load('output_str')

mkdir(output_str);
copyfile('/Users/jschools/Desktop/PBOutput',output_str); %saves outputs to directory

rmdir('/Users/jschools/Desktop/PBOutput')
