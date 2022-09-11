clc
clearvars
close all

options = optimoptions('quadprog','Display','off');


num = 20000;

dt = 0.001;

Ix = 1;
Iy = 1;
Iz = 1;

g = 9.8;

m = 1;

b = 1;
l = 1;
d = 1;

x = zeros(12,num);
x(:,1) = [randn(1,12)/1000]';
u = zeros(4,num);
xd = [0 0 0 0 -1 0 zeros(1,6)]';

for i = 1:num
%     V = 1/2*(x(:,i)-xd)'*(x(:,i)-xd);
    vd = -(x(1:2:5,i)-xd(1:2:5));
    e = [x(1,i)-xd(1); 
        x(2,i)-vd(1);
        x(3,i)-xd(3); 
        x(4,i)-vd(2);
        x(5,i)-xd(5); 
        x(6,i)-vd(3);
        x(7:end,i)-xd(7:end)];
    V = 1/2*e'*e;
    

    F = [x(2,i);
          0;
         x(4,i);
         0;
         x(6,i);
         g;
         x(8,i);
         (Iy-Iz)/Ix*x(10,i)*x(12,i);
         x(10,i);
         (Iz-Ix)/Iy*x(8,i)*x(12,i);
         x(12,i);
         (Ix-Iy)/Iz*x(8,i)*x(10,i);
         ];
     
    phi = x(7,i);
    theta = x(9,i);
    psi = x(11,i);
    
    cp = cos(phi);
    ct = cos(theta);
    cs = cos(psi);
    sp = sin(phi);
    st = sin(theta);
    ss = sin(psi);
    
    G1 = [0 0 0 0;
         -1/m*(sp*ss+cp*cs*st) 0 0 0;
         0 0 0 0;
         -1/m*(cp*ss*st-cs*sp) 0 0 0;
         0 0 0 0;
         -1/m*(cp*ct) 0 0 0;
         0 0 0 0;
         0 1/Ix 0 0;
         0 0 0 0;
         0 0 1/Iy 0;
         0 0 0 0;
         0 0 0 1/Iz];
     
     G2 = [b  b  b  b; 
          -b*l b*l b*l -b*l;
          -b*l -b*l b*l b*l;
          -d   d  -d  d];
%      G2 = [b  b  b  b; 
%           -b*l 0 b*l 0;
%           0  -b*l 0 b*l;
%           -d   d  -d  d];
%      Gg = [0 0 0 0 g 0 0 0 0 0 0 0]';
     M = [zeros(1,12);1 zeros(1,11); zeros(1,12); 0 0 1 zeros(1,9); zeros(1,12); 0 0 0 0 1 zeros(1,7);zeros(6,12)];
     delV = (eye(12)+M')*e;
     LfV = delV'*F;
     LgV = delV'*G1*G2;
%      LggV = (x(:,i)-xd)'*Gg;
     
     A_ineq = [LgV -V; 
                1 0 0 0 0;
               -1 0 0 0 0;
                0 1 0 0 0;
               0 -1 0 0 0;
                0 0 1 0 0;
               0 0 -1 0 0;
                0 0 0 1 0;
               0 0 0 -1 0];
            
     B_ineq = [-LfV-1*V^0.8-1*V^1.2;
               5;
               0;
               5;
               0
               5;
               0;
               5;
               0]; 
     Q = 10*eye(5)+[1 -1 -1 -1 0; 
                 -1 1 -1 -1 0; 
                 -1 -1 1 -1 0; 
                 -1 -1 -1 1 0; 
                  0  0  0 0 1];
     Q(5,5) = 100;
     if i == 1
         u1 = zeros(5,1);
     end 
     u1 = quadprog(Q,[-u1(1:4)' 1000],A_ineq, B_ineq, [], [], [], [],u1, options);
     if sum(u1(1:4))/4-u1(1)>1
         i;
     end
%      u1 = 10*ones(4,1)*(x(5,i)-xd(5)+x(6,i));
     u(:,i) = u1(1:4,1);
     x(:,i+1) = x(:,i) + (F+G1*G2*u(:,i))*dt;
end

x_data = x;
%%
x = x_data;
lambda = 0:0.01:2*pi;
write_vid = 0;

y = x(3,1:end-1);
z = -x(5,1:end-1);
phi = x(7,1:end-1);
theta = x(9,1:end-2);
psi = x(11,1:end-1);
x = x(1,1:end-1);

animatesimulation
