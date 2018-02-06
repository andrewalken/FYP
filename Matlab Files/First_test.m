close all;
dx = 1.67e-6;
dy = 1.67e-6;
z2= 1e-3;
wavelength = 570e-9;
%INTENSITY = imread('Petri_dish_simulation_lensfree_hologram.tif');
if true   
   row=3664;  col=2748;
%fin=fopen('Bare Sensor.raw','r');
fin=fopen('Image_11.raw','r');
%fin=fopen('Pic two.raw','r');
I=fread(fin,row*col,'uint8=>uint8'); 
INTENSITY=reshape(I,row,col);
INTENSITY=INTENSITY';
figure;imagesc(INTENSITY);colormap gray; axis equal;
end
% 
% INTENSITY1 = INTENSITY(1:2:end,1:2:end);
% INTENSITY2 = INTENSITY(2:2:end,2:2:end);
% INTENSITY3 = INTENSITY(1:2:end,2:2:end);
% INTENSITY4 = INTENSITY(2:2:end,1:2:end);
% figure;imagesc(INTENSITY1);colormap gray; axis equal;
% figure;imagesc(INTENSITY2);colormap gray; axis equal;
% figure;imagesc(INTENSITY3);colormap gray; axis equal;
% figure;imagesc(INTENSITY4);colormap gray; axis equal;

 N=10;
 for i=1:1:N
     recon = angular_spectrum_method(sqrt(double(INTENSITY)), -z2, dx, dy, wavelength);
     figure;imagesc(abs(recon).^2);colormap gray; axis equal;
     z2 = z2 + 0.1e-3;
 end


 
%CREATE MASK FOR TWIN IMAGE IN RECONSTRUCTION PLANE
temp = angular_spectrum_method(double(INTENSITY), z2, dx, dy, wavelength);
MASK = (abs(temp).^1)<25*min(min((abs(temp).^1)));%CREATE MASK
figure; imagesc(MASK);colormap gray; axis equal;
n=10; h = 1/(n^2)*ones(n,n);MASK = filter2(h,MASK); MASK = MASK>0.1*max(max(MASK));%CREATE MASK
figure; imagesc(MASK);colormap gray; axis equal;




 
%PING PONG
N=4;
recon=sqrt(double(INTENSITY));
for i=1:1:N
    recon = angular_spectrum_method(recon, z2, dx, dy, wavelength);
    figure;imagesc(abs(recon));colormap gray; axis equal; title(i);
    figure;imagesc(angle(recon));colormap gray; axis equal; title(i);
    n=25; h = 1/(n^2)*ones(n,n);temp = filter2(h,abs(recon));
    temp = temp.*(abs(MASK-1));
   
    
    recon = recon.*MASK + temp;
    recon = angular_spectrum_method((recon), -z2, dx, dy, wavelength);
    recon = sqrt(double(INTENSITY)).*exp(1i*angle(recon));
end