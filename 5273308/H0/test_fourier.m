% m-file: test_fourier.m
%
% HUE 0
%
% Erklaerung
%
% Es werden Fourier-Reihen-Koeffizienten periodische Signale berechnet und in Diagrammen visualisiert. 
% Je nach gewaehltem Beispiel werden verschiedene Koeffizienten berechnet.
% Fuer die Berechnung der Fourier-Reihe wird eine externe Funktion aufgerufen.
% Es werden die Funktion sowie das Amplitudenspektrum geplottet.
% 
% Input:    Werte zur Koeffizientenberechnung, Werte zur Signal-Visualisierung
% Output:   Koeffizienten an Funktion, Signal-Visualisierung in diesem File
%
% Autor   :	Marvin Mueller (5273308)
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation WS 2023/2024 erstellt.
%
% Datum:    19-10-2023
%
% Aenderung: xxx
%
% Benoetigte eigene externe functions: fourier_series_01.m
% Benoetigte eigene externe functions: fourier_series_02.m
%
% siehe auch: xxx
%
%--------------------------------------------------------------------------         

close all;          % Noch geoeffnete Plots schließen
clearvars;          % Variablenspeicher leeren

N_koeff=100;        % Anzahl Fourier Koeffizienten 
T=2*pi;             % Periodendauer 
n=1:N_koeff;        % Vektor mit n=1,2,3,... 
num_a_spec = 12;    % Anzeigewerte fuer Amplitudenspektrum

%================
Beispiel = 5;
% 1: Rechteck ungerade
% 2: Saegezahn
% 3: 2 Wege-Gleichrichtung
% 4: 1 Weg-Gleichrichung
% 5: e-Funktion
%================ 

%================
opt = 3;
% 0: kein plot
% 1: nur die Funktion f(t) darstellen
% 2: alle harmonischen in einem plot
% 3: alle Teilsummen in einem plot
% 4: ...
%================

switch Beispiel     % Switch Case Fourier-Reihen Koeffizienten-Berechnung  

    case 1          % 1: Rechteck ungerade
        A=4/pi;             % Faktor fuer die Summe 
        a0=0;               % Doppelter Mittelwert 
        a=zeros(1,N_koeff); % Cosinus Fourier-Koeffizienten 
        
        % Sinus Fourier-Koeffizienten
        b=(1./n) .* (mod(n,2)~=0);  % mod-Befehl ermoeglicht, das ungerade n berechnet und gerade n auf 0 gesetzt werden

        plot_title = "Rechteck ungerade";   % Diagramm-Ueberschrift

        
    case 2          % 2: Saegezahn
        A=-1/pi;            % Faktor fuer die Summe 
        a0=1;               % Doppelter Mittelwert 
        a=zeros(1,N_koeff); % Cosinus Fourier-Koeffizienten 
        b=1./n;             % Sinus Fourier-Koeffizienten

        plot_title = "Saegezahn";   % Diagramm-Ueberschrift


    case 3          % 3: 2 Wege-Gleichrichtung
        A=4/pi;             % Faktor fuer die Summe 
        a0=A;               % Doppelter Mittelwert 
        
        % Cosinus Fourier-Koeffizienten
        a=(-1)./(n.^2.-1) .* (mod(n,2)==0); % mod-Befehl ermöglicht, das gerade n berechnet und ungerade n auf 0 gesetzt werden 
        a(1)=0;             % a_1 Definition

        b=zeros(1,N_koeff); % Sinus Fourier-Koeffizienten

        plot_title = "2 Wege-Gleichrichtung";   % Diagramm-Ueberschrift


    case 4          % 4: 1 Weg-Gleichrichung
        A=2/pi;             % Faktor fuer die Summe 
        a0=A;               % Doppelter Mittelwert 
        
        % Cosinus Fourier-Koeffizienten
        a=-sin((pi/2).*(1.+n))./(n.^2-1) .* (mod(n,2)==0); % mod-Befehl ermoeglicht, das gerade n berechnet und ungerade n auf 0 gesetzt werden 
        a(1)=pi/4;          % a_1 Definition

        b=zeros(1,N_koeff); % Sinus Fourier-Koeffizienten

        plot_title = "1 Weg-Gleichrichung";   % Diagramm-Ueberschrift


    case 5          % 5: e-Funktion
        A=(1-exp(-2*pi))/pi;    % Faktor fuer die Summe 
        a0=A;                   % Doppelter Mittelwert  
        a=1./(1.+n.^2);         % Cosinus Fourier-Koeffizienten 
        b=n./(1.+n.^2);         % Sinus Fourier-Koeffizienten

        plot_title = "e-Funktion";   % Diagramm-Ueberschrift

    otherwise       % keine Funktion ausgewaehlt

        disp('Case not defined');
        disp('Wrong series type chosen');
        A=0;                    % Faktor fuer die Summe 
        a0=0;                   % Doppelter Mittelwert
        a=zeros(1,N_koeff);     % Cosinus Fourier-Koeffizienten 
        b=zeros(1,N_koeff);     % Sinus Fourier-Koeffizienten 
        
        plot_title = "---";     % Diagram Titel

end

% Zeitwerte fuer die periodische Funktion 
N_werte=400;                        % Anzahl der zu berechnenden Funktionswerte 
t_start=0;                          % Startwert 
t_ende=4*pi;                        % Endwert 
t=linspace(t_start,t_ende,N_werte); % Zeitwerte

% Ueberpruefung ob Display-Option Variable existiert
% Relevant fuer Aufgabenteil 4 
switch exist('opt', 'var')
    case 1      % Variable Display-Option definiert & ist Teil des Funktionsaufrufs
        y= fourier_series_fun02(a0,a,b,T,A,t,opt); % Funktionswerte
    otherwise   % Variable Display-Option nicht definiert, deswegen kein Teil des Funktionsaufrufs
        y= fourier_series_fun02(a0,a,b,T,A,t); % Funktionswerte
end

% nur maximal 0.1*N_koeff Werte plotten, damit Plot uebersichtlich bleibt
y = y(1:min(N_koeff*0.1,size(y,1)),:);

% Berechnung c_n fuer Betrags-Amplitudenspektrum und initiales setzen von a0
c_n = [a0/2 abs(A .* sqrt(a.^2 + b.^2))];

% Darstellung Funktion
figure;
tiledlayout(2,1);

nexttile;
hold on;
plot(t, y(1:2:size(y,1),:), 'b');   % Eintraege der Matrix an ungerader Stelle in blau plotten
plot(t, y(2:2:size(y,1),:), 'r');   % Eintraege der Matrix an gerader Stelle in rot plotten
hold off;
title(plot_title);          % Diagramm-Ueberschrift
xlim([t_start, t_ende]);    % Breite X-Achse
grid on;                    % Gitter
% Achsen-Beschriftung
xlabel("t[s]");
ylabel("f(t) fourier-series");

% Darstellung Amplitudenspektrum
nexttile;
stem(0:num_a_spec, c_n(1,1:num_a_spec+1));  % Plot
xlim([t_start, t_ende]);    % X-Achse
grid on;                    % Gitter
ax = gca;
ax.XGrid = 'off';           % Entfernen vertikaler Gitterlinien
% Achsen-Beschriftung
xlabel("n[-]");
ylabel("|A|");