% m-file: fourier_series_fun_01.m
%
% Erklärung
%
% Diese Datei stellt die Funktion fourier_series_fun_01 bereit. 
% Diese Funktion berechnet die Fourierwerte mit den angegebenen
% Koeffizienten.
% 
% Input:    Koeffizienten und Parameter einer Fouriergleichung
% Output:   Berechnete Fourierwerte
%
% Beispiel:
%
% Autor   :	Leon Knauf
%
% Datum:    07.10.2023
%
% Änderung: 25.10.2023 - Überarbeitung nach Anmerkungen von H.Rumpf
%
% Benötigte eingene externe functions:
%
% siehe auch: 
%
%--------------------------------------------------------------------------         


function y = fourier_series_fun_01(a0,a,b,T,A,t)

% w0 berechnen
w_0 = 2*pi/T;

% Anzahl an Koeffizienten aus Matrixgröße von a ermitteln
N_koeff = size(a,2);

% Variable zur Auswahl des Lösungswegs
loesungsweg = 1; % 1: eigene Lösung; 2: Lösung aus Teilaufgabe 5

% Umschalten des Lösungswegs
switch loesungsweg

    case 1 % Eigene Lösung

        % Matrix für Werte für jeden Zeitwert t
        summs = zeros(1,size(t,2));

        % Matrix der Werte für jeden Koeffizienten zu einem Zeitwert
        sum_koeff = zeros(1,size(a,2));
        
        % Schleife über alle Zeitwerte
        for t_n=1:size(t,2)

            % Schleife über alle Koeffizienten
            for n=1:N_koeff
                
                % Berechnen des y Werts für einen Koeffizienten zu einem
                % Zeitwert
                sum_koeff(n) = a(n) * cos(n * w_0 * t(t_n)) + b(n) * sin(n * w_0 * t(t_n));
            end

            % Addieren der Werte für alle Koeffizienten zu einem Zeitwert
            summs(t_n) = sum(sum_koeff);
        end
        
        % Skalieren der Werte mit A und addieren von a0/2
        y = a0/2 + A .* summs;
        

    case 2 % Lösung aus Teilaufgabe 5

        % Fouriereihe berechnen mit Formel aus Teilaufgabe 5
        y = a0/2 + A * (a * cos(w_0*((1:N_koeff)'.*repmat(t,N_koeff,1))) +...
                        b * sin(w_0*((1:N_koeff)'.*repmat(t,N_koeff,1))));

        % Die Funktion repmat vervielfältigt die Zeilen aus der Matrix t.
        % Dies geschieht N_koeff mal. Dadurch lässt sich die neu gewonnene
        % Matrix elementweise mit der Matrix n, also 1:N_koeff,
        % multiplizieren. Dies bring den Vorteil, das keine Summenformeln
        % notwendig sind und auch die Matrizen a und b mittels
        % Matrixmultiplikation direkt verrechnet werden können. Durch diese
        % Multiplikation wird die Ergebnismatrix wieder eindimensional.


    otherwise % Rückgabe falls Variable loesungsweg ungleich 1 oder 2
        y = zeros(1,size(t,2));

end
