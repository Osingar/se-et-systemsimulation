% m-file: test_C_Bat.m
%
%
% HUE 2
%
% Erklaerung
%
% Berechnung & Visualisierung U_Last und U_Bat mit den gegebenen Differentialgleichungen (mittels der function dgl_C_Bat).
% Auswahl zwei unterschiedlicher Parametersaetze ueber den Switch Case der Variable "param_set".
% Berechung & Visualisierung der mittels fminsearch angenaeherten Verlaufsersatz-Funktion fuer U_Last (mittels der function VoltageCurve_f_min_fun)
% 
% Input:    Werte fuer Parameter 
%           - C_Last 
%           - R_Last
%           - U_Last0
%           - C_Bat
%           - R_Bat
%           - U_Bat0
% Output:   Berechnung & Visualiserung Spannungsverlauf fuer 
%           - U_Last 
%           - U_Bat
%           - U_Last-fminsearch-Verlaufsersatz-Funktion
%
% Autor:    Marvin Mueller (5273308)
%
%           Dieser m-File wurde im Rahmen der Vorlesung Strukturelle und
%           funktionale Systemsimulation WS 2023/2024 erstellt.
%
% Datum:    14-12-2023
%
% Aenderung: xxx
%
% Benoetigte eigene externe functions: xxx
%
% siehe auch: ode45, fminsearch
%
%--------------------------------------------------------------------------  

%===== Initialisierung =====

close all;                                  % Noch geoeffnete Plots schließen
clearvars;                                  % Variablenspeicher leeren

num_parameters = 2;                         % Definition Anzahl zu berechnender Schaltungs-Parametersatz-Varianten [1:2]

%================

