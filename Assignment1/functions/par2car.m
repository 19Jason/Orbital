function [rr, vv] = par2car(orb, mu)
% par2car - Trasformation from Keplerian coordinates to cartesian
%           parameters
%
% PROTOTYPE
%   [rr,vv]=par2car(orb,mu)
%
% INPUT:
%   orb      double [6x1]   orbital parameters                   [-]
%   mu       double [1x1]   gravitational parameter       [km^3/s^2]
%
% OUTPUT:
%   rr       double [3x1]   position vector                     [km]
%   vv       double [3x1]   velocity vector                   [km/s]
%
% CALLED FUNCTIONS: astroConstants
%
% CONTRIBUTORS:
%   Rosato Davide               10618468
%   Saba Mohammadi Yengeje      10789462
%   Spinelli Jason              10618465
%   Tagliati Alessia            10635119
%
% VERSIONS
%   2021-10-21: Release
%
% -------------------------------------------------------------------------

a = orb(1);
e = orb(2);
i = orb(3);
OM = orb(4);
om = orb(5);
th = orb(6);

R_OM = [cos(OM) sin(OM) 0; -sin(OM) cos(OM) 0; 0 0 1];
R_i =  [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)];
R_om = [cos(om) sin(om) 0; -sin(om) cos(om) 0; 0 0 1];

T_ECI_PF = R_om*R_i*R_OM;
T_PF_ECI = T_ECI_PF';

p = a*(1-e^2);

r = p/(1+e*cos(th));

r_PF = r*[cos(th); sin(th); 0];
v_PF = sqrt(mu/p)*[-sin(th); e+cos(th); 0];

rr = T_PF_ECI*r_PF;
vv = T_PF_ECI*v_PF;
    
end