clc
clearvars -except u2 u4 attack_start0 attack_length no_attack detect_delay ptm delta delta_2
close all

global k_s1 k_s2 k_s3 dt kr kt m Ix Iy Iz options g b l d ptm u_av u_M

options = optimoptions('quadprog','Display','off');

param_generator

num = 50000;

dt = 0.001;

j11 = 0.177;
j22 = 0.177;
j33 = 0.334;

g = 9.8;
m = 4.493;
kt = 1;
kr = 1.5;

Ix = j11;
Iy = j22;
Iz = j33;

% g = 9.8;

% m = 1;

b = 1;
l = 0.1;
d = 0.0024;

x = zeros(12,num);
x(1:2:5,1) = [0.01; 0.01; -0.1];

u = zeros(4,num);
xd = zeros(12,1);
xd(5) = -5;

k_s1 = 0;
k_s2 = 0;
k_s3 = 0;

phid = 0;
thetad = 0;
ptm = 0.3;


u_av = 11.08;

u_M = 2.5*u_av;


BDm = -100*ones(20,20);
Bm = -100*ones(20,20);
no_Detect = zeros(20,20);

delta = 0.1;
delta_2 = 3*ptm^2/4;

gamma = 5;
attack = 0;
last_attack = 0;
attack_start = attack_start0;
detect_start = 0;

attack_signal = zeros(num,1);
detect_signal = zeros(num,1);

for i = 1:num
    phi = x(7,i);
    theta = x(9,i);
    psi = x(11,i);
    
    cp = cos(phi);
    ct = cos(theta);
    cs = cos(psi);
    sp = sin(phi);
    st = sin(theta);
    ss = sin(psi);
    
    F = [x(2,i);
        0-kt*x(2,i);
        x(4,i);
        0-kt*x(4,i);
        x(6,i);
        g-kt*x(6,i);
        x(8,i)+x(10,i)*sp*tan(theta)+x(12,i)*cp*tan(theta);
        (Iy-Iz)/Ix*x(10,i)*x(12,i)-kr*x(8,i);
        x(10,i)*cp-x(12,i)*sp;
        (Iz-Ix)/Iy*x(8,i)*x(12,i)-kr*x(10,i);
        1/ct*(x(12,i)*cp+x(10,i)*sp);
        (Ix-Iy)/Iz*x(8,i)*x(10,i)-kr*x(12,i);
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

    
    G2 = [b  b  b  b;
        0  -b*l 0 b*l;
        -b*l 0 b*l 0;
        d   -d  d  -d];
    
    G = G1*G2;
    
    if i>10000
        if (i>last_attack+no_attack && attack == 0)
            attack = 1;

            if i == last_attack+no_attack+1 || i == 10001
                attack_start = i;
                last_attack = attack_start+attack_length;
            end
        end
    end
    
    if i>attack_start+attack_length
        attack = 0;
    end
    
    if i>1
        B1_old = B1;
        B2_old = B2;
        B3_old = B3;
    end
    
    B1 = x(5,i);
    B2 = x(7,i)^2-ptm^2;
    B3 = x(9,i)^2-ptm^2;

    if i>1
        B1d = (B1-B1_old)/dt;
        B2d = (B2-B2_old)/dt;
        B3d = (B3-B3_old)/dt;
    else
        B1d = 0;
        B2d = 0;
        B3d = 0;
    end
    
    if (i>1 && detect_signal(i-1) == 1 && i<detect_start+attack_length) || ((B1d>-delta*B1-5*dt && B1>-0.5) || (B2d>-delta*B2-5*dt && B2>-delta_2) || (B3d>-delta*B3-5*dt && B3>-delta_2)) %i<attack_start+detect_delay
        
        if i == 1
            u1 = zeros(7,1);
        end
        
        detect_signal(i) = 1;
        if detect_signal(i-1) == 0
            detect_start = i;
        end
        
        if attack>0
        u1 = input_assign_QP(x(:,i),xd,u1);
        u(:,i) = [u1(1);u1(2);u1(3);u4(i)];
        else
            u1 = input_assign_QP(x(:,i),xd,u1);
            u2 = input_assign_QP_no_attack(x(:,i),xd,u1);
            
             u(:,i) = [u1(1:3);u2(4)];
            
        end
    else
        if attack>0
            if i == 1
                u1 = zeros(6,1);
            end
            detect_signal(i) = 0;
            u1 = input_assign_QP_no_attack(x(:,i),xd,u1);
            u(:,i) = [u1(1:3,1);u4(i)];
        else
            if i == 1
                u1 = zeros(7,1);
            end
            detect_signal(i) = 0;
            
            u1 = input_assign_QP_no_attack(x(:,i),xd,u1);
            u(:,i) = u1(1:4);

        end
    end
    
    
    attack_signal(i) = attack;
    x(:,i+1) = x(:,i) + (F+G*u(:,i))*dt;
    if x(5,i+1)>0
        break
    end
end
