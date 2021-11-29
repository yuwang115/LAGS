clc,clear
load AIS_data_ID
load JPsl_ID
load JPsl_bmb_ID

sl_length = 0;
for i =1:length(X_sl)-1;
   interval(i) = sqrt((X_sl(i)-X_sl(i+1))^2+(Y_sl(i)-Y_sl(i+1))^2)/1000;;% /1000 to convert to km
   sl_length=sl_length+interval(i);
   L_along_sl(i+1) = sl_length;
end

T_AIS = double(reshape(T_AIS,[20,169980/20]));
x_AIS = double(reshape(x_AIS,[20,169980/20]));
y_AIS = double(reshape(y_AIS,[20,169980/20]));
z_AIS = double(reshape(z_AIS,[20,169980/20]));
Vx_AIS = double(reshape(Vx_AIS,[20,169980/20]));
Vy_AIS = double(reshape(Vy_AIS,[20,169980/20]));
Vz_AIS = double(reshape(Vz_AIS,[20,169980/20]));
BMB_AIS = double(reshape(BMB_AIS,[20,169980/20]));
EV_AIS = double(reshape(EV_AIS,[20,169980/20]));
EVls_AIS = double(reshape(EVls_AIS,[20,169980/20]));

for i = 1:20
  Z_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),Y_sl,X_sl); 
  BMB_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),BMB_AIS(i,:),Y_sl,X_sl,'natural'); 
  EV_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),EV_AIS(i,:),Y_sl,X_sl,'natural'); 
  EVls_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),EVls_AIS(i,:),Y_sl,X_sl,'natural'); 
  T_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),T_AIS(i,:),Y_sl,X_sl,Z_sl(i,:));
end
T_sl = T_sl - 273.15;

% figure,
% for i = 1:20
%  scatter(L_along_sl,Z_sl(i,:),10,T_sl(i,:),'filled')
%  hold on
% end
% colormap jet
% colorbar

% now use interp1 to get regular mesh
z_mesh1D = -1025:1:125;
[z_mesh, L_mesh] = meshgrid(z_mesh1D,L_along_sl);

for i = 1:length(L_along_sl)
  T_mesh(i,:) = interp1(Z_sl(:,i),T_sl(:,i),z_mesh1D);   
end

% To mark the position of AM05 AM04 AM01
AM01_x = 2139313.66; AM01_y = 719247.87;
AM04_x = 2076458.22; AM04_y = 743888.58;
AM05_x = 2033471.64; AM05_y = 753212.84;
origin_x = 1781000; origin_y = 845200;
JP_x = 1990088; JP_y = 745617;
BIR_x = 1890410.67; BIR_y = 734518.07;
LT_x =  2209044.68; LT_y = 684542 ;  

[~,num_AM01] = min(abs(Y_sl-AM01_x));
[~,num_AM04] = min(abs(Y_sl-AM04_x));
[~,num_AM05] = min(abs(Y_sl-AM05_x));
[~,num_JP] = min(abs(Y_sl-JP_x));
[~,num_BIR] = min(abs(Y_sl-BIR_x));
[~,num_LT] = min(abs(Y_sl-LT_x));

%% Plot temperature profiles
figure,
set(gcf,'position',[50 50 1280 555]);
set(axes,'InnerPosition',[0.06,0.1,0.895,0.85])%0.064 0.081 0.86 0.857

colororder({'k','k'})

yyaxis left
T_section = pcolor(L_mesh,z_mesh,T_mesh); hold on
shading flat
T_section.EdgeAlpha = 0;
% colormap(ncl_colormap('cmocean_balance'))



% add vertical line and marks
hold on
plot([L_along_sl(num_AM01) L_along_sl(num_AM01)],[-365 45],'--k','LineWidth',1.5);hold on
plot(L_along_sl(num_AM01),45,'kx','LineWidth',1.5);
text(L_along_sl(num_AM01),85,'AM01','HorizontalAlignment','center','FontSize',11)
hold on
plot([L_along_sl(num_AM04) L_along_sl(num_AM04)],[-493 60],'--k','LineWidth',1.5);hold on
plot(L_along_sl(num_AM04),60,'kx','LineWidth',1.5);
text(L_along_sl(num_AM04),100,'AM04','HorizontalAlignment','center','FontSize',11)
hold on
plot([L_along_sl(num_AM05) L_along_sl(num_AM05)],[-514 62],'--k','LineWidth',1.5);hold on
plot(L_along_sl(num_AM05),62,'kx','LineWidth',1.5);
text(L_along_sl(num_AM05),102,'AM05','HorizontalAlignment','center','FontSize',11)
hold on
%plot([L_JP L_JP],[-547 67],'--k','LineWidth',1.5);hold on
plot(L_along_sl(num_JP), 67,'kx','LineWidth',1.5);
text(L_along_sl(num_JP),107,'JP','HorizontalAlignment','center','FontSize',11)
hold on
plot(L_along_sl(num_LT),26,'kx','LineWidth',1.5);
text(L_along_sl(num_LT),66,'LT','HorizontalAlignment','center','FontSize',11)
ylim([-1100 150])
xlim([0 426])
xticks(0:40:500)
yticks(-1800:200:200)

cb = colorbar('h');colormap jet;
title(cb,['\fontsize{10}T(',char(176),'C)']);
set(cb,'location','South') 
set(cb,'AxisLocation','in')  
caxis([-30 -2])
set(gca,'FontSize',12);
cb.Position= [0.6625 0.130159 0.278575 0.0384]

xlabel('Distance along flowline (km)');
ylabel('Elevation (m)')
text(0,1.035,"(a)",'Units',"normalized",'FontSize',15,'FontWeight','bold')
set(gca,'FontSize',12);

% yyaxis right
% L1 = plot(L_along_sl,BMB_sl(1,:),'-k');hold on
% L2 = plot(L_along_sl,EV_sl(20,:),'-r');
% % L3 = plot(L_along_sl,-EVls_sl(1,:),'-g')
% ylabel('v (m/a)')
% ylim([-20 20]);
% legend([L1 L2], {'BMB','EV'})
%% Plot BMB
yyaxis right
p1 = plot(L_along_sl,bmb_susheel_sl,'-k','LineWidth',1);
hold on
plot([0 600],[0 0],'k:','LineWidth',1);

p1.Color(4) = 0.25 % set transparency
ylim([-22 3]);
yticks([-4 -2 0 2]);
ylabel('BMB\_CAL (ma^{-1})','VerticalAlignment','cap')
set(gca, 'Layer', 'top')

%cd('C:\Users\XPS-15\Desktop\近期images\Temp_Sections_ID')
print('AM04_TempSect','-dpng','-r400')
