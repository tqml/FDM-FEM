%% Analytisches Lösen
N = 3; % Stüzstellen
r_start = 1;
r_end = 5;

h = (r_end - r_start) / (N+1); % Schrittweite
% r: Stützstellen an denen u(r) gesucht wird
r = (r_start+h:h:r_end-h)';
Q = 3.445e-9;  % ergibt sich aus Randwerten
eps0 = 8.85e-12; 

% Lösung: U = Vr - V0
% -> Vr = V0 + U
U =  Q/(2*pi*eps0) * log(r/r_start);
V0 = Q/(2*pi*eps0) * log(r_start/r_start); % = 0

V1 = V0 + U; % formale Lösung
V = 62.13349 * log(r) ;

%% Numerische Berechnung
% (spärliche) Matrizen anlegen
A = sparse(2:N,1:N-1,-1,N,N)+ ...
    sparse(1:N-1,2:N,1,N,N);
B = sparse(1:N,1:N,-2) + ...
    sparse(2:N,1:N-1,1,N,N)+ ...
    sparse(1:N-1,2:N,1,N,N);
b = sparse(1:N,1,0);

A = 1/(2*h) * (1./r) .*  A;
B = (1/h)^2 * B;

% Randbedingungen
b(1) = 0; 
b(N) = -100 * 1/(2*h) * 1/r(N) - 100 * (1/h)^2;

% Au + Bu = b
% -> (A+B)u = Cu = b
% -> b =inv(C)*b

% Matlab nutzt automatisch ein geeignetes Lösungsverfahren
C = A+B;
Vnum = C \ b ;

%% Hinzufügen der Randwerte zum Lösungsvektor
V = [0; V(:); 100]';
Vnum = [0; Vnum(:); 100]';
r = [1;r;5]';
%% Vergleichen
figure()
plot(r,V,r,Vnum);
legend('Analytische Lösung', 'Numerische Lösung', ...
    'Location','southeast');
xlabel('Radius r'); ylabel('Potential V'); grid on;
set(gca, 'FontSize', 18);
print('cylinder.png','-dpng','-r300');

figure()
plot(r,abs((Vnum-V)./V*100), r, abs(Vnum-V));
xlabel('Radius r'); ylabel('Fehler'); grid on;
legend('Relativer Fehler [%]', 'Absoluter Fehler',...
    'Location','northeast');
set(gca, 'FontSize', 18);
print('error.png','-dpng','-r300');