clc,clear
load AIS_data_ID
load CrossSect2_LR

% A straight line passing through AM01 and AM02
% CrossSect2_x = (668070:50:756220); 
% CrossSect2_y =  -0.23068*CrossSect2_x+2174808.9766;
% % CrossSect2_y = -0.61552*CrossSect2_x+2449031.5317;
% hold on
% plot(CrossSect2_x,CrossSect2_y)

T_AIS = double(reshape(T_AIS,[20,169980/20]));
x_AIS = double(reshape(x_AIS,[20,169980/20]));
y_AIS = double(reshape(y_AIS,[20,169980/20]));
z_AIS = double(reshape(z_AIS,[20,169980/20]));
Vx_AIS = double(reshape(Vx_AIS,[20,169980/20]));
Vy_AIS = double(reshape(Vy_AIS,[20,169980/20]));
Vz_AIS = double(reshape(Vz_AIS,[20,169980/20]));

for i = 1:20
  CrossSect2_z(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),CrossSect2_y,CrossSect2_x); 
  T_interp(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),T_AIS(i,:),CrossSect2_y,CrossSect2_x,CrossSect2_z(i,:));
end
T_interp = T_interp - 273.15;

% for i=1:length(CrossSect1_x)-1
% L_CrossSect1(1,i) = sqrt((CrossSect1_x(i+1)-CrossSect1_x(i)).^2 + (CrossSect1_y(i+1)-CrossSect1_y(i)).^2);
% end 

for i=1:length(CrossSect2_x)
L_CrossSect2(1,i) = 72.2577094707239*i/1000; % calculate from above, unit: km
end

% figure, % test to plot
% for i = 1:20
%  scatter(L_CrossSect1,CrossSect1_z(i,:),10,T_interp(i,:),'filled')
%  hold on
% end
% colormap jet
% colorbar

% now use interp1 to get regular mesh
z_mesh1D = min(CrossSect2_z(:)):1:max(CrossSect2_z(:));
[z_mesh, L_mesh] = meshgrid(z_mesh1D,L_CrossSect2);

for i = 1:length(L_CrossSect2)
  T_mesh(i,:) = interp1(CrossSect2_z(:,i),T_interp(:,i),z_mesh1D);   
end

% To mark the position of AM01 and AM02
AM03_x = 2009234.44;  AM03_y = 717781.8;
JP_x = 1990088; JP_y = 745617;
%JPs_x = 2002170; JPs_y = 748370;% JPobs_sl
%AM06s_x = 2015470; AM06s_y = 690750;% AM06obs_sl
JPs_x = 2.0020876e6; JPs_y = 7.487486e5;% JPsim_sl
AM06s_x = 2.015849e6; AM06s_y = 6.890927e5;% AM06sim_sl
%hold on
%plot([AM03_y jp_y],[AM03_x jp_x],'-r')

[~,num_AM03] = min(abs(CrossSect2_y-AM03_x));
[~,num_JPs] = min(abs(CrossSect2_y-JPs_x));
[~,num_AM06s] = min(abs(CrossSect2_y-AM06s_x));

% convert m to km
L_JPs= L_CrossSect2(num_JPs);
L_AM03= L_CrossSect2(num_AM03);
L_AM06s = L_CrossSect2(num_AM06s);
%% Plot temperature profiles

figure,
set(gcf,'position',[50 50 1280 555]);
set(axes,'InnerPosition',[0.06,0.1,0.895,0.85])%0.064 0.081 0.86 0.857
T_section = pcolor(L_mesh,z_mesh,T_mesh); hold on
shading flat
T_section.EdgeAlpha = 0;
% colormap(ncl_colormap('cmocean_balance'))

caxis([-30 -2])

%colorbar.Label.String = 'Temperature (℃)';
%title('Temperature Section along JP flowline')
xlabel('Distance along crossing line (km)');
ylabel('Elevation (m)')

% add vertical line and marks
hold on
plot([L_AM03 L_AM03],[-644 78],'--k','LineWidth',1.5);hold on
plot(L_AM03,78,'kx','LineWidth',1.5);
text(L_AM03,96,'AM03','HorizontalAlignment','center','FontSize',11)
hold on
%plot([L_jp L_jp],[-522 64],'--k','LineWidth',1.5);hold on
plot(L_JPs,64,'kx','LineWidth',1.5);
text(L_JPs,82,'JP flowline','HorizontalAlignment','center','FontSize',11)
hold on
plot(L_AM06s,70,'kx','LineWidth',1.5);
text(L_AM06s,88,'AM06 flowline','HorizontalAlignment','center','FontSize',11)

cb = colorbar('h');colormap jet;
title(cb,['\fontsize{10}T(',char(176),'C)']);
set(cb,'location','South') 
set(cb,'AxisLocation','in')  
caxis([-30 -2])
set(gca,'FontSize',12);
cb.Position= [0.6625 0.130159 0.278575 0.0384]


xlim([0 127.5])
ylim([-750 110])
xticks(0:10:200)
%yticks(-1000:100:300)

text(0,1.035,"(d)",'Units',"normalized",'FontSize',15,'FontWeight','bold')
set(gca,'FontSize',12);
set(gca, 'Layer', 'top')
%% Plot inset 1
% 
% x_map = x_AIS(20:20:169980);
% y_map = y_AIS(20:20:169980);
% T_map = T_AIS(20:20:169980)-273.15;
% 
% axes('position',[0.83125,0.08889,0.088,0.3595])%0.8,0.112,0.106,0.42
% map1 = pcolor(AIS_mask_x,AIS_mask_y,AIS_DepthAvg_T); hold on
% shading flat
% map1.EdgeAlpha = 0; 
% axis equal
% set(gca,'XDir','reverse')
% colormap jet
% caxis([-30 -2])
% % xlim([590000 860000])
% % ylim([1650000 2270000])
% xlim([609000 844500])
% ylim([1672500 2251500])
% hold on
% plot(AM03_y,AM03_x,'kx','LineWidth',0.5)
% hold on
% plot(JPs_y,JPs_x,'kx','LineWidth',0.5)
% hold on
% plot(AM06s_y,AM06s_x,'kx','LineWidth',0.5)
% hold on
% plot(CrossSect2_x,CrossSect2_y,'-k')
% box on
% set(gca,'xtick',[],'ytick',[])
% 
% load AM03sim_sl
% plot(X_sl,Y_sl,'--k');hold on
% load AM06sim_sl
% plot(X_sl,Y_sl,'--k');hold on
% load JPsim_sl
% plot(X_sl,Y_sl,'--k');hold on
% 
%cd('C:\Users\XPS-15\Desktop\近期images\Temp_Sections_ID')
print('Cross1_TS_ID','-dpng','-r400')

% CrossSect2_x = flip(CrossSect2_x);
% CrossSect2_y = flip(CrossSect2_y);

