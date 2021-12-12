function dx = ode_2bpTLEs(t,x,mu,TLEs)
% ode_2bp - Ode function to compute the motion of the satellite in an
% unperturbed orbit and keep track of other objects orbiting the Earth
% through TLEs.
%
% PROTOTYPE
%   dx=ode_2bp(t,x,mu,TLEs)
%
% INPUT:
%   t        double  [1x1]   time                                 [s]
%   x        double  [6x1]   state vector               [km and km/s]
%   mu       double  [1x1]   gravitational parameter       [km^3/s^2]
%   satData  table  [Nx16] TLEs table                             [-]
%
% OUTPUT:
%   dx       double [6x1]   state vector derivative              [-]
%
% CALLED FUNCTIONS: SGP8
%
% CONTRIBUTORS:
%   Rosato Davide               10618468
%   Saba Mohammadi Yengeje      10789462
%   Spinelli jason              10618465
%   Tagliati Alessia            10635119
%
% VERSIONS
%   2021-10-21: Release
%
% -------------------------------------------------------------------------

    r = norm(x);
    dx = [x(4:6); -mu/(r^3)*x(1:3)];
end