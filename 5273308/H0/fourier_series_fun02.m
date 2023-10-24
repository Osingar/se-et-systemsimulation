% m-file / function Name: fourier_series_fun02.m
%
% HUE 0
%
% Erklaerung 
%
% Es wird eine Funktion zur Berechnung der Fourier-Reihe eines periodischen Signals definiert. 
% Je nach Eingabeparametern kann die Funktion die Fourierreihe berechnen um sie dann entweder als Gesamt-Funktion oder Funktion aller Harmonischen oder aller Teilsummen darstellen zu koennen.
% Die berechnete Fourier-Reihen-Funktion wird als Ausgabe zurückgegeben
%
% Eingabe:  Vektor mit Fourier-Koeffizienten, Faktor A, Periodendauer T und
% Argument t
%                  
% Ausgabe: 	Berechnete Zeitwerte der Fourier-Reihe
%	
% Autor:	Marvin Mueller (5273308)
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation WS 2023/2024 erstellt.
%
% Datum:    19-10-2023
%
% Änderung: xxx
%
% Benötigte eingene externe functions: test_fourier.m
%
% siehe auch: xxx
%--------------------------------------------------------------------------
%close all;  % Alle plots schliessen
%clearvars;  % workspace loeschen

% Relevant fuer Aufgabenteil 4

function y = fourier_series_fun02(a0,a,b,T,A,t,opt)
    switch nargin   % Switch Case Mit/Ohne Display Option
      
        case 7      % 7 Commands: Mit Display Option 
            omega0 = 2*pi / T;      % Frequenz
            N_koeff = size(a,2);    % Anzahl von Harmonischen
            n = 1:N_koeff;          % Vektor mit n=1,2,3,... 
                
            % Phi für alle Koeffizienten ermitteln (gemaess Aufgabenteil 5)
            Phi = omega0*(n'.*repmat(t,N_koeff,1));
        
            % Leere Speicher-Matrix initialisieren
            y_pre = zeros(2*N_koeff,size(t,2));
        
            % Werte für alle Koeffizienten bilden, abwechselnd in y schreiben um generischen Plotter in Hauptcode benutzen zu koennen
            y_pre(1:2:end,:) = A.* (a'.*cos(Phi));
            y_pre(2:2:end,:) = A.* (b'.*sin(Phi));

            switch opt
                
                case 0      % 0: kein plot
                    y = zeros(1,size(y_pre,2));   % Einzelne Reihe, bestehend aus Nullen, zurückgeben
                    y = repmat(y,2,1);            % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen
                
                case 1      % 1: nur die Funktion f(t) darstellen
                    y = a0/2 + sum(y_pre,1);    % Hinzuaddieren von a0/2
                    y = repmat(y,2,1);          % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen
                
                
                case 2      % 2: alle harmonischen in einem plot
                    y = y_pre;                  % keine weiteren Schritte noetig
                
                
                case 3      % 3: alle Teilsummen in einem plot
                    % Anzahl an Teilsummen auf 10% (gerundet) der Anzahl an Koeffizienten setzen
                    num_teilsummen = round(N_koeff/10);
                    % Kumulative Summe aus den ersten Werten der definierten Anzahl an Teilsummen berechnen
                    summs = cumsum(y_pre);
                    % Nur jeden 2ten Eintrag für y nutzen, da sin und cos eigene Zeilen sind
                    y = summs(2:2:2*num_teilsummen,:);
                
                
                otherwise      % 0: kein plot
                    y = zeros(1,size(y_pre,2));     % Einzelne Reihe, bestehend aus Nullen, zurückgeben
                    y = repmat(y,2,1);              % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen
            
            
            end
        
        
        case 6      % 6 Commands: Ohne Display Option
            omega0 = 2*pi / T;      % Frequenz
            N_koeff = size(a,2);    % Anzahl von Harmonischen
            n = 1:N_koeff;          % Vektor mit n=1,2,3,...

            % Berechnung der Summe gemaess Formel mit Matrix-Operationen
            y = a0/2.+A.*(a * cos(n'.*omega0.*repmat(t,N_koeff,1)) + b * sin(n'.*omega0.*repmat(t,N_koeff,1)));
            y = repmat(y,2,1);              % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen
        
        otherwise
            disp("Case nicht definiert");
            disp("Nicht-richtige Anzahl an Inputs für die Funktion fourier_series_fun02!");
            y = zeros(1,size(y_pre,2));     % Einzelne Reihe, bestehend aus Nullen, zurückgeben
            y = repmat(y,2,1);              % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen

    end
end