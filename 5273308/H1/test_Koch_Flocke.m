% m-file: test_Koch_Flocke.m
%
% HUE 1
%
% Erklaerung
%
% Bestimmung der x- und y-Koordinaten der jeweiligen Iterationstiefe
% 
% Input:    Uebergabeparameter punkte und tiefe
% Output:   x und y (Koordinaten)
%
% Autor   :	Marvin Mueller (5273308)
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation WS 2023/2024 erstellt.
%
% Datum:    14-11-2023
%
% Aenderung: xxx
%
% Benoetigte eigene externe functions: Koch_Flocke_fun.m
% Benoetigte eigene externe functions: length_koch_fun.m
%
% siehe auch: xxx
%
%--------------------------------------------------------------------------         

close all;                                  % Noch geoeffnete Plots schließen
clearvars;                                  % Variablenspeicher leeren

% Aufgabe 1 & 2

punkte = [-5 0 5 -5; 0 sqrt(75) 0 0];       % Definition der Startpunkte(x,y)
tiefe=7;                                    % Definition Iterationstiefe

[x,y] = Koch_Flocke_fun(punkte, tiefe);     % Funktion aufrufen --> Berchnung x und y
figure;                                     % Plot generieren
fill(x,y,'b');                              % Fuellen des 2-D Polygon in blau
title('Koch^{,}sche Schneeflocke');         % Titel
axis('equal', 'off')                        % Achsen-Konfiguration:
                                            % -> equal = Seitenverhaeltnis von x und y gleich anpassen
                                            % -> off = Achsenbeschriftung ausblenden

U = length_koch_fun(x,y);                   % Funktion aufrufen -> Berechnung des Umfangs

%txt = {'Umfang:' num2str(U)};               % Definition Anzeigetext für Umfang der Flocke
%text(-8,-3,txt, 'FontSize',14)              % Darstellung Umfang-Information auf Plot
annotation('textbox', [0 0 1 0.1], 'String', ['Umfang: ' num2str(U)], 'EdgeColor', 'none')  % Darstellung Umfang-Information auf Plot

disp('Umfang: ')                            % Beschriftung der Ausgabe fuer den Umfang
disp(U);                                    % Darstellung des Umfangs in Abhaengigkeit der Iterationstiefe


% Aufgabe 3:
tiefe_max = 7;                              % max. Iterationstiefe
u=zeros(tiefe_max+1,1);                     % Anlegen eines Arrays fuer die Umfaenge (je Iterationstiefe)
i=zeros(tiefe_max,1);                       % Anlegen der Iterationstiefe, da mit 0 gestartet wird


for j = 0:tiefe_max                         % Berechnung Umfang fuer jede Iterationstiefe
    [x,y] = Koch_Flocke_fun(punkte,j);      % Funktion aufrufen -> Berechnung x und y
    U = length_koch_fun(x,y);               % Funktion aufrufen -> Berechnung des Umfangs
    u(j+1) = U;                             % Array mit den errechneten Umfangwerten fuellen
    i(j+1) = j;                             % Array fuer die Iterationstiefe anlegen (beginnend mit 0)
end

figure;                                     % Plot generieren
stem(i,u);                                  % Darstellung von u(i) -> Umfang in Abhaengigkeit der Iterationstiefe
title('Koch^{,}sche Schneeflocke');         % Titel
xlabel('Iterationstiefe');                  % Beschriftung x-Achse
ylabel('Umfang');                           % Beschriftung y-Achse