% m-file: test_C_Bat.m
%
% Erklärung
%
% Dieses m-file berechnet für den in Hausübung 2 "Kondensator als Batterie"
% angegebenen Schaltungsaufbau die Funktionswerte uLast und uBat mittels
% der gegebenen Differentialgleichungen.
% Diese Berechnung findet für zwei unterschiedliche Parametersätze statt.
% Zusätzlich wird mittels der Funktion fminsearch eine Ersatzfunktion für
% uLast ermittelt und grafisch ausgegeben.
% 
% Input:    Angabe von Parameterwerten für CLast, RLast, ULast0, CBat,
%           RBat und UBat0
% Output:   Graphische Ausgabe von uLast, uBat und der ermittelten
%           Ersatzfunktion von fminsearch für uLast
%
% Beispiel: C_Last = 6;
%           R_Last = 100000;
%           U_Last_0 = 0;
%           C_Bat = 20;
%           R_Bat = 100;
%           U_Bat_0 = 1;
%
% Autor:	Leon Knauf
%
% Datum:    07.12.2023
%
% Änderung: 
%
% Benötigte eigene externe functions: keine
%
% siehe auch: 
%
%--------------------------------------------------------------------------  

%% Anwendung initialisieren

close all;  % Schließen von offenen Plots
clearvars;  % Variablenspeicher leeren

%% Grafische Ausgabe initialisieren

f = figure; % Generieren eines Ausgabefensters 
f.Position = [360 140 1200 800]; % Ändern der Fenstergröße
f.NumberTitle = 'off'; % Entfernen von 'Figure 1' aus dem Fenstertitel
f.Name = 'Hausübung 2'; % Anpassen des Fenstertitels

%% Schleife über alle Parametervarianten

num_parameters = 2; % Anzahl an Parametervarianten definieren

