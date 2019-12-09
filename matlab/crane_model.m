function simdata = crane_model(u,q_0, parameters, t_remain)

    g = 9.81;
    mc = parameters(1);
    ml = parameters(2); 
    l = parameters(3);
    options = odeset('Events', @theta_d_zero);
    sol = ode45(@EoM,[0 t_remain],q_0,options);
    simdata.sol = sol;
    simdata.q = sol.y;
    simdata.t = sol.x;
    simdata.parameters = parameters;
    simdata.energy = energy(simdata.t,simdata.q);
    simdata.u = control_input(simdata.t);
    simdata.xu = control_input(simdata.t);
    function [position,isterminal,direction] = theta_d_zero(~,y)
        position = y(4);
        isterminal = 0;
        direction = 0;
        
    end
    function u_intrp = control_input(tq)
        if length(u) == 1
            u_intrp = u;
        else
            t_u = linspace(0,t_remain,length(u));
          
            %u_intrp = interp1(t_u,u,tq,'spline');
            u_intrp = pchip(t_u,u,tq);
            
        end
    end
    
    function dXdt = EoM(t,X)
        u_intrp = control_input(t);
        %q1 = X(1, 1);
        q2 = X(2, 1);
        q1_d = X(3, 1);
        q2_d = X(4, 1);
         
        q1_dd = (l*ml*q2_d^2*cos(q2)^2*sin(q2) + l*ml*q2_d^2*sin(q2)^3 + u_intrp*cos(q2)^2 ...
         + g*ml*cos(q2)*sin(q2) + u_intrp*sin(q2)^2)/(mc*cos(q2)^2 + mc*sin(q2)^2 ...
         + ml*sin(q2)^2);
        q2_dd =  -(l*ml*cos(q2)*sin(q2)*q2_d^2 + u_intrp*cos(q2) + g*mc*sin(q2) + g*ml*sin(q2))/(l*mc*cos(q2)^2 + l*mc*sin(q2)^2 + l*ml*sin(q2)^2);
        dXdt(1,1) = q1_d;
        dXdt(2,1) = q2_d;
        dXdt(3,1) = q1_dd;
        dXdt(4,1) = q2_dd;

    end
    function E = energy(t,X)
        E = zeros(length(t),1);
        for i = 1:length(t)
            q2 = X(2,i);
            q1_d = X(3,i);
            q2_d = X(4,i);
            E(i,1) = (ml*((q1_d + l*cos(q2)*q2_d)^2 + l^2*sin(q2)^2*q2_d^2))/2 + (mc*q1_d^2)/2 - g*l*ml*cos(q2) ;
        end
    end
end