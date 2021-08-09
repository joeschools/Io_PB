file='/Users/jschools/Documents/MATLAB/output_1/Bulk_comp_tbl.txt';
A1 = importdata(file,' ',5);

Pa=A1.data(:,1); % record adiabatic melting path
Ta=A1.data(:,2);

n=length(Pa);

Pa=Pa(30:n);
Ta=Ta(30:n); % Trim to start at 2 GPa in MELTS run
n=length(Pa);

Pi=Pa(n);
Di=Pi*(100/5.4);
Ti=Ta(n); % Starting point of lithosphere temperature curve

Pf=0;
Df=0;
Tf=-160;

Zstep=5; % Sets the step size in meters. Melts will calculate every ____m.

D=Di:-Zstep:Df;

dT = Ti - Tf;

a = 1e-6; % (m^2)/s

%% Resurfacing Rate
v = 3.3e-10; % m/s (1 cm/yr, most likely, nominal)
%v = 6.7e-12; % m/s (0.02 cm/yr, absolute minimum, slow)
%v = 10e-25; % m/s ("no resurfacing", slowest)
l = a/v;

i=1:1:length(D);

%%
Tl = ((dT*(exp(D/l)-1))/(exp(Di/l)-1))+Tf;

Pl = D.*(5.4/100);
Da = Pa*(100/5.4);


figure
plot(Tl,-D/1000,Ta,-Da/1000,'linewidth',6) % Plots temp/depth profile for sanity check
xlabel('Temperature (C)')
ylabel('Depth (km)')
%title(str)
%legend('Lithosphere Geotherm','Mantle Adiabat','location','southwest')
set(gca,'FontSize',24)
box on
savefig('/Users/jschools/Desktop/PBOutput/Iotherm.fig');

print -dpdf /Users/jschools/Desktop/PBOutput/Iotherm.pdf

Pa=Pa(30:n-1);
Ta=Ta(30:n-1);

n3 = length(Pl);
n2 = length(Pa);
P=zeros(1,n2+n3);
P(1:n2)=Pa;
P(n2+1:n2+n3)=Pl;
T=zeros(1,n2+n3);
T(1:n2)=Ta;
T(n2+1:n2+n3)=Tl;
PT=[P; T];
%PT=[Pl; Tl];

fileID = fopen('/Users/jschools/Documents/MATLAB/PTpath.txt','w');
fprintf(fileID,'%12.8f %12.8f\n',PT);
fclose(fileID);

copyfile('/Users/jschools/Documents/MATLAB/PTPath.txt','/Users/jschools/Desktop/PBOutput')
