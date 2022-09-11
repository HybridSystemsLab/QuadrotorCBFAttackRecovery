%%
% i = num;
time = 0:dt:i*dt;
figure

plot(time(1:i), x(5,1:i),'linewidth',4)
set(gca, 'fontsize',50)
hold on 
line([0 time(i)], [-5 -5],'color','k','linestyle','--','linewidth',4)
ylabel('$$z$$','interpreter','latex')
xlabel('$$t$$','interpreter','latex')


figure

subplot(2,1,1)
plot(time(1:i), x(7,1:i),'linewidth',4)
ylabel('$$\phi$$','interpreter','latex')
hold on
plot(0,0,'linewidth',4,'color','r')
plot(0,0,'linewidth',4,'color','k')
set(gca, 'fontsize',50)
set(gca, 'XTickLabel', [])

% legend('$$\phi$$','$$\theta$$','$$\psi$$','interpreter','latex')
subplot(2,1,2)
plot(time(1:i), x(9,1:i),'linewidth',4,'color','r')
set(gca, 'fontsize',50)
ylabel('$$\theta$$','interpreter','latex')
xlabel('$$t$$','interpreter','latex')

figure
subplot(4,1,1)
plot(time(1:i), u(1,1:i),'linewidth',4)
axis([0 time(i) 0 u_M])
hold on
plot(0,0,'linewidth',4,'color','m')
plot(0,0,'linewidth',4,'color','k')
plot(0,0,'linewidth',4,'color','g')
plot(0,0,'linewidth',4,'color','r')
set(gca, 'fontsize',50)
legend('$$u_1$$','$$u_2$$','$$u_3$$','$$u_4$$','$$u_a$$','interpreter','latex')
set(gca, 'XTickLabel', [])

subplot(4,1,2)
plot(time(1:i), u(2,1:i),'linewidth',4,'color','m')
axis([0 time(i) 0 u_M])
set(gca, 'fontsize',50)
hold on
Id = find(attack_signal==2);
plot(time(Id),u(2,Id),'linestyle','none','marker','o','color','r','markersize',2)
set(gca, 'XTickLabel', [])

subplot(4,1,3)
plot(time(1:i), u(3,1:i),'linewidth',4,'color','k')
axis([ 0 time(i) 0 u_M])
set(gca, 'fontsize',50)
set(gca, 'XTickLabel', [])

subplot(4,1,4)
plot(time(1:i), u(4,1:i),'linewidth',4,'color','g')
set(gca, 'fontsize',50)
axis([ 0 time(i) 0 u_M])
hold on
Id = find(attack_signal);
plot(time(Id),u(4,Id),'linestyle','none','marker','o','color','r','markersize',2)
xlabel('$$t$$','interpreter','latex')

figure
plot(time(1:i), attack_signal(1:i),'linewidth',4)
hold on
plot(time(1:i), detect_signal(1:i),'linewidth',4)
set(gca, 'fontsize',50)
legend('Attack Signal','Detection Signal','interpreter','latex')
xlabel('$$t$$','interpreter','latex')
x_data = x;


%%


x = x_data(:,1:10:i);
lambda = 0:0.01:2*pi;
write_vid = 0;

attack_vid = attack_signal(1:10:i);
detect_vid = detect_signal(1:10:i);

y = x(3,1:end-1);
z = -x(5,1:end-1);
phi = x(7,1:end-1);
theta = x(9,1:end-2);
psi = x(11,1:end-1);
x = x(1,1:end-1);

animatesimulation

plot3(x(:),y(:),z(:), 'r','color','b','linewidth',4);
x = x_data(:,1:i);

