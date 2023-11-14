% m-file / function Name: length_koch_fun.m
%
% HUE 1
%
% Erklaerung 
%
% Basierend auf den x & y Koordinaten der Koch-Kurve wird der Gesamtumfang mittels Satz des Pythagoras berechnet
%
% Eingabe:  x & y Koordinaten    
% Ausgabe: 	Umfang U
%	
% Autor:	Marvin Mueller (5273308)
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation WS 2023/2024 erstellt.
%
% Datum:    14-11-2023
%
% Änderung: xxx
%
% Benötigte eingene externe functions: test_Koch_Flocke.m
%
% siehe auch: xxx
%--------------------------------------------------------------------------

function perimeter = length_koch_fun(x,y)

    perimeter = 0;                              % Variable initialisieren

    for i = 1:numel(x)-1                       % Schleife für alle Punkte bis auf den Letzten
        perimeter = perimeter + sqrt((x(i)-x(i+1))^2+(y(i)-y(i+1))^2);  % Berechnung Abstand aktuellem und nächstem Punkt und Aufsummierung
    end

end