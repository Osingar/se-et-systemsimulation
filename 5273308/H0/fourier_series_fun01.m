% m-file / function Name: fourier_series_fun01.m
%
% HUE 0
%
% Erklaerung 
%
% Es wird eine Funktion definiert, um die Fourier-Reihe einer periodischen Funktion ausschließlich mit Matrix-Operationen zu berechnen. 
% Es werden die Koeffizienten a0, a und b sowie die Periode T verwendet.
% Damit wird die Summe der harmonischen Schwingungen (Sinus- und Kosinusterme) für gegebene Zeitpunkte t berechnet. 
% Diese Summe wird als Ergebnis zurückgegeben.
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

function result = fourier_series_fun01(a0,a,b,T,A,t)
    omega0 = 2*pi / T;      % Frequenz
    N_koeff = size(a,2);    % Anzahl von Harmonischen
    sum_term = 0;           % Initialisierung für Summe

    % Berechnung der Summe gemaess Formel mit Matrix-Operationen
    result = a0/2 .+ A .* (a(n) .* cos(n .* omega0 .* t) + b(n) .* sin(n .* omega0 .* t));
    result = repmat(result,2,1);              % Duplikation, um generischen Plotter ohne IF-Statement verwenden zu koennen

end