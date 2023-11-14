clc;
clearvars;

x1 = 156;
x2 = 66;

disp(['Iterativ: ' num2str(Euclid_iterativ(x1,x2))]);
disp(['Rekursiv: ' num2str(Euclid_rekursiv(x1,x2))]);

function y = Euclid_iterativ(a,b)
    while (b~=0)
        h = mod(a,b);
        a = b;
        b = h;
    end
    y = a;
end

function y = Euclid_rekursiv(a,b)
    if b == 0
        y = a;
    else
        y = Euclid_rekursiv(b,mod(a,b));
    end
end