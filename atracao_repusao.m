function [] = main()
  bola = criaObj([50 50], 1);
  robo(1) = criaRobo([20 10], 5, bola, 5, -0.5);
  robo(2) = criaRobo([70 10], 5, bola, 5, -0.5);

  while (1)
    robo(1) = move(robo(1), robo(2), 1);
    robo(2) = move(robo(2), robo(1), 1);
    
    plot(robo(1).pos(1), robo(1).pos(2), 'r+', robo(2).pos(1),robo(2).pos(2),'b+', bola.pos(1), bola.pos(2), 'mo');
    axis([0 100 0 100]);
    drawnow;  
  end
end

function [robo] = criaRobo(pos, raio, alvo, k_a, k_r)
  robo.pos = pos;
  robo.raio = raio;
  robo.alvo = alvo;
  robo.k_a = k_a;      % constante atracao
  robo.k_r = k_r;      % constante repulsao
end

function [obj] = criaObj(pos,raio)
  obj.pos = pos; 
  obj.raio = raio;
end
  
function [robo] = move(robo, obst, vel_max)
  [desl_x, desl_y] = atracao(robo, robo.alvo, robo.k_a);
  
  % soma os deslocamentos propostos pelas forças de atraçao e repulsao
  for i=1:length(obst)
    [d_x, d_y] = repulsao(robo, obst(i), robo.k_r);

    desl_x = desl_x + d_x;
    desl_y = desl_y + d_y;
  end

  % limita o desl_x e o desl_y aqui
  desl_resultante = sqrt(desl_x^2 + desl_y^2);
  if(desl_resultante > vel_max)   
    if(desl_x == 0)
        desl_x = 0.000001;
    end

    if(desl_x < 0)
      angulo = pi + atan(desl_y/desl_x);
    else
      angulo = atan(desl_y/desl_x);
    end
    
    desl_x = vel_max*cos(angulo);
    desl_y = vel_max*sin(angulo);    
  end
  
  % adiciona o deslocamento no robo
  robo.pos(1) = robo.pos(1) + desl_x;
  robo.pos(2) = robo.pos(2) + desl_y;  
end

function [desl_x, desl_y] = atracao(robo, alvo, k)
  dist.x = alvo.pos(1) - robo.pos(1);
  dist.y = alvo.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  
  dx = dist.x/dist.e + 0.1*randn;
  dy = dist.y/dist.e + 0.1*randn;
  
  desl_x = 0;
  desl_y = 0;
  
  if dist.e > robo.raio + alvo.raio
    desl_x = k*dx;    
    desl_y = k*dy;
  end
end 


function [desl_x, desl_y] = repulsao(robo, obst, k)
  dist.x = obst.pos(1) - robo.pos(1);
  dist.y = obst.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;

  desl_x = 0;
  desl_y = 0;
  
  if dist.e.^2<(robo.raio + obst.raio).^2
    desl_x = k*dx;
    desl_y = k*dy;
  end
end 
