function u_out = crane_MPC(t_remain,u_num,q_f,q_0, parameters,u_max,theta_max)
    
    
    u_out = rand(u_num,1).*u_max;
    % subjects the minimization to the nonlinear inequalities 
    % c(x) or equalities ceq(x) defined in nonlcon. fmincon optimizes 
    % such that c(x) ? 0 and ceq(x) = 0
    u_max_arr = u_max*ones(u_num,1);
    options.UseParallel = true;
    u_out = fmincon(@cost_function,u_out,[],[],[],[],-u_max_arr,u_max_arr,@nonlcon_fc,options );
    disp(nonlcon_fc(u_out));
  
    function [c,ceq] = nonlcon_fc(u)
        
        simdata = crane_model(u,q_0, parameters, t_remain);

        sol = simdata.sol;
        
        


        te = [sol.xe sol.x(end)];

        q_max = deval(sol,te);
        q_max_swing = max( max(q_max(2,:)), max(-q_max(2,:))) ;
        c = q_max_swing-theta_max;
        %disp(c)
        ceq = [];
    end
    function cost = cost_function(u)
        
        t_u = linspace(0,t_remain,u_num);
        simdata = crane_model(u,q_0, parameters, t_remain);
        q = simdata.q;
        %disp(size(q));
        sol = simdata.sol;
        tu = linspace(0,t_remain,u_num);
        xu = deval(sol,tu);
        gain = [1;1;0.75;0.1];
        cost = 0;

        for i = 2:u_num
        cost_i = ((xu(1,i)-q_f(1))*gain(1))^2 +...
                ((xu(2,i)-q_f(2))*gain(2))^2 +...
                ((xu(3,i)-q_f(3))*gain(3))^2 +...
                ((xu(4,i)-q_f(4))*gain(4))^2 ;
            cost = cost+cost_i;
        end

    end
end