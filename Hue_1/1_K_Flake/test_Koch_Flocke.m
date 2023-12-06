% m-file: test_Koch_Flocke.m
%
% Erklärung
%
% Dieses m-file generiert mittels der Funktionen Koch_Flocke_fun und
% length_koch_fun eine Koch'schne Schneeflocke aus der in 'punkte'
% angegebenen Startgeometrie. Die Schneeflocke und ihre Länge wird
% graphisch ausgegeben. Mittels der Variable 'tiefe' kann die
% Berechnungstiefe festgelegt werden. Durch Ändern der Variable
% 'darstellung' kann das Darstellungsverhalten angepasst werden und somit
% zwischen einem gefüllten Polygon, der Darstellung als einzelne Punkte und
% einer animierten Darstellung gewählt werden. (Hinweis: Bei der animierten
% Darstellung ist die Berechnungstiefe auf 5 begrenzt)
% 
% Input:   
% Output:   Graphische Ausgabe einer Koch'schen Schneeflocke un ihrer Länge
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

% Länge berechnen
length = length_koch_fun(x,y);

% Plot generieren
figure;

% Text zur Angabe der Länge einfügen
annotation('textbox', [0 0 1 0.1], ...
    'String', ['Länge: ' num2str(length)], ...
    'EdgeColor', 'none')

% Punkte darstellen
switch darstellung
    case 1 % Darstellung als ausgefülltes Polygon
        fill(x,y,'b');

        % Länge und Skalierung der Achsen konfigurieren
        axis('equal', 'off', [-6 6 -3 9]);

    case 2 % Darstellung in Form von Punkten
        scatter(x,y);

        % Länge und Skalierung der Achsen konfigurieren
        axis('equal', 'off', [-6 6 -3 9]);

    case 3 % Animation
        f = fill(x,y,'b');

        % Länge und Skalierung der Achsen konfigurieren
        axis('equal', 'off', [-6 6 -3 9]);

        % Erster Durchlauf
        for i=1:100
            % Berechnen von x und y Werten
            x1= x + x.*(((5-1.6667) * i/200));
            y1= y + 2*((y - sqrt(75)) * i/100);
            
            % Aktualisieren der Werte
            f.XData = x1;
            f.YData = y1;

            % Plot neu zeichnen
            drawnow;
        end

        % Alle weiteren Durchläufe
        i=1;
        while true
            % Berechnen von x und y Werten
            x2= x1 + x1.*(((5-1.6667) * i/200));
            y2= y1 + 2*((y1 - sqrt(75)) * i/100);

            % Aktualisieren der Werte
            f.XData = x2;
            f.YData = y2;

            % Plot neu zeichnen
            drawnow;

            % Schleifenvariable erhöhen und zurücksetzen
            i = i + 1;
            if i>100
                i=1;
            end
        end
end







