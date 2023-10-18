% m-file: test_fourier.m
%
% Erkl�rung
%
% Es werden die reellen Fourier-Koeffizienten einer bekannten Fourier-Reihe 
% berechnet und die zugeh�rige Zeitfunktion dargestellt. Die Berechnung
% der Zeitfunktion erfolgt mittels der externen function fourier_series.m
%
% 
% Input:    Werte werden direkt in diesem File zugewiesen
% Output:   Grafik-Ausgabe in diesem File
%
% Beispiel: 
%
% Autor   :	Leon Knauf
%
% Datum:    07.10.2023
%
% �nderung: 
%
% Ben�tigte eingene externe functions: fourier_series_01.m
%
% siehe auch: 
%
%--------------------------------------------------------------------------         

close all;
clearvars;

% Grundwerte f�r die Fourier-Gleichung
N_koeff=100;   % Anzahl Fourier Koeffizienten 
T=2*pi;        % Periodendauer 
n=1:N_koeff;   % Vektor mit n=1,2,3,.. 

% Zeitwerte f�r die periodische Funktion 
N_werte=400;    % Anzahl der zu berechnenden Funktionswerte 
t_start=0;      % Startwert 
t_ende=4*pi;    % Endwert 

% Werte f�r die Amplitudenberechnung
N_C = 12;

% Verschiedene Fourier Reihen
Beispiel = 5;   % 1: Rechteck ungerade
                % 2: S�gezahn
                % 3: 2 Wege-Gleichrichtung
                % 4: 1 Weg-Gleichrichtung
                % 5: e-Funktion

Option = 3;     % 1: Funktion f(t)
                % 2: Alle Harmonischen
                % 3: Alle Teilsummen
                % 4: f(t) mittels fourier_series_fun_01

switch Beispiel

    case 1
    % 1: Rechteck ungerade

        % spezifische Parameter:
        A=4/pi;         % Faktor f�r die Summe 
        a0=0;          % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=(1./n) .* (rem(n,2)~=0); % Sinus Fourier-Koeffizienten 
        
        plot_title = "Rechteck ungerade";

    case 2
    % 2: S�gezahn

        % spezifische Parameter:
        A=-1/pi;         % Faktor f�r die Summe 
        a0=1;          % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=1./n;         % Sinus Fourier-Koeffizienten
        plot_title = "S�gezahn";

    case 3
    % 3: 2 Wege-Gleichrichtung

        % spezifische Parameter:
        A=4/pi;         % Faktor f�r die Summe 
        a0=4/pi;        % Doppelter Mittelwert
        a = (-1)./(n.^2.-1) .* (rem(n,2)==0);  % Cosinus Fourier-Koeffizienten 
        a(1) = 0;
        
        b=zeros(1,N_koeff);         % Sinus Fourier-Koeffizienten 
        plot_title = "2 Wege-Gleichrichtung";

    case 4
    % 4: 1 Weg-Gleichrichtung

        % spezifische Parameter:
        A=2/pi;         % Faktor f�r die Summe 
        a0=2/pi;          % Doppelter Mittelwert    
        a = -sin(pi/2.*(1.+n))./(n.^2-1) .* (rem(n,2)==0); % Cosinus Fourier-Koeffizienten 
        a(1) = pi/4;

        b=zeros(1,N_koeff);         % Sinus Fourier-Koeffizienten 
        plot_title = "1 Weg-Gleichrichtung";

    case 5
    % 5: e-Funktion

        % spezifische Parameter:
        A=(1-exp(-2*pi))/pi;         % Faktor f�r die Summe 
        a0=A;          % Doppelter Mittelwert
        a=1./(1.+n.^2);         % Cosinus Fourier-Koeffizienten 
        b=n./(1.+n.^2);         % Sinus Fourier-Koeffizienten 
        plot_title = "e-Funktion";

    
    otherwise
    % Keine Funktion ausgew�hlt

        % spezifische Parameter:
        A=0;         % Faktor f�r die Summe 
        a0=0;          % Doppelter Mittelwert
        a=zeros(1,N_koeff);         % Cosinus Fourier-Koeffizienten 
        b=zeros(1,N_koeff);         % Sinus Fourier-Koeffizienten 
        plot_title = "---";

end

% Definieren der Zeitwerte
t = linspace(t_start,t_ende,N_werte);

% Berechnen der Funktionswerte
y = fourier_series_fun_02(a0,a,b,T,A,t,Option);

% Berechnen der Amplituden
c = abs(A .* sqrt(a.^2 + b.^2));
c(1)=a0/2;

% Funktion Darstellen figure;
figure;
tiledlayout(2,1);

nexttile;
plot(t,y);
title(plot_title);
xlabel("t[s]");
ylabel("f(t) fourier-series");

nexttile;
stem(0:N_C-1,c(1,1:N_C));
xlabel("n[-]")
ylabel("|A|");