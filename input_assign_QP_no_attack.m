function u1 = input_assign_QP_no_attack(x,xd,u1)

global kr kt m Ix Iy Iz options g b l d ptm u_av u_M
vd = -(x(1:2:5)-xd(1:2:5));
e = [x(1)-xd(1);
    x(2)-vd(1);
    x(3)-xd(3);
    x(4)-vd(2);
    x(5)-xd(5);
    x(6)-vd(3);
    x(7:end)-xd(7:end)];

phi = x(7);
theta = x(9);
psi = x(11);

cp = cos(phi);
ct = cos(theta);
cs = cos(psi);
sp = sin(phi);
st = sin(theta);
ss = sin(psi);

F = [x(2);
    0-kt*x(2);
    x(4);
    0-kt*x(4);
    x(6);
    g-kt*x(6);
    x(8)+x(10)*sp*tan(theta)+x(12)*cp*tan(theta);
    (Iy-Iz)/Ix*x(10)*x(12)-kr*x(8);
    x(10)*cp-x(12)*sp;
    (Iz-Ix)/Iy*x(8)*x(12)-kr*x(10);
    1/ct*(x(12)*cp+x(10)*sp);
    (Ix-Iy)/Iz*x(8)*x(10)-kr*x(12);
    ];



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

%      G2 = [b  b  b  b;
%           -b*l 0 b*l 0;
%           0  -b*l 0 b*l;
%           -d   d  -d  d];
% G2 = [b  b  b  b;
%     -b*l b*l b*l -b*l;
%     -b*l -b*l b*l b*l;
%     -d   d  -d  d];

G2 = [b  b  b  b;
    0  -b*l 0 b*l;
    -b*l 0 b*l 0;
    d   -d  d  -d];
      
%      G2(1:4,4) = zeros(4,1);
M = [zeros(1,12);1 zeros(1,11); zeros(1,12); 0 0 1 zeros(1,9); zeros(1,12); 0 0 0 0 1 zeros(1,7);zeros(6,12)];

G = G1*G2;


if abs((x(5)-xd(5)))<0.0001
    vxd = -10*(x(1)-xd(1));
    vyd = -10*(x(3)-xd(3));
    vzd = -10*(x(5)-xd(5));
    V = 1/2*(x(5)-xd(5))^2+1/2*(x(6)-vzd)^2+1/2*(x(1)-xd(1))^2+1/2*(x(2)-vxd)^2+1/2*(x(3)-xd(3))^2+1/2*(x(3)-vyd)^2;
    LfV = (x(5)-xd(5))*F(5) + (x(6)-vzd)*(F(6)+10*F(5)) +(x(1)-xd(1))*F(1) + (x(2)-vxd)*(F(2)+10*F(1)) + (x(3)-xd(3))*F(3) + (x(4)-vyd)*(F(4)+10*F(3));
    LgV = (x(6)-vzd)*G(6,:)+(x(2)-vxd)*G(2,:)+(x(4)-vyd)*G(4,:);
    
%     V = 1/2*(e'*e);
%     delV = (eye(12)+M')*e;
%     LfV = delV'*F;
%     LgV = delV'*G1*G2;
else
    vzd = -10*(x(5)-xd(5));
    V = 1/2*(x(5)-xd(5))^2+1/2*(x(6)-vzd)^2;
    LfV = (x(5)-xd(5))*F(5) + (x(6)-vzd)*(F(6)+10*F(5));
    LgV = (x(6)-vzd)*G(6,:);
end

B2 = x(7)^2-ptm^2;
LfB2 = 2*x(7)*F(7);

B21 = B2+LfB2;
LfB21 = LfB2+2*F(7)^2;
LgB21 = 2*x(7)*(G(8,:)+G(10,:)*sp*tan(theta)+G(12,:)*cp*tan(theta));

% LgB21u4 = abs(2*x(7)*(G(8,4)+G(10,4)*sp*tan(theta)+G(12,4)*cp*tan(theta)))*3;

B3 = x(9)^2-ptm^2;
LfB3 = 2*x(9)*F(9);
B31 = B3+LfB3;
LfB31 = LfB3+2*F(9)^2;
LgB31 = 2*x(9)*(G(10,:)*cp-G(12,:)*sp);



B = x(7)^2+x(9)^2-ptm^2;
LfB = LfB2+LfB3;
B1 = B+LfB;
LfB1 = LfB21+LfB31;
LgB1 = LgB21+LgB31;



A_ineq = [
    %         LgB4 -B4 0 0;
    LgV -V 0 0;
    LgB1 0 -B1 0;
    1 0 0 0 0 0 0;
    -1 0 0 0 0 0 0;
    0 1 0 0 0 0 0;
    0 -1 0 0 0 0 0;
    0 0 1 0 0 0 0;
    0 0 -1 0 0 0 0;
    0 0 0 1 0 0 0;
    0 0 0 -1 0 0 0];
%
B_ineq = [
    %         -LfB4;
    -LfV-1*V^0.8-1*V^1.2;
    -LfB1;
    u_M;
    0;
    u_M;
    0
    u_M;
    0;
    u_M;
    0];
%

Q = 10*eye(7)+[4 -1 -1 -1 0 0 0;
    -1 4 -1 -1 0 0 0;
    -1 -1 4 -1 0 0 0;
    -1 -1 -1 4 0 0 0
    0  0  0  0 1 0 0;
    0  0  0  0 0 1 0;
    0  0  0  0 0 0 1];

Q(5,5) = 100;
Q(6,6) = 1000;
Q(7,7) = 1000;

f = 10*[-u_av -u_av -u_av -u_av 100 1000 1000]; 

u1 = quadprog(Q,f,A_ineq, B_ineq, [], [], [], [],u1, options);

end