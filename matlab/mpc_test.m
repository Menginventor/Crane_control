mc = 10;
ml = 20;
l = 1;
parameters = [mc, ml, l];

t_remain = 5;
u_num = 10;
q_f = [1;0;0;0];
q_0 = [0; 0; 0; 0];
u_max = 100;
theta_max = deg2rad(2);
%u_arr = crane_MPC(t_remain,u_num,q_f,q_0, parameters,u_max,theta_max);
simdata = crane_model(u_arr,q_0, parameters, t_remain);

figure(1)
hold on
plot(simdata.t,simdata.q(1,:),'r');
plot([simdata.t(1),simdata.t(end)],[q_f(1),q_f(1)],'k');
plot(simdata.t,simdata.u,'r');
figure(2)
plot(simdata.t,rad2deg(simdata.q(3,:)) ,'b');
figure(3)
hold on
plot(simdata.t,simdata.u ,'b');
plot(linspace(0,t_remain,u_num),u_arr ,'or');
figure(4)
hold on




plot(simdata.t,rad2deg(simdata.q(2,:)) ,'b');
sol = simdata.sol;
te = sol.xe;

q_max = deval(sol,te);
plot(te,rad2deg(q_max(2,:)) ,'or');
figure(5)
animation(simdata,q_f(1));

