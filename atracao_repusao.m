function [] = aula1()

function [robo]=atracao(alvo,robo,k)
  dist.x = alvo.x - robo.x;
  dist.y = alvo.y - robo.y;
  dist.e = sqrt(dist.x^2 + dist.y^2);
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;

  robo.x = robo.x + k*dx;
  robo.y = robo.y + k*dy;

end 

function [robo]=repulsao(obst,robo,k)
  dist.x = obst.x - robo.x;
  dist.y = obst.y - robo.y;
  dist.e = sqrt(dist.x^2 + dist.y^2);
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;

  if(dist.e<8)
    robo.x = robo.x + k*dx;
    robo.y = robo.y + k*dy;
  end
end 

robo(1).x=35; robo(1).y=35;
robo(2).x=35; robo(2).y=90;

obst.x=60; obst.y=60;
alvo.x=80; alvo.y=80;

for i=1:300
  robo(1) = atracao(alvo, robo(1), 0.5);
  robo(1) = repulsao(obst, robo(1),-0.5);
  robo(2) = atracao(alvo, robo(2), 0.5);
  robo(2) = repulsao(obst, robo(2),-0.5);
    
  plot(robo(1).x,robo(1).y,'r+', robo(2).x,robo(2).y,'b+', alvo.x, alvo.y, 'mo', obst.x, obst.y, 'bx');
  axis([0 100 0 100]);
  drawnow;  
end


end