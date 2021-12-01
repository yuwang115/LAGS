% Script for sliming the variables in the velocity dataset:
% antarctic_ice_vel_phase_map_v01.nc

% Yu Wang
% 2021.10 at BNU

% NOTE: 
% The function script extendArray.m is needed. It takes about 30 mins of 
% computing time to expand 20 pixels outward.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename="antarctic_ice_vel_phase_map_v01.nc"
ncdisp(filename);

x= ncread(filename,'x');
y= ncread(filename,'y');
VX_data = ncread(filename,'VX');
VY_data = ncread(filename,'VY');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extending 20 pixels to the sea based on Rupert's script (Long running time)
%'extend vx'
VX_data_n = VX_data; VX_data_n(VX_data==0.00000) = NaN; clear VX_data;
VX_data=extendArray(VX_data_n); clear VX_data_n;

%'extend vy'
VY_data_n = VY_data; VY_data_n(VY_data==0.00000) = NaN; clear VY_data;
VY_data=extendArray(VY_data_n); clear VY_data_n;

%write data into nc file
ncfilename='antarctic_ice_vel_phase_map_v01_slim.nc';


%open the netcdf file
%ncid = netcdf.create(ncfilename,'64BIT_OFFSET');
ncid = netcdf.create(ncfilename,'CLOBBER');

%define the dimension
x_dimid = netcdf.defDim(ncid,'x',12445);%column
y_dimid = netcdf.defDim(ncid,'y',12445);%row

%define IDS for the dimension variables
x_varid = netcdf.defVar(ncid,'x','double',x_dimid);
y_varid = netcdf.defVar(ncid,'y','double',y_dimid);
%define the variable
vx_varid =netcdf.defVar(ncid,'vx','double',[x_dimid,y_dimid]);
vy_varid =netcdf.defVar(ncid,'vy','double',[x_dimid,y_dimid]);
%vel_varid = netcdf.defVar(ncid,'vel','double',[x_dimid,y_dimid]);

%add attribute value
netcdf.putAtt(ncid,x_varid,'standard_name','projection_x_coordinate');
netcdf.putAtt(ncid,y_varid,'standard_name','projection_y_coordinate');
netcdf.putAtt(ncid,vx_varid,'standard_name','Ice velocity in x-direction');
netcdf.putAtt(ncid,vx_varid,'units','meter/year');
netcdf.putAtt(ncid,vy_varid,'standard_name','Ice velocity in y-direction');
netcdf.putAtt(ncid,vy_varid,'units','meter/year');
netcdf.endDef(ncid);

%write the data into this file
netcdf.putVar(ncid,x_varid,x);
netcdf.putVar(ncid,y_varid,y);
netcdf.putVar(ncid,vx_varid,VX_data);%%
netcdf.putVar(ncid,vy_varid,VY_data);
netcdf.close(ncid);

ncwriteatt(ncfilename,'/','Title','MEaSUREs Phase-Based Antarctica Ice Velocity Map, Version 1, slim');
ncwriteatt(ncfilename,'/','Coordinate system','EPSG:3031 WGS 84 / Antarctic Polar Stereographic projection');
ncwriteatt(ncfilename,'/','Source','https://nsidc.org/data/NSIDC-0754/versions/1');
ncwriteatt(ncfilename,'/','Remark','Yu Wang modified on 2021.10; Only streamline the variables in the original data set, without making additional changes');
ncwriteatt(ncfilename,'vx','_FillValue','-99999.9');
ncwriteatt(ncfilename,'vy','_FillValue','-99999.9');
%check the final netcdf file
ncdisp(ncfilename);
