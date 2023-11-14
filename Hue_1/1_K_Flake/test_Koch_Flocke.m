% m-file: test_Koch_Flocke.m
%
% Erklärung
%
% 
% 
% Input:   
% Output:   Graphische Ausgabe und Länge einer Koch'schen Schneeflocke
%
% Beispiel:
%
% Autor   :	Leon Knauf
%
% Datum:    26.10.2023
%
% Änderung: 
%
% Benötigte eigene externe functions: Koch_Flocke_fun.m, length_koch_fun.m
%
% siehe auch: 
%
%--------------------------------------------------------------------------  


% Noch geöffnete Plots schließen
close all;

% Variablenspeicher leeren
clearvars;

% Darstellverhalten einstellen
darstellung = 3;    % 1: Darstellung als ausgefülltes Polygon, 
                    %    rechenintensiver, nicht zu empfehlen für tiefe > 10
                    % 2: Darstellung durch einzelne Punkte, schneller und 
                    %    auch für tiefen > 10 geeignet
                    % 3: Animation

% Maximale Tiefe definieren
tiefe = 7;

% Bei Animation Tiefe auf 5 begrenzen
if darstellung == 3 && tiefe > 5
    tiefe = 5;
end

% Startpunkte definieren
punkte=[-5 0 5 -5;  0 sqrt(75) 0 0];

% Punkte der Kochschen Flocke berechnen
[x,y] = Koch_Flocke_fun(punkte, tiefe);

% Länge berechnen und ausgeben
length = length_koch_fun(x,y);

% Plot generieren
figure;

% Achsen konfigurieren
% axis('equal','off');

annotation('textbox', [0 0 1 0.1], ...
    'String', ['Länge: ' num2str(length)], ...
    'EdgeColor', 'none')

% Punkte darstellen
switch darstellung
    case 1 % Darstellung als ausgefülltes Polygon
        fill(x,y,'b');
        axis('equal', 'off', [-6 6 -3 9]);

    case 2 % Darstellung in Form von Punkten
        scatter(x,y);
        axis('equal', 'off', [-6 6 -3 9]);

    case 3 % Animation
        f = fill(x,y,'b');
        axis('equal', 'off', [-6 6 -3 9]);

        for i=1:100
            x1= x + x.*(((5-1.6667) * i/200));
            y1= y + 2*((y - sqrt(75)) * i/100);
            f.XData = x1;
            f.YData = y1;
            drawnow;
        end

        i=1;
        while true
            x2= x1 + x1.*(((5-1.6667) * i/200));
            y2= y1 + 2*((y1 - sqrt(75)) * i/100);
            f.XData = x2;
            f.YData = y2;
            drawnow;
            i = i + 1;
            if i>100
                i=1;
            end
        end
end







