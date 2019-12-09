%% var
syms xc(t) theta(t) u
%% param
syms l mc ml 
%%const
syms g
xp = xc + l*sin(theta);
yp = -l*cos(theta);
%% vel
xc_d = diff(xc,t);
xc_dd = diff(xc_d,t);
xp_d = diff(xp,t);
yp_d = diff(yp,t);
theta_d = diff(theta,t);
theta_dd = diff(theta_d,t);
%% Ep
Ep = ml*g*yp;
%% Ek
Ek = 0.5*mc*xc_d^2 + 0.5*ml*(xp_d^2 + yp_d^2);
E_total = Ep + Ek
Lagrange = Ek-Ep;
%% section 2 copy Lagrange above, change xc to q1, theta to q2
% (ml*((diff(xc(t), t) + l*cos(theta(t))*diff(theta(t), t))^2 + l^2*sin(theta(t))^2*diff(theta(t), t)^2))/2 + (mc*diff(xc(t), t)^2)/2 + g*l*ml*cos(theta(t))
syms q1_d q2_d q1 q2 q1_dd q2_dd
Lagrange2 = (ml*((q1_d + l*cos(q2)*q2_d)^2 + l^2*sin(q2)^2*q2_d^2))/2 + (mc*q1_d^2)/2 + g*l*ml*cos(q2);
% dLdq1_d = diff(Lagrange2,q1_d) % (ml*(2*q1_d + 2*l*q2_d*cos(q2)))/2 + mc*q1_d
% dLdq2_d = diff(Lagrange2,q2_d) % (ml*(2*l*cos(q2)*(q1_d + l*q2_d*cos(q2)) + 2*l^2*q2_d*sin(q2)^2))/2
% dLdq1 = diff(Lagrange2,q1) % = 0
% dLdq2 = diff(Lagrange2,q2) % =- (ml*(2*l*q2_d*sin(q2)*(q1_d + l*q2_d*cos(q2)) - 2*l^2*q2_d^2*cos(q2)*sin(q2)))/2 - g*l*ml*sin(q2)

%% section 3 , change variable back to do time derivertive
dLdq1_d = (ml*(2*xc_d + 2*l*theta_d*cos(theta)))/2 + mc*xc_d; 
dLdq2_d = (ml*(2*l*cos(theta)*(xc_d + l*theta_d*cos(theta)) + 2*l^2*theta_d*sin(theta)^2))/2;
%d_dt_dLdq1_d = diff(dLdq1_d,t) % mc*diff(xc(t), t, t) + (ml*(2*diff(xc(t), t, t) - 2*l*sin(theta(t))*diff(theta(t), t)^2 + 2*l*cos(theta(t))*diff(theta(t), t, t)))/2
%d_dt_dLdq2_d = diff(dLdq2_d,t) % (ml*(2*l^2*sin(theta(t))^2*diff(theta(t), t, t) + 2*l*cos(theta(t))*(diff(xc(t), t, t) - l*sin(theta(t))*diff(theta(t), t)^2 + l*cos(theta(t))*diff(theta(t), t, t)) - 2*l*sin(theta(t))*diff(theta(t), t)*(diff(xc(t), t) + l*cos(theta(t))*diff(theta(t), t)) + 4*l^2*cos(theta(t))*sin(theta(t))*diff(theta(t), t)^2))/2
 
%% section 4 change variable back
% d_dt_dLdq1_d =  mc*q1_dd + (ml*(2*q1_dd - 2*l*sin(q2)*q2_d^2 + 2*l*cos(q2)*q2_dd))/2
% d_dt_dLdq2_d =  (ml*(2*l^2*sin(q2)^2*q2_dd + 2*l*cos(q2)*(q1_dd - l*sin(q2)*q2_d^2 + l*cos(q2)*q2_dd) - 2*l*sin(q2)*q2_d*(q1_d + l*cos(q2)*q2_d) + 4*l^2*cos(q2)*sin(q2)*q2_d^2))/2
% 
% dLdq1 = 0; % = 0
% dLdq2  =- (ml*(2*l*q2_d*sin(q2)*(q1_d + l*q2_d*cos(q2)) - 2*l^2*q2_d^2*cos(q2)*sin(q2)))/2 - g*l*ml*sin(q2);
% 
% eqns = [d_dt_dLdq1_d - dLdq1 == u, d_dt_dLdq2_d - dLdq2 == 0];
% vars = [q1_dd q2_dd];
% S = solve(eqns,vars);
% S.q1_dd
% S.q2_dd