function [ output ] = IoPB(Comp,Temp,Thick)
%Performs permeability barrier formation calculation
%
%   Comp: Composition text file
%       Accepted options:
%           K&M1997: Keszthelyi and McEwan 1997
%   Temp: mantle potential temperature
%   Thick: lithsophere thickness

%% File Manipulation 

mkdir('/Users/jschools/Desktop/PBOutput')

formatSpec = '/Users/jschools/Desktop/Io_PB_Results/%s/%d_km/%d_C'; %Creates destination path for results storage

output_str = sprintf(formatSpec,Comp,Thick,Temp); 

save('output_str'); %Saves destination point to call later

f='/Users/jschools/Documents/MATLAB/Io_isentropic.txt';
p='/Users/jschools/Documents/MATLAB/output_1';
b='/Users/jschools/Documents/MATLAB/batchfile_Io1.txt'; 

%Adjust batchfile_1 for input oxygen fugacity and composition file
%Open batchfile_1
fid = fopen(b,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit batchfile_1
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
A{2} = sprintf('%s',str);

%Close batchfile_1
fid = fopen(b, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%Adjust isentrpoic.txt for input Lithosphere thickness
%Open isentropic
fid = fopen(f,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit isentropic
ThickP = 54*Thick; %Thickness to pressure conversion

formatSpec = 'ALPHAMELTS_MINP          %d';
str = sprintf(formatSpec,ThickP);
A{31} = sprintf('%s',str);

%Close isentropic
fid = fopen(f, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%Open user chosen composition file and change user input temperature
%Open composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);

%Edit composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str, 'r');
C = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

%Line number varies depending on file
%Search for correct line to change
C = strfind(C{1}, 'Initial Temperature:');
rows = find(~cellfun('isempty', C));

formatSpec = 'Initial Temperature: %d';
str = sprintf(formatSpec,Temp);
A{rows} = sprintf('%s',str);

%Close composition file
formatSpec = '/Users/jschools/Documents/MATLAB/%s.melts';
str = sprintf(formatSpec,Comp);
fid = fopen(str, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
fclose(fid);

%% MELTS computations

disp('Starting Adiabatic Melting')
MELTS(f,p,b) %Adiabatic melting calculation

%PTPath %Creation of Areotherm P-T path - Mars
IoPTPath
disp('Finished Adiabatic Melting')

Total_Melt_Io %Io

f='/Users/jschools/Documents/MATLAB/PTIotherm.txt';
p='/Users/jschools/Documents/MATLAB/output_2';         %Load Crystallization files
b='/Users/jschools/Documents/MATLAB/batchfile_Io2.txt';

disp('Starting Batch Crystallization')
disp(datetime('now','TimeZone','America/New_York','Format','eeee, MMMM d, yyyy h:mm a'))
MELTS(f,p,b) %Crystallization in lithosphere calculation, may stall at this point
disp('Finished Batch Crystallization')
mkdir(output_str);
%copyfile('/Users/jschools/Desktop/PBOutput',output_str); %saves outputs to directory

%% Visulizations

%PBVisBatch_Io %creates figures to locate permeability barrier location

%% Save Files

copyfile('/Users/jschools/Documents/MATLAB/output_1','/Users/jschools/Desktop/PBOutput/output_1')
copyfile('/Users/jschools/Documents/MATLAB/output_2','/Users/jschools/Desktop/PBOutput/output_2')

load('output_str')

mkdir(output_str);
copyfile('/Users/jschools/Desktop/PBOutput',output_str); %saves outputs to directory

rmdir('/Users/jschools/Desktop/PBOutput')

end