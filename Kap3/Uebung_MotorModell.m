% Ueb_DGL1_5.m Vorlage
%
% Vorlesungsbegleitende Übung
%
% Einfaches DC-Motor- Modell mit Drehmoment-Puls
%
%
% Autor:	Horst Rumpf
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation SS 2023 erstellt.
%
% Datum:    2023-10-31
%
% Änderung: 
%
% siehe auch: test_DGL1_1 und test_DGL1_2
%----------------------------------------
close all;  % Alle plots schliessen
clearvars;  % workspace löschen.

%% Systemparameter 
Ra=10;         	% Ankerwiderstand     	    [Ohm]
Psi=15e-3;		% Verketteter Fluss 		[Vs]
J=5e-7;         % Massenträgheitsmoment 	[kgm²]
Tm=Ra*J/Psi^2;	% Elektromech. Zeitkonst.   [s]

%% Störgrößen
Ua=5;         	% Konstante Motorspannung	[V] 

% Lastmoment-Puls durch zwei e-Funktionen dargestellt
% M_last(t)=M_0*(1+exp(-t/(2*Ts))-exp(-t/Ts)) mit den 
% zwei Parametern M_0 und der Zeitkonstante Ts

M0=5e-3; 		% Lastmoment 			    [Nm]
Ts=0.01;        % Zeitkonstante Lastmoment  [s]
t0=4*Tm;

% Maximale Winkelgeschwindigkeit bei konst. Last M_0
w_max=Ua/Psi-Ra/Psi^2*M0;  %               [rad/s]


%% Zeitbereich
%-------------
dt=0.01*Tm;      % Schrittweite  [s]
t_end=10*Tm; 	% Zeitdauer     [s] 
t=0:dt:t_end;   % Zeitvektor    [s]

% Lastmomentfür die Darstellung berechnen
M_t=M_Last(t,M0,Ts,t0);   %Lastmoment [Nm]
        
%% Anfangsbedingung
w_0=0;	  		% Winkelgeschwindigkeit	 [rad/s]

%% Solveraufruf ode45
param = [J Psi Ra Ua Tm M0 Ts t0];
[t,w] = ode45(@(t,w) DC_motor_PT1(t,w,param),t,w_0);  
     

%% Ergebnis darstellen

figure
subplot(2,1,1)
    plot(1e3*t,w,'b')
    xlabel(' t[ms]')
    ylabel('w [1/s]')
    grid
    title('DC-Motor')
subplot(2,1,2)
    plot(1e3*t,M_t*1e3,'r')
    xlabel(' t[ms]')
    ylabel('M_{Last} [mNm]')
    grid
 

%% DGL DC-Motor 
% - ohne Bereücksichtigung der Ankerkreiskonstanen.
% D.h. PT1-Verhalten der Winkelgeschwindigkeit w
% Das Lastmoment M_Last wird in der function M_Last
% beschrieben.
%--------------------------------------------------
function dw_dt=DC_motor_PT1(t, w, param)
    J = param(1);
    Psi = param(2);
    Ra = param(3);
    Ua = param(4);
    Tm = param(5);
    M0 = param(6);
    Ts = param(7);
    t0 = param(8);

    dw_dt= 1/J * (Psi/Ra * Ua - M_Last(t,M0,Ts,t0)) - 1/Tm * w;       

end

%% Zeitabhängiges Lastmoment
% Puls durch zwei e-Funktionen erzeugt.

function M_t=M_Last(t,M_0,Ts,t0)

    M_t = M_0*(1+exp(-(t-t0)/(2*Ts))-exp(-(t-t0)/Ts));

    for i=1:length(M_t)
        if M_t(i)<0
            M_t(i) = 0;
        end
    end

end