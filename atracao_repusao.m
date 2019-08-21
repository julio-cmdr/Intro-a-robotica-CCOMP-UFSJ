function [] = main()
  bola = criaObj([80 80], 2);
  robo(1) = criaRobo([35 35], 5, bola, 0.5, -1);
  robo(2) = criaRobo([65 65], 5, bola, 0.5, -1);

  while (1)
    robo(1)=move(robo(1),robo(2));
    robo(2)=move(robo(2),robo(1));
    
    plot(robo(1).pos(1),robo(1).pos(2),'r+', robo(2).pos(1),robo(2).pos(2),'b+', bola.pos(1), bola.pos(2), 'mo');
    axis([0 100 0 100]);
    drawnow;  
  end
end

function [robo] = criaRobo(pos, raio, alvo, k_a, k_r)
  robo.pos = pos;
  robo.raio = raio;
  robo.alvo = alvo;
  robo.k_a = k_a;      # constante atracao
  robo.k_r = k_r;      # constante repulsao
end

function [obj] = criaObj(pos,raio)
  obj.pos = pos; 
  obj.raio = raio;
end
  
function [robo] = move(robo, obst)
  [robo] = atracao(robo, robo.alvo, robo.k_a);
  
  for i=1:length(obst)
     [robo] = repulsao(robo, obst(i), robo.k_r);
  end
end

function [robo] = atracao(robo, alvo, k)
  dist.x = alvo.pos(1) - robo.pos(1);
  dist.y = alvo.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  
  dx = dist.x/dist.e + 0.1*randn;
  dy = dist.y/dist.e + 0.1*randn;
  
  if dist.e > robo.raio + alvo.raio
    robo.pos(1) = robo.pos(1) + k*dx;
    robo.pos(2) = robo.pos(2) + k*dy;
  end
end 

function [robo]=repulsao(robo, obst, k)
  dist.x = obst.pos(1) - robo.pos(1);
  dist.y = obst.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;

  if dist.e.^2<(robo.raio + obst.raio).^2
    robo.pos(1) = robo.pos(1) + k*dx;
    robo.pos(2) = robo.pos(2) + k*dy;
  end
end 
