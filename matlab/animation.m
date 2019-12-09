function animation(data,goal)

    L = data.parameters(3);
    cla % Clear axes
    
    title('Animation')
    xlabel('Horizontal distance (m)')
    ylabel('Vertical distance (m)')

    axisrange = [-1.5 5 -1.5 1.5]; % [x_min x_max y_min y_max]
    axis equal
    time=0;
    p=[];
    c = [];
    step=0.05; % step size between frames [s]
    hold on
    plot([-2,10],[0,0],'k');
    if exist('goal','var')
        disp('goal exist');
        disp(goal);
        plot([goal,goal],[5,-5],'k');
    end
    tic
    last_round = false;
    while true
        if last_round
            break;
        elseif time>data.t(end)
            time=data.t(end);
            last_round = true;
        end
        q1=interp1(data.t,data.q(1,:),time);
		q2=interp1(data.t,data.q(2,:),time);
        processtime=toc;
        pause(step-processtime);
        tic
        
        	
        delete(p)
        delete(c)
        axis equal
        hold on
       
        p=plot([q1,q1+L*sin(q2)],...
            [0,-cos(q2)*L],'b','Linewidth',2);
        c = circle(q1+L*sin(q2),-cos(q2)*L,0.2,'r');

        axis(axisrange)
        drawnow
        time=time+step;
        
    end
    function p = circle(x,y,r,c)
        %x and y are the coordinates of the center of the circle
        %r is the radius of the circle
        %0.01 is the angle step, bigger values will draw the circle faster but
        %you might notice imperfections (not very smooth)
        ang=0:0.01:2*pi; 
        xp=r*cos(ang);
        yp=r*sin(ang);
        p = plot(x+xp,y+yp,c);
    end
end