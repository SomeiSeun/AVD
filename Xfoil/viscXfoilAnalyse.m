function [AoA, CL, CM, CD] = viscXfoilAnalyse(NACA, numNodes, Mach, RE, AoA, ITER)
% this function calls on Xfoil to generate aerofoil viscid polar curves,
% for CL, CD, and CM against AoA.
% You must have Xfoil.exe in the same folder

% INPUTS
% NACA       = NACA 4/5-digit series
% numNodes   = number of nodes in airfoil
% Mach       = Mach number
% RE         = Reynolds Number
% AoA        = AoA array of format [AoAmin, AoAstep, AoAmax]
% ITER       = number of iterations per AoA value

%Converting inputs to strings
NACA = num2str(NACA);
numNodes = num2str(numNodes);
Mach = num2str(Mach);
RE = num2str(RE);
AoAmin = num2str(AoA(1));
AoAmax = num2str(AoA(3));
AoAstep = num2str(AoA(2));
ITER = num2str(ITER);

savePolar = 'SavePolar.txt';
xFoilInput = 'xfoil_input.txt';
% Delete files if they exist
if (exist(savePolar,'file'))
    delete(savePolar);
end

% Create the airfoil
fid = fopen(xFoilInput,'w');
fprintf(fid,['NACA ' NACA '\n']);
fprintf(fid,'PPAR\n');
fprintf(fid,['N ' numNodes '\n']);
fprintf(fid,'\n\n');

% Analyse airfoil
fprintf(fid,'OPER\n');
fprintf(fid,'VISC\n');
fprintf(fid,[RE '\n']);
fprintf(fid,'ITER\n');
fprintf(fid,[ITER, '\n']);
fprintf(fid,['Mach ' Mach '\n']);
fprintf(fid,'PACC\n');
fprintf(fid,[savePolar '\n\n']);
fprintf(fid,'ASEQ\n');
fprintf(fid,[AoAmin '\n']);
fprintf(fid,[AoAmax '\n']);
fprintf(fid,[AoAstep '\n']);

% Close file
fclose(fid);

%% Run XFoil using input file
cmd = ['xfoil.exe < ' xFoilInput];
status = system(cmd);
delete(xFoilInput);

% Read data file
fidPolar = fopen(savePolar);  
dataBuffer = textscan(fidPolar,'%f %f %f %f %f %f %f','CollectOutput',1,'Delimiter','','HeaderLines',12);
fclose(fidPolar);
delete(savePolar);

% Assign data file to variables
AoA = dataBuffer{1,1}(:,1);
CL = dataBuffer{1,1}(:,2);
CD = dataBuffer{1,1}(:,3);
CM = dataBuffer{1,1}(:,5);
end
