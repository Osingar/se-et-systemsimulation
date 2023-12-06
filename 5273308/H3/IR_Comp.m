% m-file: IR_Comp.m
%
% Header fuer Hausuebung Nr.3 "Motor mit IR-Kompensation"
%
% Erklaerung:
% File zur dynamischen Betrachtung der Motordrehzahl eines DC-Motors mit
% IR-Kompensation bei Verwendung unterschiedlicher Verstaerkungsfaktoren.
%
% Eingabe:  Systemparameter
%           - Motorparameter
%           - beschreibende Systemparameter
%           - Stoergroessen
%           - Eingangsgroessen
%           - Simulationszeit
%           - Anfangsbedingung
%
% Ausgabe:  Grafische Darstellung des Drehzahl-Verlaufs mit
%           7 Kompensationswerten
%
% Beispiel: xxx
%
% Autor:
%
% Datum:
% 
% Aenderung:
%
% Benoetigte eigene externe Funktionen:
%
% siehe auch:
%
%--------------------------------------------------------------------------
clearvars;                                      % Alle Plots schliessen
close all;                                      % Workspace loeschen

%% Systemparameter

% Motorparameter
Psi=15e-3;                                      % Verketteter Fluss                         [Vs]
Ra=10;                                          % Ankerwiderstand                           [Ohm]
La=10e-3;                                       % Ankerinduktivitaet                        [H]
J=5e-7;                                         % Massentraegheitsmoment                    [kgm^2]

k_var=[0 0.5 sqrt(2)/2 0.8 0.9 0.97 1.0];       % Variation der Kompensationswerte
k=k_var*Ra;                                     % Proportionaler Verstaerkungsfaktor        [Ohm]
N_k=length(k_var);                              % Vektor der Laenge von k_var bzw. k

% Beschreibende Systemparameter
Ta=La/Ra;                                       % Ankerkreiskonstante                       [s]
Tm=(Ra*J)/Psi^2;                                % Elektromechanische Zeitkonstante          [s]
delta=1/(2*Ta);                                 % Abklingkonstante                          [1/s]

w=sqrt(Psi^2/(La*J));                           % Eigenfrequenz                             [1/s]
D=delta/w;                                      % Daempfungsfaktor                          [-]
Ra_ap=La*w;                                     % Widerstand fuer aperiodischen Grenzfall   [Ohm]                             

% Stoergroessen
M_last=4e-3;                                    % Mechanische Last                          [Nm]
dM_last_dt=0;                                   % Lastaenderung                             [Nm/s]

% Eingangsgroessen
Ua=10;                                          % max. Ankerspannung                        [V]
Ua_c=5;                                         % Spannung fuer Solldrehzahl                [V]

% Simulationszeit
t_start=0;                                      % Startwert                                 [s]
t_end=Ta*120;                                   % Endwert                                   [s]
Nt=400;                                         % Anzahl der zu berechnenden Funktionswerte
t=linspace(t_start,t_end,Nt);                   % Zeitwerte

% Anfangsbedingung t=0
Al_0=0;                                         % Anfangswinkelbeschleunigung               [1/s^2]
w_0=0;                                          % Winkelgeschwindigkeit                     [1/s]
y0= [Al_0 0*w_0]';                              % Anfangsbedingung in einer Matrix

%% Einstellungen fuer ode45-Funktion zur Loesung der DGL 2. Ordnung mit Hilfe zweier DGL 1. Ordnung
al=zeros(Nt,N_k);                               % Anlegen eines Arrays fuer die Beschleunigung
n=zeros(Nt,N_k);                                % Anlegen eines Arrays fuer die Drehzahl

tol=1e-12;                                      % Toleranzen
options=odeset('RelTol', tol);                  % Optionsstruktur mit relativer Fehlertoleranz abgeaendert auf tol-Wert

for i=1:1:N_k
    [~, y2]=ode45(@dgl_Motor_c,t,y0, options, Ua_c, Ra, La, k(i), Psi, J, M_last(1), dM_last_dt);   % ode45

    % Ergebnisse der errechneten Werte mit unterschiedlichem Verstaerkungsfaktor
    al(:,i)=y2(:,1);                            % Beschleunigung                            [m/s^2]
    n(:,i)=y2(:,2)*60/(2*pi);                   % Drehzahl                                  [1/min]
end

% Darstellung der Graphen
figure
plot(t*1e3,n)                                   % Darstellung der Funktion n(t)
xlabel('t [ms]')                                % Beschriftung der x-Achse
ylabel('n [rpm]')                               % Beschriftung der y-Achse
title('Drehzahl-Verlauf mit 7 Kompensationswerten')             % Titelangabe des Graphen
lgd=legend('0', '0.5', '0.707', '0.8', '0.9', '0.97', '1.0');   % Legende fuer die Variation der Kompensationswerte
title(lgd,sprintf('Variation der\nKompensationswerte'))         % Titelangabe der Legende
grid                                            % Rasterlinien darstellen



%% function dgl_Motor_c
function Yp=dgl_Motor_c(~,y, Ua_0, R_A, L_A, k, Psi, J, M_L, dM_last_dt)

    % System-Matrix:
    % da/dt=-k1 * a - k2 * w + R                % 1. Gleichung fuer da/dt = d^2w/d^2t
    % dw/dt=a                                   % 2. Gleichung fuer dw/dt = a

    k1 = (R_A-k)/L_A;                           % Berechnung Faktor k1
    k2 = Psi^2/(L_A*J);                         % Berechnung Faktor k2
    R = (Psi/(L_A * J))*Ua_0-(((R_A-k)/(L_A*J))*M_L+dM_last_dt/J);  % Berechnung Faktor R

    % Ueberfuehrung von k1, k2 sowie R in die System Matrix
    A = [-k1 -k2; 1 0];                         % System-Matrix A
    b=[R; 0];                                   % System-Matrix b

    % Bildung des DGL-Systems
    Yp=A*y+b;                                   % Yp=[a' n']

end