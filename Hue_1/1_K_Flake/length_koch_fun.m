% m-file: length_koch_fun.m
%
% Erklärung
%
% Diese Funktion berechnet den Umfang einer Koch'schen Schneeflocke
% 
% Input:    Punkte einer Koch'schen Schneeflocke
% Output:   Umfang der Koch'schen Schneeflocke
%
% Beispiel:
%
% Autor   :	Leon Knauf
%
% Datum:    26.10.2023
%
% Änderung: 
%
% Benötigte eigene externe functions:
%
% siehe auch: 
%
%--------------------------------------------------------------------------  

function length = length_koch_fun(x,y)

% Variable initialisieren
length = 0;

% Alle Punkte bis auf den letzten druchlaufen
for i=1:size(x,2)-1

    % Abstand zwischen aktuellem und nächsten Punkt besimmten und summieren
    length = length + sqrt((x(i) - x(i+1))^2 + (y(i) - y(i+1))^2);
end

end

