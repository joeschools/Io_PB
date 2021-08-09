%file1 = '/Users/jschools/Documents/MATLAB/W&D1994.melts'; % Mars
file1 = '/Users/jschools/Documents/MATLAB/K&M1997.melts'; % Io
file2 = '/Users/jschools/Desktop/PBOutput/Residue.melts';
file3 = '/Users/jschools/Desktop/PBOutput/Liquid.melts';


fid = fopen(file1, 'r');
C = textscan(fid, 'Title: %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MnO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Composition: K2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f', 'Delimiter','\n');
fclose(fid);

fid = fopen(file2, 'r');
D = textscan(fid, '%s %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MnO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O %f Initial Composition: K2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f %s %s %s %s %s', 'Delimiter','\n');
fclose(fid);

SiO2 = C{2}-((D{3}/100)*D{14});
TiO2 = C{3}-((D{4}/100)*D{14});
Al2O3 = C{4}-((D{5}/100)*D{14});
Fe2O3 = 0.001;
Cr2O3 = C{6}-((D{7}/100)*D{14});
FeO = (C{5}+C{7})-(((D{6}/100)*D{14})+((D{8}/100)*D{14}));
MnO = C{8}-((D{9}/100)*D{14});
MgO = C{9}-((D{10}/100)*D{14});
CaO = C{10}-((D{11}/100)*D{14});
Na2O = C{11}-((D{12}/100)*D{14});
K2O = C{12}-((D{13}/100)*D{14});
mass = C{13}-D{14};
Initial_Temp = D{15};
Initial_Press = D{16};
%%
fid = fopen(file3, 'r');
E = textscan(fid, '%s %s Initial Composition: SiO2 %f Initial Composition: TiO2 %f Initial Composition: Al2O3 %f Initial Composition: Fe2O3 %f Initial Composition: Cr2O3 %f Initial Composition: FeO %f Initial Composition: MgO %f Initial Composition: CaO %f Initial Composition: Na2O Initial Composition: H2O %f Initial Mass: %f Initial Temperature: %f Initial Pressure: %f %s %s %s %s %s', 'Delimiter','\n');
fclose(fid);

E{1} = 'Title: Keszthelyi and McEwan 1997';
E{2} = 'Title: Calculated liquid composition';

strfind(E{3}, 'Initial Composition: SiO2');
formatSpec = 'Initial Composition: SiO2 %f';
str = sprintf(formatSpec,SiO2);
E{3} = sprintf('%s',str);

strfind(E{4}, 'Initial Composition: TiO2');
formatSpec = 'Initial Composition: TiO2 %f';
str = sprintf(formatSpec,TiO2);
E{4} = sprintf('%s',str);

strfind(E{5}, 'Initial Composition: Al2O3');
formatSpec = 'Initial Composition: Al2O3 %f';
str = sprintf(formatSpec,Al2O3);
E{5} = sprintf('%s',str);

strfind(E{6}, 'Initial Composition: Fe2O3');
formatSpec = 'Initial Composition: Fe2O3 %f';
str = sprintf(formatSpec,Fe2O3);
E{6} = sprintf('%s',str);

strfind(E{7}, 'Initial Composition: Cr2O3');
formatSpec = 'Initial Composition: Cr2O3 %f';
str = sprintf(formatSpec,Cr2O3);
E{7} = sprintf('%s',str);

strfind(E{8}, 'Initial Composition: FeO');
formatSpec = 'Initial Composition: FeO %f';
str = sprintf(formatSpec,FeO);
E{8} = sprintf('%s',str);

strfind(E{9}, 'Initial Composition: MnO');
formatSpec = 'Initial Composition: MnO %f';
str = sprintf(formatSpec,MnO);
E{9} = sprintf('%s',str);

strfind(E{10}, 'Initial Composition: MgO');
formatSpec = 'Initial Composition: MgO %f';
str = sprintf(formatSpec,MgO);
E{10} = sprintf('%s',str);

strfind(E{11}, 'Initial Composition: CaO');
formatSpec = 'Initial Composition: CaO %f';
str = sprintf(formatSpec,CaO);
E{11} = sprintf('%s',str);

strfind(E{12}, 'Initial Composition: Na2O');
formatSpec = 'Initial Composition: Na2O %f';
str = sprintf(formatSpec,Na2O);
E{12} = sprintf('%s',str);

strfind(E{13}, 'Initial Composition: K2O');
formatSpec = 'Initial Composition: K2O %f';
str = sprintf(formatSpec,K2O);
E{13} = sprintf('%s',str);

strfind(E{14}, 'Initial Mass:');
formatSpec = 'Initial Mass: %f';
str = sprintf(formatSpec,mass);
E{14} = sprintf('%s',str);

strfind(E{15}, 'Initial Temperature:');
formatSpec = 'Initial Temperature: %f';
str = sprintf(formatSpec,Initial_Temp);
E{15} = sprintf('%s',str);

strfind(E{16}, 'Initial Pressure:');
formatSpec = 'Initial Pressure: %f';
str = sprintf(formatSpec,Initial_Press);
E{16} = sprintf('%s',str);

E{17} = 'Log fO2 Path: IW';
E{18} = 'Suppress: orthoamphibole';
E{19} = 'Suppress: siderophyllite';

E=E.';
F = cell2table(E);
writetable(F,file3,'WriteVariableNames',false,'FileType','text')
