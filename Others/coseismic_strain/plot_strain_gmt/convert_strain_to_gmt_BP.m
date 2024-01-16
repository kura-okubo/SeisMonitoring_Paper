% Convert the coulomb33 strain output to the input of GMT plot 
clear all;

%% Load Strain Change
T = importdata("../coulomb33_inputfiles/Strain_BP.cou");
% format: x y z exx eyy ezz eyz exz exy dilatation

%%

N = size(T.data, 1);
xall = zeros(N, 1);
yall = zeros(N, 1);
dil_all = zeros(N, 1);

ZERO_LON =  -120.3706; % from input mat file of coulomb33
ZERO_LAT = 35.8185;

% Process grid node by node
% gid = 2;
for gid =1:N
    dcell = num2cell(T.data(gid, :));
    [x, y, z, exx, eyy, ezz, eyz, exz, exy, dilatation] = dcell{:};

    % convert cartesian x and y to lon and lat
    cLon = ZERO_LON;
    cLat = ZERO_LAT;
    [cx,cy,utmzone]  = deg2utm(cLat, cLon); %lon -> x lat->y
    utmx = cx + x*1e3; % km -> m
    utmy = cy + y*1e3; % km -> m
    [Lat,Lon] = utm2deg(utmx, utmy,utmzone);
        
    % store variables to vector
    xall(gid) = Lon;
    yall(gid) = Lat;
    dil_all(gid) = dilatation*1e6; % [ε] -> [µε]
end

%%
% dumping data to xyz file, which is converted to grd file with gmt xyz2grd

fo_dilation = fopen("./BP_StrainChange_dilation.xyz",'w');

for i =1:N
    fprintf(fo_dilation,'%12.8f %12.8f %12.8e\n',xall(i), yall(i), dil_all(i));
end
fclose(fo_dilation);
