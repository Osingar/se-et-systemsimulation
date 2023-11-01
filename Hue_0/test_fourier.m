% m-file: test_fourier.m
%
% Erklärung
%
% Es werden die reellen Fourier-Koeffizienten verschiedener bekannten
% Fourier-Reihe berechnet und die zugehörige Zeitfunktion, die Harmonischen
% oder die Teilsummen dargestellt.Die Berechnung der Werte erfolgt mittels 
% der externen function fourier_series_fun_02.m
% Außerdem wird das reelle Amplitudenspektrum dargestellt.
% Über die Variable 'Beispiel' kann die zu berechnenden Funktion ausgewählt
% werden. Mittels der 'Option' Variablen kann die anzuzeigende Kurve
% ausgewählt werden.
%
% 
% Input:    Werte werden direkt in diesem File zugewiesen
% Output:   Grafik-Ausgabe in diesem File
%
% Beispiel: 
%
% Autor   :	Leon Knauf
%
% Datum:    19.10.2023
%
% Änderung: 25.10.2023 - Überarbeitung nach Anmerkungen von H.Rumpf
%
% Benötigte eigene externe functions: fourier_series_02.m
%
% siehe auch: 
%
%--------------------------------------------------------------------------         

close all;      % Noch offene plots schließen
clearvars;      % Variablenspeicher leeren

% Grundwerte für die Fourier-Gleichung
N_koeff=100;    % Anzahl Fourier Koeffizienten 
T=2*pi;         % Periodendauer 
n=1:N_koeff;    % Vektor mit n=1,2,3,.. 

% Zeitwerte für die periodische Funktion 
N_werte=400;    % Anzahl der zu berechnenden Funktionswerte 
t_start=0;      % Startwert 
t_ende=4*pi;    % Endwert 

% Werte für die Amplitudenberechnung
N_C = 12;       % Anzahl an Spektrumswerten

% Verschiedene Fourier Reihen
Beispiel = 5;   % 1: Rechteck ungerade
                % 2: Sägezahn
                % 3: 2 Wege-Gleichrichtung
                % 4: 1 Weg-Gleichrichtung
                % 5: e-Funktion

% Ausgabeoptionen
Option = 3;     % 1: Funktion f(t)
                % 2: Alle Harmonischen
                % 3: Alle Teilsummen
                % 4: f(t) mittels fourier_series_fun_01

switch Beispiel

    case 1 % Rechteck ungerade

        A=4/pi;                     % Faktor für die Summe 
        a0=0;                       % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=(1./n) .* (rem(n,2)~=0);  % Sinus Fourier-Koeffizienten 
        
        plot_title = "Rechteck ungerade";

    case 2 % Sägezahn

        A=-1/pi;                    % Faktor für die Summe 
        a0=1;                       % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=1./n;                     % Sinus Fourier-Koeffizienten

        plot_title = "Sägezahn";

    case 3 % 2 Wege-Gleichrichtung

        A=4/pi;                                 % Faktor für die Summe 
        a0=4/pi;                                % Doppelter Mittelwert
        a = (-1)./(n.^2.-1) .* (rem(n,2)==0);   % Cosinus Fourier-Koeffizienten 
        a(1) = 0;                               % Cosinus Koeffizient n=1
        b=zeros(1,N_koeff);                     % Sinus Fourier-Koeffizienten 

        plot_title = "2 Wege-Gleichrichtung";

    case 4 % 1 Weg-Gleichrichtung

        A=2/pi;                                             % Faktor für die Summe 
        a0=2/pi;                                            % Doppelter Mittelwert    
        a = -sin(pi/2.*(1.+n))./(n.^2-1) .* (rem(n,2)==0);  % Cosinus Fourier-Koeffizienten 
        a(1) = pi/4;                                        % Cosinus Koeffizient n=1
        b=zeros(1,N_koeff);                                 % Sinus Fourier-Koeffizienten 

        plot_title = "1 Weg-Gleichrichtung";

    case 5 % e-Funktion

        A=(1-exp(-2*pi))/pi;        % Faktor für die Summe 
        a0=A;                       % Doppelter Mittelwert
        a=1./(1.+n.^2);             % Cosinus Fourier-Koeffizienten 
        b=n./(1.+n.^2);             % Sinus Fourier-Koeffizienten 

        plot_title = "e-Funktion";
    
    otherwise % Keine Funktion ausgewählt

        A=0;                        % Faktor für die Summe 
        a0=0;                       % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=zeros(1,N_koeff);         % Sinus Fourier-Koeffizienten 
        
        plot_title = "---";
end

% Definieren der Zeitwerte
t = linspace(t_start,t_ende,N_werte);

% Berechnen der Funktionswerte
y = fourier_series_fun_02(a0,a,b,T,A,t,Option);

% Anzahl an Kurven wenn nötig begrenzen
y = y(1:min(10, size(y,1)),:);

% Berechnen der Amplituden
c = [a0/2 abs(A .* sqrt(a.^2 + b.^2))];

% Darstellen der Plots
figure;                         % Erzeugen eines Fensters

% Funktionswerte darstellen
subplot(2,1,1);                 % Layoutposition
plot(t,y);                      % Darstellen der Werte
title(plot_title);              % Diagrammtitel
xlim([t_start,t_ende]);         % x-Achse begrenzen
xlabel("t[s]");                 % Beschriftung x-Achse
ylabel("f(t) fourier-series");  % Beschriftung y-Achse

% Amplitudenspektrum darstellen
subplot(2,1,2);                 % Layoutposition
stem(0:N_C-1,c(1,1:N_C));       % Darstellen der Werte
xlabel("n[-]");                 % Beschriftung x-Achse
ylabel("|A|");                  % Beschriftung y-Achse