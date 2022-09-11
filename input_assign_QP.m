function u1 = input_assign_QP(x,xd,u1)

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

% V = 1/2*(e'*e);
% delV = (eye(12)+M')*e;
% LfV = delV'*F;
% LgV = delV'*G1*G2;

vzd = -10*(x(5)-xd(5));
V = 1/2*(x(5)-xd(5))^2+1/2*(x(6)-vzd)^2;
LfV = (x(5)-xd(5))*F(5) + (x(6)-vzd)*(F(6)+10*F(5));
LgV = (x(6)-vzd)*G(6,1:3);
LgVu4 = abs((x(6)-vzd)*G(6,4))*3;

%      B = 0.01-x(1:2:5)'*x(1:2:5);
%      LfB = -2*x(1:2:5)'*x(2:2:6);
%      B1 = B+LfB;
%      LfB1 = LfB - 2*x(2:2:6)'*x(2:2:6);

B = 0.01-x(5)^2;
LfB = -2*x(5)*F(6);
B1 = B+LfB;
LfB1 = LfB -2*F(6)^2;
LgB1 = -2*x(5)*G(6,1:3);

%      if B>0

%          i;
%      end

% B2 = 0.1-x(8)^2-x(10)^2;
% LfB2 = -2*x(8)*F(8)-2*x(10)*F(10);
% LgB2 = -2*x(8)*G(8,1:3)-2*x(10)*G(10,1:3);
% LgBu4 = 2*abs(x(5)*G(6,4))*5;

B2 = x(7)^2-ptm^2;
LfB2 = 2*x(7)*F(7);

B21 = B2+LfB2;
LfB21 = LfB2+2*F(7)^2;
LgB21 = 2*x(7)*(G(8,1:3)+G(10,1:3)*sp*tan(theta)+G(12,1:3)*cp*tan(theta));

LgB21u4 = abs(2*x(7)*(G(8,4)+G(10,4)*sp*tan(theta)+G(12,4)*cp*tan(theta)))*3;

B3 = x(9)^2-ptm^2;
LfB3 = 2*x(9)*F(9);
B31 = B3+LfB3;
LfB31 = LfB3+2*F(9)^2;
LgB31 = 2*x(9)*(G(10,1:3)*cp-G(12,1:3)*sp);

LgB31u4 = abs(2*x(9)*(G(10,4)*cp-G(12,4)*sp))*3;

B4 = x(12)^2-4;
LfB4 = 2*x(12)*F(12);
LgB4 = 2*x(12)*G(12,1:3);

% LgVu4 = delV'*G1*[b;-b*l;b*l;d];
% LgVu4 = abs(LgVu4)*5;


% if B2>0
%     x
% end
%
% if B3>0
%     x
% end


% if B4>-1
A_ineq = [
    %         LgB4 -B4 0 0;
%     LgV(1:3) -V 0 0;
    LgB31 0 -B31 0;
    LgB21 0 0 -B21
    1 0 0 0 0 0;
    -1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 -1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 -1 0 0 0];
%
B_ineq = [
    %         -LfB4;
%     -LfV-1*V^0.8-1*V^1.2-LgVu4;
    -LfB31-LgB31u4;
    -LfB21-LgB21u4;
    u_M;
    0;
    u_M;
    0;
    u_M;
    0];
%
% else
%     A_ineq = [LgV(1:3) -V 0 0;
% %         LgV(1:3) -V 0 0;
%         LgB31 0 -B31 0;
%         LgB21 0 0 -B21
%         1 0 0 0 0 0;
%         -1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 -1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 -1 0 0 0];
%
%     B_ineq = [-LfV-1*V^0.8-1*V^1.2;
% %         -LfV-1*V^0.8-1*V^1.2-0*LgVu4;
%         -LfB31-LgB31u4;
%         -LfB21-LgB21u4;
%         5;
%         0;
%         5;
%         0
%         5;
%         0];
%
% %     A_ineq = [LgV(1:3) -V 0 0;
% %         %                LgB1 0 -B1;
% %         1 0 0 0 0 0;
% %         -1 0 0 0 0 0;
% %         0 1 0 0 0 0;
% %         0 -1 0 0 0 0;
% %         0 0 1 0 0 0;
% %         0 0 -1 0 0 0];
% %
% %     B_ineq = [-LfV-1*V^0.8-1*V^1.2;
% %         %                -LfB1;
% %         5;
% %         0;
% %         5;
% %         0
% %         5;
% %         0];
%     %                5;
%     %                0];
% end
%
%
% if B21>-0.09
%     A_ineq = [LgB4 -B4 0 0;
% %         LgV(1:3) -V 0 0;
%         LgB31 0 -B31 0;
%         LgB21 0 0 -B21
%         1 0 0 0 0 0;
%         -1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 -1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 -1 0 0 0];
%
%     B_ineq = [-LfB4;
% %         -LfV-1*V^0.8-1*V^1.2-0*LgVu4;
%         -LfB31-LgB31u4;
%         -LfB21-LgB21u4;
%         5;
%         0;
%         5;
%         0
%         5;
%         0];
%
% else
%     A_ineq = [LgV(1:3) 0 0 -V;
% %         LgV(1:3) -V 0 0;
%         LgB31 0 -B31 0;
%         LgB4 -B4 0 0;
%         1 0 0 0 0 0;
%         -1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 -1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 -1 0 0 0];
%
%     B_ineq = [-LfV-1*V^0.8-1*V^1.2;
% %         -LfV-1*V^0.8-1*V^1.2-0*LgVu4;
%         -LfB31-LgB31u4;
%         -LfB4;
%         5;
%         0;
%         5;
%         0
%         5;
%         0];
% end
%
% if B31>-0.09
%     A_ineq = [LgB4 -B4 0 0;
% %         LgV(1:3) -V 0 0;
%         LgB31 0 -B31 0;
%         LgB21 0 0 -B21
%         1 0 0 0 0 0;
%         -1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 -1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 -1 0 0 0];
%
%     B_ineq = [-LfB4;
% %         -LfV-1*V^0.8-1*V^1.2-0*LgVu4;
%         -LfB31-LgB31u4;
%         -LfB21-LgB21u4;
%         5;
%         0;
%         5;
%         0
%         5;
%         0];
%
% else
%     A_ineq = [LgV(1:3) 0 0 -V ;
% %         LgV(1:3) -V 0 0;
%         LgB21 0 -B21 0;
%         LgB4 -B4 0 0;
%         1 0 0 0 0 0;
%         -1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 -1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 -1 0 0 0];
%
%     B_ineq = [-LfV-1*V^0.8-1*V^1.2;
% %         -LfV-1*V^0.8-1*V^1.2-0*LgVu4;
%         -LfB21-LgB21u4;
%         -LfB4;
%         7;
%         0;
%         7;
%         0
%         7;
%         0];
% end


Q = 10*eye(6)+  0.5*[1 -1 -1 0 0 0;
    -1 1 -1 0 0 0;
    -1 -1 1 0 0 0;
    0  0  0 1 0 0;
    0  0 0 0  1 0;
    0  0 0 0  0 1];
Q(2,2) = 1;
Q(4,4) = 1;
Q(5,5) = 100;
Q(6,6) = 100;

% if abs(x(12))<5
%     u_n = max(0,min([1000*abs(x(5)-xd(5)),5])); %+20*x(11)
% else
%     u_n = 4;
% end
%
%
u1 = quadprog(Q,10*[-2*u_av -u_av -2*u_av 1 100 100],A_ineq, B_ineq, [], [], [], [],u1, options);
% u_n1 = u1(1);
% u_n2 = u1(2);
% u_n3 = u1(3);
end