for param_set = 1:num_parameters            % Hauptprogramm-Schleife ueber angegebene Anzahl an Parametersatz-Varianten

    switch param_set                        % Definition & Auswahl Schaltungs-Parametersatz-Varianten

        case 1                              % 1. Parametersatz-Variante
            C_Last = 6;                         % Last-Kapazitaet                                   [F]
            R_Last = 100000;                    % Last-Widerstand                                   [Ohm]
            U_Last_0 = 0;                       % Anfangsbedingung Last-Spannung zum Zeitpunkt t=0  [V]        
            p0 = [0.8 -1/500000 -0.8 -1/1000];  % Startwerte fuer best-fit an e-Funktion bei fminsearch 

        case 2                              % 2. Parametersatz-Variante
            C_Last = 20;                        % Last-Kapazitaet                                   [F]
            R_Last = 1000;                      % Last-Widerstand                                   [Ohm]
            U_Last_0 = 0;                       % Anfangsbedingung Last-Spannung zum Zeitpunkt t=0  [V] 
            p0 = [0.5 0 -0.5  -1/1000];         % Startwerte fuer best-fit an e-Funktion bei fminsearch

    end
    
    %===== Definition varianten-unabhaengiger Schaltungs-Parameter =====
    C_Bat = 20;     % Kapazitaet geladener Kondensator als Batterie                             [F]
    R_Bat = 100;    % Vorwiderstand                                                             [Ohm]
    U_Bat_0 = 1;    % Anfangsbedingung Spannung an Kondensator als Batterie zum Zeitpunkt t=0   [V]

    %===== Berechnung DGL-Parameter aus Schaltungs-Parametern =====
    R_P = (R_Last * R_Bat) / (R_Bat + R_Last);  % Parallel-Widerstand R_Last || R_Bat   [Ohm]
    Tau_Bat = C_Bat * R_Bat;                    % Zeitkonstante                         [s]
    Tau_C1 = C_Last * R_Bat;                    % Zeitkonstante                         [s]
    Tau_C2 = C_Last * R_P;                      % Zeitkonstante                         [s]
    
    %===== Definition Zeitraum-Parameter =====
    tmax=30*Tau_Bat;    % Simulationsdauer      [s]
    anz_werte=800;      % Anzahl Stuetzstellen
    dt=tmax/anz_werte;  % Abtast-Zeitintervall  [s]
    t=0:dt:tmax;        % Zeitvektor            [s]
    
    %================
    
    %===== Berechnung Funktionswerte mittels ode45 =====

    y0 = [U_Last_0 U_Bat_0]';                                   % Ausdruck Anfangswerte als Spaltenvektor fuer ode45
    
    [~,y] = ode45(@dgl_C_Bat,t,y0,[],Tau_Bat, Tau_C1, Tau_C2);  % Aufruf ode45	
    
    % Auslesen ermittelter Ergebnisse
    U_Last=y(:,1);  % U_Last [V]
    U_Bat =y(:,2);  % U_Bat [V]
    
    %================

    %===== Berechnung angenaeherte U_Last-Verlaufsersatz-Funktion mittels fminsearch ===== 
    
    p=fminsearch(@VoltageCurve_f_min_fun,p0,[],t,U_Last');      % Auruf fminsearch

    % Auslesen ermittelter Parameter
    c1 = p(1);
    c2 = p(2);
    c3 = p(3);
    c4 = p(4);

    % Berechnung der Funktionswerte mittels der ermittelten Parameter
    U_Last_est = c1 * exp(c2*t)+c3*exp(c4*t);                   % ULastEst  [V]
    
    %================

    %===== Visualisierung =====

    t_in_h = (t/3600); % Berechnung Zeitvektor in Stunden   [h]

    % Initialisierung Gesamt-Plot-Fenster
    f = figure(param_set);                                                                          % Erstellung Ausgabefenster 
    if (param_set <= num_parameters/2)
        f.Position(1) = f.Position(1) - f.Position(3)/2;                                            % Positionierung Fenster links
    else 
        f.Position(1) = f.Position(1) + f.Position(3)/2;                                            % Positionierung Fenster rechts
    end
    f.NumberTitle = 'off';                                                                          % Entfernung von 'Figure 1' aus Fenstertitel
    f.Name = ['HUE 2: Kondesator als Batterie (Parametersatz-Variante ', num2str(param_set), ')'];  % Anpassung Fenstertitel

    %===== Plot 1: U_Bat & U_Last =====
    subplot(2,1,1);                         % Erstellung Subplot
        plot(t_in_h,U_Last,'r',t_in_h,U_Bat,'b');                               % Darstellung Funktionen U_Bat & U_Last
        title('Spannungsverlaeufe');                                            % Diagramm-Ueberschrift
        xlabel('t [h]');                                                        % Beschriftung X-Achse
        ylabel('U_L [V] // U_B [V]');                                           % Beschriftung Y-Achse
        grid;                                                                   % Aktivierung Hintergrundraster
        legend('U_L','U_B');                                                    % Hinzufuegen Legende

    %===== Plot 2: U_Last & U_LastEst =====
    subplot(2,1,2);                          % Erstellung Subplot
        plot(t_in_h,U_Last_est,'g',t_in_h(1:15:end),U_Last(1:15:end),'r*');     % Darstellung Funktionen U_Last & U_LastEst
        title('Angenaeherte Verlaufs-Funktion durch fminsearch');               % Diagramm-Ueberschrift
        xlabel('t [h]');                                                        % Beschriftung X-Achse
        ylabel('U_L_,_e_s_t [V] // U_L [V]');                                   % Beschriftung Y-Achse
        grid;                                                                   % Aktivierung Hintergrundraster
        legend('U_L_,_e_s_t', 'U_L');                                           % Hinzufuegen Legende

end

%================

%===== Definition function dgl_C_Bat =====

function Yp = dgl_C_Bat(~,y,Tau_Bat, Tau_C1, Tau_C2)

    %===== Definition Berechungsverfahren =====
    Berechungsverfahren = 'DGL';
    %'DGL': Gleichungsschreibweise
    %'Matrix': Matrixschreibweise
    %================

    switch Berechungsverfahren
        case 'DGL'
            %===== Einlesen Startwerte von U_Last und U_Bat aus Uebergabeparameter 'y' =====
            U_Last=y(1);
            U_Bat=y(2);
     
            %===== Definition DGLs in Gleichungsschreibweise =====
            dUL_dt=U_Bat/Tau_C1 - U_Last/Tau_C2;
            dUB_dt=1/Tau_Bat * (U_Last - U_Bat);

            %===== Rueckgabe Gleichungsergebenisse als Matrix =====
            Yp=[dUL_dt;
                dUB_dt]; 

        case 'Matrix'
            %===== Definition DGLs in Matrixschreibweise =====
            A=[-1/Tau_C2    1/Tau_C1;
                1/Tau_Bat   -1/Tau_Bat];

            %===== Multiplikation Uebergabeparameter 'y' mit Matrix + Rueckgabe Ergebnisse =====
            Yp=A*y;

    end

end

%================

%===== Definition function VoltageCurve_f_min_fun =====

function y=VoltageCurve_f_min_fun(p,t_mess,U_Last_mess)
    %===== Auslesen Startparameter aus Uebergabeparameter 'p' =====
    c1 = p(1);
    c2 = p(2);
    c3 = p(3);
    c4 = p(4);

    %===== Berechnung Funktionswerte der neuen Funktion =====
    U_Last_est = c1 * exp(c2*t_mess)+c3*exp(c4*t_mess);

    %===== Rueckgabe Summe der quadrierten Differenz beider Funktionen =====
    y=sum((U_Last_est-U_Last_mess).^2);
end