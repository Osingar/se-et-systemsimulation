% m-file / function Name: Koch_Flocke_fun.m
%
% HUE 1
%
% Erklaerung 
%
% Basierend auf anfänglichen Punkten der Grundform und einer vorgebenen Iterationstiefe werden die x & y Koordinaten zur Darstellung der Koch-Kurve berechnet
%
% Eingabe:  Punkte und Tiefe    
% Ausgabe: 	x & y Koordinaten
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

function [x,y]=Koch_Flocke_fun(punkte, tiefe)

    [~, n2] = size(punkte);                     % Bestimmung Anzahl Punkte durch Anzahl der Spalten der Ursprungs-Matrix
    p = n2-1;                                   % Bestimmung der Punkte (hier: 3)
    l = 4^tiefe;                                % Formel zur Bestimmung der Teilstrecken
    n = p*l+1;                                  % Formel zur Bestimmung der Anzahl der Punkte
    x = zeros(n,1);                             % 0-Array fuer die x-Koordinaten initialisieren
    y = zeros(n,1);                             % 0-Array fuer die y-Koordinate initialisieren
    
    for i=0:p                                   % Befuellen der x- & y-Koordinate mit den festgelegten/uebergebenen Punkte des Grunddreiecks
        x(i*l+1) = punkte(1,i+1);               
        y(i*l+1) = punkte(2,i+1);               
    end
    
    for i=1:tiefe                               % Berechnung der Iterationstiefe beginnend ab der 1. Iterationstiefe
        l=round(l/4);                           % Definition des jeweils einen Teilabschnittes
        for j=0:p-1                             % Berechnung der jeweiligen Konstruktionsschritte/Streckenzuege
            % Indizes
            k0 = j*4*l+1;                       % -|
            k1 = k0+l;                          %  |
            k2 = k0+2*l;                        %  |> Konstruktionsschritte
            k3 = k0+3*l;                        %  |
            k4 = (j+1)*4*l+1;                   % -|
        
            x(k1)=x(k0)+(x(k4)-x(k0))/3;                            % -|
            y(k1)=y(k0)+(y(k4)-y(k0))/3;                            %  |
            x(k3)=x(k4)-(x(k4)-x(k0))/3;                            %  |
            y(k3)=y(k4)-(y(k4)-y(k0))/3;                            %  |> Position der Streckenzuege (inkl. Spitzen)
            x(k2)=x(k1)+(x(k3)-x(k1))/2+sqrt(3)*(y(k1)-y(k3))/2;    %  |
            y(k2)=y(k1)+(y(k3)-y(k1))/2+sqrt(3)*(x(k3)-x(k1))/2;    % -|
        end
        p=p*4;                                  % Erweiterung der verwendeten Punkte pro Iterationstiefe
    end
end