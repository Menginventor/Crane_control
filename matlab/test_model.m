mc = 10;
ml = 20;
l = 1;
parameters = [mc, ml, l];
q_0 = [0; 0; 0; 0];

%simdata = crane_model([0 0],q_0, parameters, 10);
simdata = crane_model([0 100 0 -100 0 0],q_0, parameters, 2);
%figure(1)
hold on
plot(simdata.t,simdata.u)
plot(linspace(0,2,6),[0 100 0 -100 0 0],'or');
% figure(2)
% animation(simdata);
