function [ QUAD_HANDLE ] = draw_quadrotor( QUAD_FNUM, QUADXYZ, PHI, THETA, PSI, CX, CY, CZ, FCOLOR,attack_sig)
%DRAW_QUADROTOR draws a quadrotor oriented and translated 
%               in the current figure
%   Parameters
%   Input, integer QUAD_FNUM, # of faces in quadrotor model
%   Input, real QUADXYZ(NODENUM,3), quadrotor xyz node positions (m)
%   Input, real PHI, current roll (rad)
%   Input, real THETA, current pitch (rad)
%   Input, real PSI, current yaw (rad)
%   Input, real CX, current center x position (m)
%   Input, real CY, current center y position (m)
%   Input, real CZ, current center z position (m)
%   Input, string or [r g b] FCOLOR, color for the faces of the model
%   Output, handle QUAD_HANDLE, patch handle for quadrotor

%first need to get euler rotation matrix for the rotor
%R = [rot(PHI)*rot(THETA)*rot(PSI)]';               %rotation matrix

R = compose_rotation(PHI,THETA,PSI);

T = zeros(length(QUADXYZ(:,1)), 3);
T(:,1) = CX; T(:,2) = CY; T(:,3) = CZ;  %translation matrix

%perform rotation and translation
xyz = QUADXYZ*R'+T;   %rotate and translate

%draw quadrotor model


% 

QUAD_HANDLE = trisurf(QUAD_FNUM, ...
                      xyz(:,1), xyz(:,2), xyz(:,3), ...
                      'FaceColor', FCOLOR,'EdgeColor',[0.1 0.6 0.1]);
if attack_sig > 0 
QUAD_HANDLE = trisurf(QUAD_FNUM(1:(430+456),:), ...
                      xyz(1:(430+456)*3,1), xyz(1:(430+456)*3,2), xyz(1:(430+456)*3,3), ...
                      'FaceColor', [0.1 0.6 0.1],'EdgeColor',FCOLOR);
end

if attack_sig == 2
QUAD_HANDLE = trisurf(QUAD_FNUM(1:(430*2+456),:), ...
                      xyz(1:(430*2+456)*3,1), xyz(1:(430*2+456)*3,2), xyz(1:(430*2+456)*3,3), ...
                      'FaceColor', [0.1 0.6 0.1],'EdgeColor',FCOLOR);
end
            
                  
i_s = 2813;
l_s = 86;



if attack_sig>0
% 
QUAD_HANDLE = trisurf(QUAD_FNUM(1:l_s,:), ...
                      xyz(i_s*3+1:(i_s+l_s)*3,1), xyz(i_s*3+1:(i_s+l_s)*3,2), xyz(i_s*3+1:(i_s+l_s)*3,3), ...
                      'FaceColor', [0.1 0.6 0.1],'EdgeColor',FCOLOR);
end

i_s = 3081-85-85;
l_s = 86;

if attack_sig == 2
QUAD_HANDLE = trisurf(QUAD_FNUM(1:l_s,:), ...
                      xyz(i_s*3+1:(i_s+l_s)*3,1), xyz(i_s*3+1:(i_s+l_s)*3,2), xyz(i_s*3+1:(i_s+l_s)*3,3), ...
                      'FaceColor', [0.1 0.6 0.1],'EdgeColor',FCOLOR);
end

    
end

