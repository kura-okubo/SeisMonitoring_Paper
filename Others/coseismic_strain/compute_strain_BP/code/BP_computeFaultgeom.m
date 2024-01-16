% Compute the coordinates of ruptured fault and fault on the cross-section
clear all;
addpath("../../coulomb3402/sources");
load("../../coulomb3402/plug_ins/SRCMOD_JUL07_v7.mat");

%%
S = s2004PARKFIjich;

clear s*
%%

geoLON = S.geoLON;
geoLAT = S.geoLAT;

% 2 to end-1 as slip is zero at elements of edges, where the slip is
% nonzero.
p1 = [geoLON(1,2), geoLAT(1,2)];
p2 = [geoLON(end-1,2), geoLAT(end-1,2)];
p3 = [geoLON(1,end-1), geoLAT(1,end-1)];
p4 = [geoLON(end-1,end-1), geoLAT(end-1,end-1)];

figure(1)
clf;
plot(geoLON, geoLAT, ".");
hold on;
plot(p1(1), p1(2), "s", 'markersize', 12);
plot(p2(1), p2(2), "s", 'markersize', 12);
plot(p3(1), p3(2), "s", 'markersize', 12);
plot(p4(1), p4(2), "s", 'markersize', 12);

fi = fopen("../data/parkfield_rupture.txt", "w");
fprintf(fi, sprintf("%f %f\n", p1(1), p1(2)));
fprintf(fi, sprintf("%f %f\n", p2(1), p2(2)));
fprintf(fi, sprintf("%f %f\n", p4(1), p4(2)));
fprintf(fi, sprintf("%f %f\n", p3(1), p3(2)));
fprintf(fi, sprintf("%f %f", p1(1), p1(2)));
fclose(fi);

%% Compute the geometry of fault for the cross-section
% We use fault_int_sec implemented in coulomb33/sources/fault_int_sec.m
% to compute the fault location projected on the cross-section
x0_cs = -27.8051899; % This is determined from the Cross_section_BP.dat
y0_cs = 2.0881508;
x1_cs = 0.9213919;
y1_cs = 29.9230840;
fx0 = S.geoX(1, 2);
fy0 = S.geoY(1, 2);
fx1 = S.geoX(1, end-1);
fy1 = S.geoY(1, end-1);

dip = 83.0;
top =  S.geoZ(1, 1); % surface
zunit = S.geoZ(2, 1) - S.geoZ(1, 1);
bottom = S.geoZ(end, 1) + zunit;

[lp_top,dp_top,lp_bottom,dp_bottom] = fault_int_sec(x0_cs,y0_cs,x1_cs,y1_cs,...
    fx0,fy0,fx1,fy1,dip,top,bottom);

fprintf("The projected fault is %12.8f, %12.8f, %12.8f, %12.8f.\n", lp_top,dp_top,lp_bottom,dp_bottom);
%%