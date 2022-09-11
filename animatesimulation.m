%% Cool simulator
tic
qm_matfilename = 'quad_starmac.mat';    %filename for the mat file for the quadrotor model
load(qm_matfilename);

qm_xyz0= qm_xyz;

axis_x_min = min(x)-1;
axis_x_max = max(x)+1;
axis_y_min = min(y)-1;
axis_y_max = max(y)+1;
axis_z_min = min(z)-1;
axis_z_max = max(z)+1;

if write_vid == 1
    writerObj = VideoWriter('quad_video_new_two_motors.avi');
    writeObj.Quality = 100;
    open(writerObj);
end

f = figure;
% set(gcf, 'Position', get(0, 'Screensize'));
set(gcf, 'Position', [100 100 1200 900]);
set(gcf, 'OuterPosition', [80 80 1220 920]);

clf;
tic
t_real = toc;


for t = 1:10:length(phi)-1
    
% for t = 2
    clf; hold on;
    legend('');
    plot3(0,0,0,'linestyle','none')
    plot3(0,0,0,'linestyle','none')
    %     plot3(sin(lambda),cos(lambda),(10+0*cos(lambda)), '--r','color','green','linewidth',1);
    %     hold on;
    
    %     plot3(x(1:t),y(1:t),z(1:t), 'r','color','red','linewidth',2);
    
    
%     plot3(x(t)+sin(theta(t))*cos(phi(t)),y(t)+sin(theta(t))*sin(phi(t)),z(t)+cos(theta(t)), 'r','color','red','linewidth',2);

    if max(abs(phi(t)),abs(theta(t)))<0.4
        qm_xyz(:,1:2) = 5*qm_xyz0(:,1:2);

        qm_xyz(:,3) = 1.2*qm_xyz0(:,3);
    else
        qm_xyz = 2*qm_xyz0;

%         qm_xyz(:,3) = 1.2*qm_xyz(:,3);
    end
    draw_quadrotor( qm_fnum, qm_xyz, phi(t), theta(t), ...
        psi(t), x(t), y(t), z(t),...
        [0.6 0.1 0.1],attack_vid(t));
    axis([axis_x_min-5, axis_x_max+2, axis_y_min-2, axis_y_max+10, axis_z_min, axis_z_max]);
    xlabel('$x(m)$','FontSize',16,'Interpreter','latex')
    ylabel('$y(m)$','FontSize',16,'Interpreter','latex')
    zlabel('$z(m)$','FontSize',16,'Interpreter','latex')
    set(gca, 'fontsize',30)
    view(-70,25);
    %adjust rendering style
    lighting phong;
    camlight right;
    %adjust graph viewing aspects
    grid on;
    axis square;
%     MyBox = uicontrol('style','text');
%     set(MyBox,'String','Here is a lot more information','size',30)
%     set(MyBox,'Position',[1000 700 100 50])
    str1 = ['Attack = ' num2str(attack_vid(t))];
    str2 = ['Detect = ' num2str(detect_vid(t))];
    legend(str1, str2,'location','northoutside','Orientation','horizontal')
    
%     if attack_vid(t) == 0 && detect_vid(t) == 0
%         legend('Attack = 0', 'Detect = 0','location','northoutside','Orientation','horizontal')
%     elseif attack_vid(t) == 0 && detect_vid(t) == 1
%         legend('Attack = 0', 'Detect = 1','location','northoutside','Orientation','horizontal')
%     elseif attack_vid(t) == 1 && detect_vid(t) == 0
%         legend('Attack = 1', 'Detect = 0','location','northoutside','Orientation','horizontal')
%     elseif attack_vid(t) == 2 && detect_vid(t) == 0
%         legend('Attack = 2', 'Detect = 0','location','northoutside','Orientation','horizontal')
%     elseif attack_vid(t) == 2 && detect_vid(t) == 1
%         legend('Attack = 2', 'Detect = 1','location','northoutside','Orientation','horizontal')
%     else
%         legend('Attack = 1', 'Detect = 1','location','northoutside','Orientation','horizontal')
%     end
    %%% Uncomment the following two lines to record the video!!
    frame = getframe(f);
    if write_vid == 1
        writeVideo(writerObj,frame);
    end
    drawnow;
    
end
if write_vid == 1
    close(writerObj);
end
toc