%% Analytisches L?sen
N = 3; % Stüzstellen
r_start = 1;
r_end = 5;

h = (r_end - r_start) / (N+1); % Schrittweite
% r: Stützstellen an denen u(r) gesucht wird
r = (r_start+h:h:r_end-h)';

% U = C_1 log(r) + C_2
V = 62.13349 * log(r) ;

%% Numerische Berechnung
% (sp?rliche) Matrizen anlegen (bessere performance, da Matrizen
% sowieso aus fast nur 0en bestehen

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

% Matlab nutzt automatisch ein geeignetes L?sungsverfahren
C = A+B;
Vnum = C \ b ;

%% Hinzuf?gen der Randwerte zum L?sungsvektor
V = [0; V(:); 100]';
Vnum = [0; Vnum(:); 100]';
r = [1;r;5]';
%% Vergleichen
figure()
plot(r,V,r,Vnum);
legend('Analytische L?sung', 'Numerische L?sung', ...
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
