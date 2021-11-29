clc,clear
load AIS_data_ID
load AM03sl_ID
load AM03sl_bmb_ID

% Derive the length and interval of the streamline

sl_length = 0;
for i =1:length(X_sl)-1;
   interval(i) = sqrt((X_sl(i)-X_sl(i+1))^2+(Y_sl(i)-Y_sl(i+1))^2)/1000;% /1000 to convert to km
   sl_length=sl_length+interval(i);
   L_along_sl(i+1) = sl_length;
end

% L_interp = [1:100:sl_length];
% x_interp = interp1(L_along_sl,X_sl,L_interp);
% y_interp = interp1(L_along_sl,Y_sl,L_interp);

T_AIS = double(reshape(T_AIS,[20,169980/20]));
x_AIS = double(reshape(x_AIS,[20,169980/20]));
y_AIS = double(reshape(y_AIS,[20,169980/20]));
z_AIS = double(reshape(z_AIS,[20,169980/20]));
Vx_AIS = double(reshape(Vx_AIS,[20,169980/20]));
Vy_AIS = double(reshape(Vy_AIS,[20,169980/20]));
Vz_AIS = double(reshape(Vz_AIS,[20,169980/20]));

for i = 1:20
  Z_sl(i,:) = griddata(x_AIS(i,:),y_AIS(i,:),z_AIS(i,:),Y_sl,X_sl); 
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
z_mesh1D = -2425:1:290;
[z_mesh, L_mesh] = meshgrid(z_mesh1D,L_along_sl);

for i = 1:length(L_along_sl)
  T_mesh(i,:) = interp1(Z_sl(:,i),T_sl(:,i),z_mesh1D);
end

% To mark the position of AM03
AM03_x = 2007401.33; AM03_y = 717489.11;
[~,num_AM03] = min(abs(Y_sl-AM03_x));
GZ_x = 1691570; GZ_y = 712700;
[~,num_GZ] = min(abs(Y_sl-GZ_x));
%% Plot
figure,
set(gcf,'position',[50 50 1280 555]);
set(axes,'InnerPosition',[0.06,0.1,0.895,0.85])%0.064 0.081 0.86 0.857
colororder({'k','k'})

yyaxis left
T_section = pcolor(L_mesh,z_mesh,T_mesh); hold on
plot([L_along_sl(num_AM03) L_along_sl(num_AM03)],[79 -653],'--k','LineWidth',1.5);hold on
plot(L_along_sl(num_AM03),79,'kx','LineWidth',1.5);hold on
plot(L_along_sl(num_GZ),289,'kx','LineWidth',1.5);hold on

text(7,355,'GZ','HorizontalAlignment','center','FontSize',11)
text(L_along_sl(num_AM03),139,'AM03','HorizontalAlignment','center','FontSize',11)

shading flat
T_section.EdgeAlpha = 0;
caxis([-30 -2])
xlabel('Distance along flowline (km)');
ylabel('Elevation (m)')
%xlim([0 548.7]);
ylim([-2500 400]);
xticks(0:50:600);
yticks(-3000:300:300);
cb = colorbar('h');colormap jet;
title(cb,['\fontsize{10}T(',char(176),'C)']);
set(cb,'location','South') 
set(cb,'AxisLocation','in')  

set(gca,'FontSize',12);
cb.Position= [0.6625 0.130159 0.278575 0.0384]
text(0,1.035,"(b)",'Units',"normalized",'FontSize',15,'FontWeight','bold')

%% Plot BMB
yyaxis right
p1 = plot(L_along_sl,bmb_susheel_sl,'-k','LineWidth',1);
hold on
plot([0 600],[0 0],'k:','LineWidth',1);

p1.Color(4) = 0.3 % set transparency
ylim([-31.25 5]);
ylim([-45 7.2]);

ylabel('BMB\_CAL (ma^{-1})','VerticalAlignment','cap')
set(gca, 'Layer', 'top')

%cd('C:\Users\XPS-15\Desktop\近期images\Temp_Sections_ID')
print('AM03_TempSect','-dpng','-r400')