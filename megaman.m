pkg load image;
load('megaman.mat');

for i=1:100
  rgb = RGB{i};
  hsv = rgb2hsv(rgb);
  
  bin_megaman = hsv(:,:,2) == 1 & hsv(:,:,3) > 0.9 & hsv(:,:,1) < 0.6 & hsv(:,:,1) > 0.1;
  bin_megaman = imclose(bin_megaman, ones(7));
  rgb_megaman = bin_megaman .* rgb;

  coordenadas = regionprops(bin_megaman, "Centroid");

  mega_x = round(coordenadas.Centroid(2));
  mega_y = round(coordenadas.Centroid(1));

  raio = 25;
  
  drawnow;
  subplot(1,2,1); imshow(rgb);
  subplot(1,2,2); imshow(rgb_megaman(mega_x-raio:mega_x+raio, mega_y-raio:mega_y+raio, :));
endfor;