for para = 1:num_parameters

    %% Parameter definieren

    % Parametervariante auswählen
    switch para

        case 1 % Parameter setzen Variante 1
            C_Last = 6;     % Kapazität CLast [F]
            R_Last = 100000;% Widerstand RLast [Ohm]
            U_Last_0 = 0;   % Spannung ULast zum Zeitpunkt t=0 [V]        
        case 2 % Parameter setzen Variante 2
            C_Last = 20;    % Kapazität CLast [F]
            R_Last = 1000;  % Widerstand RLast [Ohm]
            U_Last_0 = 0;   % Spannung ULast zum Zeitpunkt t=0 [V]
    end
    
    % Weitere Parameter setzen
    C_Bat = 20;     % Kapazität CBat [F]
    R_Bat = 100;    % Widerstand RBat [Ohm]
    U_Bat_0 = 1;    % Spannung UBat zum Zeitpunkt t=0 [V]

    % Aus gegebenen Parametern die Parameter für die DGLs berechnen
    R_P = (R_Last * R_Bat) / (R_Bat + R_Last);
    Tau_Bat = C_Bat * R_Bat;
    Tau_C1 = C_Last * R_Bat;
    Tau_C2 = C_Last * R_P;
    
    % Zeitparameter setzen
    tmax=30*Tau_Bat;    % Simulationsdauer [s]
    anz_werte=800;      % Anzahl Stützstellen
    dt=tmax/anz_werte;  % Abtastzeit [s]
    t=0:dt:tmax;        % Zeitvektor [s]
    
    %% Funktionswerte berechnen

    % Anfangswerte als Spaltenvektor
    y0 = [U_Bat_0 U_Last_0]';
    
    % Berechnen der Funktionswerte mittels ode45
    [~,y] = ode45(@dgl_C_Bat,t,y0,[],Tau_Bat, Tau_C1, Tau_C2);	
    
    % Ergebnisse der Berechnung
    U_Bat =y(:,1);  % UBat [V]
    U_Last=y(:,2);  % ULast [V]

    %% Annähendere Funktion mittels fminsearch bestimmen

    % Startparameter definieren
    p0 = [0.8 -1/500000 -0.8 -1/1000];

    % Auruf von fminsearch
    p=fminsearch(@LadeFkt_f_min_fun,p0,[],t,y(:,2)');

    % Ermittelte Parameter auslesen
    c1 = p(1);
    c2 = p(2);
    c3 = p(3);
    c4 = p(4);

    % Funktionswerte mit ermittelten Parametern berechnen
    U_Last_est = c1 * exp(c2*t)+c3*exp(c4*t);   % ULastEst [V]

    %% Grafische Ausgabe

    % Zeitvektor in Stunden berechnen
    t_in_h = (t/3600);

    % Erster Plot: UBat und ULast
    plot1 = subplot(num_parameters*2,1,(para-1)*2 + 1);                     % Subplot erstellen
    plot(t_in_h,U_Bat,'b',t_in_h,U_Last,'r');                               % Funktionen UBat und ULast darstellen
    title(['Kondensator als Batterie Paramterwerte ' num2str(para) ':']);   % Titel des Plots anpassen
    xlabel('t [h]');                                                        % Beschriftung X-Achse
    ylabel('U_B [V]; U_L [V]');                                             % Beschriftung Y-Achse
    grid;                                                                   % Hintergrundraster aktivieren
    legend('U_B', 'U_L');                                                   % Legende einfügen

    % Zweiter Plot: ULast und ULastEst
    plot2 = subplot(num_parameters*2,1,(para)*2);                           % Subplot erstellen
    plot(t_in_h,U_Last_est,'g',t_in_h(1:15:end),U_Last(1:15:end),'r*');     % Funktionen ULast und ULastEst darstellen
    title('Resultierende Funktion durch fminsearch:');                      % Titel des Plots anpassen
    xlabel('t [h]');                                                        % Beschriftung X-Achse
    ylabel('U_L_,_e_s_t [V]; U_L [V]');                                     % Beschriftung Y-Achse
    grid;                                                                   % Hintergrundraster aktivieren
    legend('U_L_,_e_s_t', 'U_L');                                           % Legende einfügen

    % Position der Plots anpassen
    pos1 = get(plot1,'Position');   % Position des ersten Plots ermitteln
    pos2 = get(plot2,'Position');   % Position des zweiten Plots ermitteln
    if para<=num_parameters/2       % Für erste Hälfte der Parameterwerte
        pos1(2) = pos1(2) + 0.03;   % Plot 1 nach oben verschieben
        pos2(2) = pos2(2) + 0.03;   % Plot 2 nach oben verschieben
    else                            % Für zweite Hälfte der Parameterwerte
        pos1(2) = pos1(2) - 0.03;   % Plot 1 nach unten verschieben
        pos2(2) = pos2(2) - 0.03;   % Plot 2 nach unten verschieben
    end
    set (plot1, 'Position', pos1)   % Position des ersten Plots setzen
    set (plot2, 'Position', pos2)   % Position des zweiten Plots setzen

    % Linie in der Mitte einfügen bei gerade Anzahl an Plots
    if mod(num_parameters,2) == 0
        annotation("line",[0.05 0.95],[0.506 0.506]);
    end
end

%% function dgl_C_Bat

function Yp = dgl_C_Bat(~,y,Tau_Bat, Tau_C1, Tau_C2)

    % Rechnenverfahren definieren

    Rechnenverfahren='Gleichungen';
    % Rechnenverfahren='Matrix';

    switch Rechnenverfahren
        case 'Gleichungen'
            % Startwerte für UBat und ULast aus den Übergabeparametern lesen
            U_Bat=y(1);
            U_Last=y(2);
     
            % DGLs mit den Startwerten aufstellen
            dUB_dt=1/Tau_Bat * (U_Last - U_Bat);
            dUL_dt=U_Bat/Tau_C1 - U_Last/Tau_C2;

            % Gleichungen als Matrix zurückgeben
            Yp=[dUB_dt;
                dUL_dt]; 

        case 'Matrix'
            % DGLs in Matrixform aufstellen
            A=[-1/Tau_Bat   1/Tau_Bat;
                1/Tau_C1    -1/Tau_C2];

            % Mit Startparametern multiplizieren un zurückgeben
            Yp=A*y;

    end

end

%% function LadeFkt_f_min_fun

function y=LadeFkt_f_min_fun(p,t_mess,U_Last_mess)
    % Auslesen der Startparameter aus dem Übergabewert p
    c1 = p(1);
    c2 = p(2);
    c3 = p(3);
    c4 = p(4);

    % Funktionswerte der neuen Funktion berechnen
    U_Last_est = c1 * exp(c2*t_mess)+c3*exp(c4*t_mess);

    % Summe der quadrierten Differenz der beiden Funktionen zurückgeben
    y=sum((U_Last_est-U_Last_mess).^2);
end
