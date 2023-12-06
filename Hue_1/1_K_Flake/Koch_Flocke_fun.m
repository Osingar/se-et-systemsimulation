% m-file: Koch_Flocke_fun.m
%
% Erklärung
%
% Diese Funktion berechnet die Punkte einer Kochschen Schneeflocke mittels
% rekursiver Aufrufe.
% 
% Input:    punkte: Matrix bestehend aus x und y Werten der Punkte
%           maxtiefe: maximale Tiefe der Rekursion
%           tiefe: optional, wird nur ab dem ersten rekursiven Aufruf
%                  benötigt.
% Output:   x,y: Punkte der bis Maxtiefe ausgerechneten Koch'schen
%                Schneeflocke.
%
% Beispiel: punkte=[-5 0 5 -5;  0 sqrt(75) 0 0];
%           tiefe=7;        
%           Koch_Flocke_fun(punkte, tiefe) 
%
% Autor   :	Leon Knauf
%
% Datum:    26.10.2023
%
% Änderung: 
%
% Benötigte eigene externe functions:
%
% siehe auch: 
%
%--------------------------------------------------------------------------  

function [x,y]=Koch_Flocke_fun(punkte, maxtiefe, tiefe)

% Anzahl der Argumente prüfen, bei weniger als 3 Argumenten muss dies die
% erste Instanz der Funktion sein. Also muss die Starttiefe gesetzt werden.
if (nargin() < 3)
    tiefe = 1;
end

% Anzahl aktueller Punkte bestimmen
num_punkte = size(punkte,2);

% Anzahl Punkte der Grundgeometrie setzen
num_startpunkte = 4;

% Anzahl neuer Punkte bestimmen
num_neue_punkte = num_startpunkte * (num_punkte - 1) + 1;

% Matrix für neue Punkte anlegen
neue_punkte = zeros(2,num_neue_punkte);

% Alle bestehenden Punkte durchlaufen
for i=1:num_punkte

    % Neuen Index bestimmen
    idx = (i-1)*(num_startpunkte-1)+i;

    % Punkt in die neue Matrix kopieren
    neue_punkte(:,idx) = punkte(:,i);

    % Für den letzten Punkt keine neuen Punkte mehr generieren
    if i<num_punkte

        % Ersten neuen Punkt berechnen
        p1 = punkte(:,i) + (punkte(:,i+1) - punkte(:,i))/3;
        
        % Letzten neuen Punkt berechnen
        p3 = punkte(:,i+1) - (punkte(:,i+1) - punkte(:,i))/3;
        
        % Mittleren neuen Punkt berechnen
        p2 = [0;0];
        p2(1) = p1(1) + (p3(1) - p1(1)) / 2+sqrt(3) * (p1(2) - p3(2))/2;
        p2(2) = p1(2) + (p3(2) - p1(2)) / 2+sqrt(3) * (p3(1) - p1(1))/2;

        % Neue Punkte in Matrix eintragen
        neue_punkte(:,idx+1) = p1;
        neue_punkte(:,idx+2) = p2;
        neue_punkte(:,idx+3) = p3;
    end
end

% Abbruchbedingung der Rekursion
if tiefe < maxtiefe

    % Funktion erneut mit nächster Tiefe aufrufen
    [x,y] = Koch_Flocke_fun(neue_punkte,maxtiefe,tiefe+1);
else

    % Maxmiale Tiefe erreicht, Punkte zurückgeben
    x = neue_punkte(1,:);
    y = neue_punkte(2,:);
end

end

