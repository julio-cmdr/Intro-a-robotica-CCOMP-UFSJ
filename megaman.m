pkg load image;
load('megaman.mat');

for i=1:100
  rgb = RGB{i};
  hsv = rgb2hsv(rgb);

  bin_megaman = hsv(:,:,2) == 1 & hsv(:,:,3) > 0.9 & hsv(:,:,1) < 0.6 & hsv(:,:,1) > 0.1;
  bin_inimigo = hsv(:,:,1) < 0.2 & hsv(:,:,2) > 0.63 & hsv(:,:,3) > 0.6;

  bin_megaman = imclose(bin_megaman, ones(7));
  bin_inimigo = imclose(bin_inimigo, ones(7));

  rgb_megaman = bin_megaman .* rgb;
  rgb_inimigo = bin_inimigo .* rgb;

  coordenadas = regionprops(bin_megaman, "Centroid");
  mega_x = round(coordenadas.Centroid(2));
  mega_y = round(coordenadas.Centroid(1));

  coordenadas = regionprops(bin_inimigo, "Centroid");
  ini_x = round(coordenadas.Centroid(2));
  ini_y = round(coordenadas.Centroid(1));

  raio = 15;

  drawnow;
  subplot(1,3,1); imshow(rgb);
  subplot(1,3,2); imshow(rgb_megaman(mega_x-raio:mega_x+raio, mega_y-raio:mega_y+raio, :));
  subplot(1,3,3); imshow(rgb_megaman(ini_x-raio:ini_x+raio, ini_y-raio:ini_y+raio, :));
endfor;
