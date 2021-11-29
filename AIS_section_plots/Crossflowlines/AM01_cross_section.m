clc,clear
load AIS_data_ID
load CrossSect1_LR

% A straight line passing through AM01 and AM02
% CrossSect1_x = (637580:70:803580); 
% CrossSect1_y = 0.25602*CrossSect1_x+1955170.6807;

T_AIS = double(reshape(T_AIS,[20,169980/20]));
x_AIS = double(reshape(x_AIS,[20,169980/20]));
y_AIS = double(reshape(y_AIS,[20,169980/20]));
z_AIS = double(reshape(z_AIS,[20,169980/20]));
Vx_AIS = double(reshape(Vx_AIS,[20,169980/20]));
Vy_AIS = double(reshape(Vy_AIS,[20,169980/20]));
Vz_AIS = double(reshape(Vz_AIS,[20,169980/20]));

for i = 1:20
  CrossSect1_z(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),CrossSect1_y,CrossSect1_x); 
  T_interp(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),T_AIS(i,:),CrossSect1_y,CrossSect1_x,CrossSect1_z(i,:));
end
T_interp = T_interp - 273.15;

% for i=1:length(CrossSect1_x)-1
% L_CrossSect1(1,i) = sqrt((CrossSect1_x(i+1)-CrossSect1_x(i)).^2 + (CrossSect1_y(i+1)-CrossSect1_y(i)).^2);
% end 

for i=1:length(CrossSect1_x)
L_CrossSect1(1,i) = 72.2577094707239*i/1000; % calculate from above, unit: km
end

% figure, % test to plot
% for i = 1:20
%  scatter(L_CrossSect1,CrossSect1_z(i,:),10,T_interp(i,:),'filled')
%  hold on
% end
% colormap jet
% colorbar

% now use interp1 to get regular mesh
z_mesh1D = min(CrossSect1_z(:)):1:max(CrossSect1_z(:));
[z_mesh, L_mesh] = meshgrid(z_mesh1D,L_CrossSect1);

for i = 1:length(L_CrossSect1)
  T_mesh(i,:) = interp1(CrossSect1_z(:,i),T_interp(:,i),z_mesh1D);   
end

% To mark the position of AM01 and AM02
AM01_x = 2139313.66;  AM01_y = 719247.87;
AM02_x = 2125165.12;  AM02_y = 664357.39;
% AM03s_x = 2.1306463517e6; AM03s_y = 6.85398293e5; %AM03obs_sl
AM03s_x = 2.1312323e6; AM03s_y = 6.876868e5; % AM03sim_sl

[~,num_AM01] = min(abs(CrossSect1_y-AM01_x));
[~,num_AM02] = min(abs(CrossSect1_y-AM02_x));
[~,num_AM03s] = min(abs(CrossSect1_y-AM03s_x));

% convert m to km

L_AM01 = L_CrossSect1(num_AM01);
L_AM02 = L_CrossSect1(num_AM02);
L_AM03s= L_CrossSect1(num_AM03s);

%% Plot temperature profiles

figure,
set(gcf,'position',[50 50 1280 555]);
set(axes,'InnerPosition',[0.06,0.1,0.895,0.85])%0.064 0.081 0.86 0.857
T_section = pcolor(L_mesh,z_mesh,T_mesh); hold on
shading flat
T_section.EdgeAlpha = 0;
% colormap(ncl_colormap('cmocean_balance'))
xlabel('Distance along crossing line (km)');
ylabel('Elevation (m)')


% add vertical line and marks
hold on
plot([L_AM01 L_AM01],[-365 45],'--k','LineWidth',1.5);hold on
plot(L_AM01,45,'kx','LineWidth',1.5);
text(L_AM01,60,'AM01','HorizontalAlignment','center','FontSize',11)
hold on
plot([L_AM02 L_AM02],[-315.5 39],'--k','LineWidth',1.5);hold on
plot(L_AM02,39,'kx','LineWidth',1.5);
text(L_AM02,54,'AM02','HorizontalAlignment','center','FontSize',11)
hold on
%plot([L_AM03s L_AM03s],[-355.5 44],'--k','LineWidth',1.5);hold on
plot(L_AM03s,44,'kx','LineWidth',1.5);
text(L_AM03s,59,'AM03 flowline','HorizontalAlignment','center','FontSize',11)
hold on

cb = colorbar('h');colormap jet;
title(cb,['\fontsize{10}T(',char(176),'C)']);
set(cb,'location','South') 
set(cb,'AxisLocation','in')  
caxis([-30 -2])
set(gca,'FontSize',12);
cb.Position= [0.6625 0.130159 0.278575 0.0384]



xlim([0 171.4])
ylim([-500 70])
%xticks(0:20:500)
%yticks(-1800:300:0)

text(0,1.035,"(e)",'Units',"normalized",'FontSize',15,'FontWeight','bold')
set(gca,'FontSize',12);
set(gca, 'Layer', 'top')
% 
%cd('C:\Users\XPS-15\Desktop\近期images\Temp_Sections_ID')
print('Cross2_TS_ID','-dpng','-r400')