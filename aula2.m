function []=aula2()
 
  k = 0.5;
  kr = -0.5;
  alvo.x=80;
  alvo.y=80;
  obst.x=60;
  obst.y=60;
  robo.x=50;
  robo.y=50;
  robo(2).x=30;
  robo(2).y=30;
  dx=0;
  dy=0;
  drx=0;
  dry=0;
  for i=1:100000
    [robo(1)] = atracao(alvo, robo(1), k);
    [robo(2)] = atracao(alvo, robo(2), k);
    [robo(1)] = repulsao(obst, robo(1), kr, 5); 
    [robo(2)] = repulsao(obst, robo(2), kr, 5);     
    plot(robo(1).x, robo(1).y, 'r+', "linewidth", 10, robo(2).x, robo(2).y, 'b+', "linewidth", 10, alvo.x, alvo.y, 'bo', "linewidth", 10, obst.x, obst.y, 'kx', "linewidth", 10);
    axis([0, 100, 0, 100]);
    drawnow;
  end
 end
 
function [robo]=atracao(alvo, robo, k)
    distx = alvo.x - robo.x;
    disty = alvo.y - robo.y;
    dist=sqrt(distx^2 + disty^2);
    dx = distx/dist;
    dy = disty/dist;
    robo.x = robo.x + k*dx;
    robo.y = robo.y + k*dy;
end

function [robo]=repulsao(obst, robo, kr, ro)
    distrx = obst.x - robo.x;
    distry = obst.y - robo.y;
    distr=sqrt(distrx^2 + distry^2);
    if distr < ro
      drx = distrx/distr + 0.01*randn;
      dry = distry/distr + 0.01*randn;
      robo.x = robo.x + kr*drx;
      robo.y = robo.y + kr*dry;
    end
end

