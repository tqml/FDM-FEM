N = 99; % Stützstellen - 1
x0 = 0; % Intervall a-b
xend = 10;
h = (xend-x0) / N;
x = (x0:h:xend)';
N = N+1;
f = zeros(N,1);



mu0 = 4*pi*10^(-7);
eps0 = 8.85*10^(-12);

%mu0 = 1;
%eps0 = 1;

f(1) = 0;
f(N) = 0;

M = sparse(1:N,1:N,4) + sparse(1:N-1,2:N,1,N,N)+ sparse(2:N,1:N-1,1,N,N);
S = sparse(1:N,1:N,2) + sparse(1:N-1,2:N,-1,N,N) + sparse(2:N,1:N-1,-1,N,N);
C = sparse(1:N,1:N,0);
%%
S(N,N) = 1;
M(N,N) = 2;
S = 1/h * S;
M = mu0*eps0*h/6*M;
C(N,N) = sqrt(mu0*eps0); % du/dt = 0 

%C(1,1) = sqrt(mu0*eps0);



%% Newmark Zeitschrittverfahren

% Anfangsbedingungen
k = 1/2;
u = exp(-k*(2*x-x0-xend).^2);
v = zeros(N,1); 
a = M\(f-S*u-C*v); % calculate initial a

% Zeitschritte
dt = 1/2 * h * sqrt(mu0*eps0);

gamma = 1/2;
beta = 1/4;

% Time Loop
max_time_steps = 340;
U = zeros(length(u),max_time_steps);

for i = 1:max_time_steps
    
    U(:,i) = u;
    
    A = (M + gamma*dt* C + beta* dt^2 * S);
    f_ = f - C * (v+(1-gamma)*dt*a) - S * (u + dt*v+ (dt^2)/2 * (1-2*beta)*a);

    a_ = A \ f_;

    v_ = v + dt*( (1-gamma)* a + gamma*a_ );
    u_ = u + dt*v + dt^2/2 * ((1/2-beta)*a + beta*a_);
    
    u = u_;
    v = v_;
    a = a_;
    
end


%% Plot Data
t = 0:dt:dt*(size(U,2)-1);
surf(t,x,U,'EdgeAlpha',0.3)
set(gca,'FontSize',14);
xlabel('Zeit t');
ylabel('Ort x');
print('wave.png','-dpng','-r300')

%%
makeMovie(U,x,x0,xend);
