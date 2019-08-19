k = 0.5;
pontox=80;
pontoy=80;
x=50;
y=50;
dx=0;
dy=0;
for i=1:100000
  distx = pontox - x;
  disty = pontoy - y;
  dist=sqrt(distx^2 + disty^2);
  
  dx = distx/dist;
  dy = disty/dist;
  if dist<=1
    dx = 0;
    dy = 0;
    pontox=randi([0,100]);
    pontoy=randi([0,100]);
  end
  x = x + k*dx;
  y = y + k*dy;
  plot(x, y, 'r+', pontox, pontoy, 'go');
  axis([0, 100, 0, 100]);
  drawnow;
end