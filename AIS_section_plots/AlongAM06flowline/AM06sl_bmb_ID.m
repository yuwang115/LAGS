clc,clear
load AM06sl_ID
filename = 'C:\Users\XPS-15\Desktop\BMB\BMB_Susheel\bmb_Susheel.nc';
ncdisp(filename);

x_susheel = ncread(filename,'x');
y_susheel = ncread(filename,'y');
bmb_susheel = ncread(filename,'bmb');

% transfer x and y coords into 2D format
for i = 1:1201
    y_susheel_2d(i,1:501) = x_susheel(i);
end

for j = 1:501
    x_susheel_2d(1:1201,j) = y_susheel(j);
end 
    
bmb_susheel_sl = interp2(x_susheel_2d,y_susheel_2d,bmb_susheel,X_sl,Y_sl);
