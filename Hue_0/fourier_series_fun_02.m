% m-file: fourier_series_fun_02.m
%
% Erklärung
%
% Diese Datei stellt die Funktion fourier_series_fun_02 bereit. 
% Diese Funktion berechnet die Fourierwerte mit den angegebenen
% Koeffizienten. Optional kann mittels eines Parameters zwischen der
% berechnung der Fourierreihe, aller Harmonischen oder den Teilsummen
% gewählt werden. Diese Funktion verwendet dabei keine Schleifen.
% 
% Input:    Koeffizienten und Parameter einer Fouriergleichung, Auswahl der
% Berechnungsoption
% Output:   Berechnete Fourierwerte
%
% Beispiel:
%
% Autor   :	Leon Knauf
%
% Datum:    19.10.2023
%
% Änderung: 25.10.2023 - Überarbeitung nach Anmerkungen von H.Rumpf
%
% Benötigte eigene externe functions: fourier_series_fun_01
%
% siehe auch: 
%
%--------------------------------------------------------------------------         


function y = fourier_series_fun_02(a0,a,b,T,A,t,opt)

% Variable zur Auswahl des Lösungswegs (nur bei Option 2 und 3)
loesungsweg = 2; % 1: mit Schleifen, 2: ohne Schleifen

% Standardverhalten definieren, falls keine Option angegeben
if nargin() < 7
    opt = 4; % Fourierreihe berechnen
end

% w0 berechnen
w_0 = (2*pi)/T;

% Anzahl an Koeffizienten aus Matrixgröße von a ermitteln
N_koeff = size(a,2);


switch opt
    case 0 % Kein plot

        % Einzelne Reihe, bestehend aus Nullen, zurückgeben
        y = zeros(1,size(t,2));


    case 1 % nur die Funktion f(t) darstellen

        % Alle Harmonischen bestimmen
        summs = fourier_series_fun_02(a0,a,b,T,A,t,2);

        % Werte für alle Koeffizienten summieren und a0/2 addieren
        y = a0/2 + sum(summs,1);


    case 2 % alle harmonischen in einem plot

        % Umschalten des Lösungswegs
        switch loesungsweg

            case 1 % Lösung mit Schleifen
                % Matrix für y mit Nullen initialisieren
                y = zeros(N_koeff,size(t,2));

                % Schleife über alle Koeffizienten
                for n=1:N_koeff
                    % Werte für Koeffizient n bilden, abwechselnd in y schreiben
                    y((2*n)-1,:) = A.*(a(n) .* cos(n .* w_0 .* t));
                    y(2*n,:) = A.*(b(n) .* sin(n .* w_0 .* t));
                end

            case 2 % Lösung ohne Schleifen
                % Phi für alle Koeffizienten ermitteln (aus Aufgabenteil 5)
                Phi = w_0*((1:N_koeff)'.*repmat(t,N_koeff,1));
        
                % Leere Matrix initialisieren
                y = zeros(2*N_koeff,size(t,2));
        
                % Werte für alle Koeffizienten bilden, abwechselnd in y schreiben
                y(1:2:end,:) = A.* (a'.*cos(Phi));
                y(2:2:end,:) = A.* (b'.*sin(Phi));

            otherwise % Rückgabe falls Variable loesungsweg ungleich 1 oder 2
                y = zeros(1,size(t,2));
        end


    case 3 % alle Teilsummen in einem plot
        
        % Anzahl an Teilsummen auf 10% der Anzahl an Koeffizienten setzen
        % (gerundet)
        num_teilsummen = round(N_koeff/10);

        % Umschalten des Lösungswegs
        switch loesungsweg

            case 1 % Lösung mit Schleifen

                % Matrix für y mit Nullen initialisieren
                y = zeros(num_teilsummen,size(t,2));

                % Schleife über Koeff bis Anzahl Teilsummen erreicht
                for n=1:num_teilsummen
                    % Berechnen des Wertes für einen Koeffizienten
                    y(n,:) = A .* (a(n) .* cos(n .* w_0 .* t) + b(n) .* sin(n .* w_0 .* t));

                    % Ab der Zweiten Teilsummen vorherige addieren, um
                    % kumulative Summe zu erhalten.
                    if n>1
                        y(n,:) = y(n,:) + y(n-1,:);
                    end
                end


            case 2 % Lösung ohne Schleifen
                % Alle Harmonischen bestimmen um daraus Teilsummen zu ermitteln
                harmonische = fourier_series_fun_02(a0,a,b,T,A,t,2);

                % Kumulative Summe aus den ersten Werten der definierten Anzahl
                % an Teilsummen berechnen
                summs = cumsum(harmonische);
                
                % Nur jeden 2ten Wert nutzen, da sin und cos eigene Zeilen sind
                y = summs(2:2:2*num_teilsummen,:);

            otherwise % Rückgabe falls Variable loesungsweg ungleich 1 oder 2
                y = zeros(1,size(t,2));
        end


    case 4 % Nutze fourier_series_fun_01

        % y mittels der zuvor entwickelten Funktion berechnen
        y = fourier_series_fun_01(a0,a,b,T,A,t);
       

    otherwise % Kein plot

        % Einzelne Reihe, bestehend aus Nullen, zurückgeben
        y = zeros(1,size(t,2));
end


