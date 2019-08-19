function []=aula3()
  robo(1) = criaObj([35 35], 5, [10 10], 1, 0.5);
  robo(2) = criaObj([65 65], 5, [10 10], 1, 0.5);
  bola = criaObj([80 80], 2, [80 80], 0, 0);
  obst(1) = criaObj([20 20], 5, [0 0], 0, 0);
  dx=0; dy=0;
  drx=0; dry=0;
  
  for i=1:100000
    robo(1).alvo = bola.local;
    robo(1).ra = bola.raio;
    robo(1) = move(robo(1), []);
    plot(robo(1).local(1), robo(1).local(2), 'r+', "linewidth", 10, robo(2).local(1), robo(2).local(2), 'b+', "linewidth", 10, bola.local(1), bola.local(2), 'bo', "linewidth", 10);
    axis([0, 100, 0, 100]);
    drawnow;
  end
 end
 
function [robo]=atracao(alvo, robo, k, ra, rr)
    distx = alvo.x - robo.x;
    disty = alvo.y - robo.y;
    dist=sqrt(distx^2 + disty^2);
    dx = distx/dist;
    dy = disty/dist;
    if dist > rr+ra
    
      robo.x = robo.x + k*dx;
      robo.y = robo.y + k*dy;

   end
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

function [obj]=criaObj(local, r, alvo, k, kr)
  obj.local=local;
  obj.raio=r;
  obj.alvo=alvo;
  obj.k=k;
  obj.kr=kr;
  
end

function [obj]=move(obj, obst)
  robo.x = obj.local(1);
  robo.y = obj.local(2);
  alvo.x = obj.alvo(1);
  alvo.y = obj.alvo(2);
  k = obj.k;
  kr = obj.kr;
  r = obj.raio;
  ra = obj.raio;
  [robo] = atracao(alvo, robo, k, r, ra);
  if length(obst) > 0
    [robo] = repulsao(alvo, robo, kr);     
  end
  obj.local=[robo.x robo.y];
end 