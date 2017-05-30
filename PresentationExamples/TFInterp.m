   

u00 = 1;
u01 = 1;
u10 = 1;
u11 = 0;

x = [];
y = [];
data = [];
for i = 1:101
    for j = 1:101
        x1 = (i-1)/100;
        x = [x x1];
        x2 = (j-1)/100;
        y = [y x2];
        S1 = (1-x1)*(1-x2);
        S2 = x1*(1-x2);
        S3 = (1-x1)*x2;
        S4 = x1*x2;
        v(i,j) = S1*u00 + S2*u10 + S3*u01 + S4*u11;
        data = [data v(i,j)];
    end
end

figure;
x = unique(x);
y = unique(y);
[X,Y] = ndgrid(x,y);
surf(X,Y,v);
xlabel('E1'); ylabel('E2'); zlabel('TissueFlag');
figure;
v = round(v);
surf(X,Y,v);
xlabel('E1'); ylabel('E2'); zlabel('TissueFlag');
