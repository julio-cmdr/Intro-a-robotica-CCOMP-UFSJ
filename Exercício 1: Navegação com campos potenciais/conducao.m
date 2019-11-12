function [] = conducao()
  bolas(1) = criaObj([30 25], 1);
  bolas(2) = criaObj([40 45], 1);

  pedras(1) = criaObj([60 25], 1);
  pedras(2) = criaObj([40 25], 1);
  pedras(3) = criaObj([30 60], 1);
  
  destinos(1) = criaObj([75 25], 1);
  destinos(2) = criaObj([25 75], 1);

  robos(1) = criaRobo([2.5 2.5], 1.5, bolas(1), 1, -1);
  robos(2) = criaRobo([50 50], 1.5, bolas(1), 1, -1);
  robos(3) = criaRobo([23 23], 1.5, bolas(2), 1, -1);
  robos(4) = criaRobo([70 90], 1.5, bolas(2), 1, -1);

  while (1)    
    for j = 1:2
      
      if(distancia(bolas(j), destinos(j)) > 1)        
        for i = (2*j-1):2*j
          obstaculos_robo = concatena_obstaculos_robo(i, robos, [bolas pedras]);

          robos(i).alvo = calcula_alvo_robo(bolas(j), destinos(j), pedras);

          robos(i) = move(robos(i), obstaculos_robo, 1);
        end

        % não permite que um robô sozinho movimente a bola
        if(distancia(bolas(j), robos(2*j-1)) < (bolas(j).raio*2 + robos(2*j-1).raio) && distancia(bolas(j), robos(2*j)) < (bolas(j).raio*2 + robos(2*j).raio))
          bolas(j) = deslocamento_bola(bolas, robos, pedras, j);
        else
          
          for i = 1:length(pedras)
            if(distancia(bolas(j), pedras(i)) < (bolas(j).raio*2.5 + pedras(i).raio))
              bolas(j) = deslocamento_bola(bolas, robos, pedras, j);
              break;
            end
          end

        end

      end    
    end

    exibir_arena(robos, bolas, pedras, destinos);

    if(distancia(bolas(1), destinos(1)) < 1 && distancia(bolas(2), destinos(2)) < 1)
      break;
    end
  end
end

%gera um deslocamento na bola caso ela tenha contato com outro objeto
function [bola] = deslocamento_bola(bolas, robos, pedras, id)
  desl_x = 0;
  desl_y = 0;
  for i=1:length(bolas) 
    if i != id
      [dx, dy] = repulsao(bolas(id), bolas(i), -0.3);
      desl_x += dx;
      desl_y += dy;
    end
  end
  
  for i=1:length(robos)
    [dx, dy] = repulsao(bolas(id), robos(i), -0.3);
    desl_x += dx;
    desl_y += dy;
  end

  for i=1:length(pedras) 
    [dx, dy] = repulsao(bolas(id), pedras(i), -0.3);
    desl_x += dx;
    desl_y += dy;
  end

  bolas(id).pos(1) += desl_x*(rand+0.5);
  bolas(id).pos(2) += desl_y*(rand+0.5);

  bola = bolas(id);
end

function [alvo] = calcula_alvo_robo(bola, destino, pedras)
  [desl_x, desl_y] = atracao(bola, destino, 2);

  for i=1:length(pedras)
    pedras(i).raio = pedras(i).raio*2;
    [dx, dy] = repulsao(bola, pedras(i), -2);
    desl_x += dx;
    desl_y += dy;
  end

  alvo = bola;
  alvo.pos(1) -= desl_x;
  alvo.pos(2) -= desl_y;
  alvo.raio = -1;
end

function [obstaculos] = concatena_obstaculos_robo(id, robos, objetos)
  cont = 1;
  
  for i = 1:length(robos)
    if i != id
      obstaculos(cont) = criaObj(robos(i).pos, robos(i).raio);
      cont += 1;
    end
  end

  for i = 1:length(objetos)
    obstaculos(cont) = objetos(i);
    cont += 1;
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
  
%função para mover o robô
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

function [dist] = distancia(obj1, obj2)
  dist_x = obj1.pos(1) - obj2.pos(1);
  dist_y = obj1.pos(2) - obj2.pos(2);
  dist = sqrt(dist_x^2 + dist_y^2);
end

function [desl_x, desl_y] = atracao(robo, alvo, k)
  dist.x = alvo.pos(1) - robo.pos(1);
  dist.y = alvo.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  
  dx = dist.x/dist.e + 0.01*randn;
  dy = dist.y/dist.e + 0.01*randn;
  
  desl_x = 0;
  desl_y = 0;
  
  if dist.e >= (robo.raio + alvo.raio)
    desl_x = k*dx;    
    desl_y = k*dy;
  end
end 

function [desl_x, desl_y] = repulsao(robo, obst, k)
  dist.x = obst.pos(1) - robo.pos(1);
  dist.y = obst.pos(2) - robo.pos(2);
  dist.e = sqrt(dist.x^2 + dist.y^2);
  
  dx=dist.x/dist.e + 0.01*randn;
  dy=dist.y/dist.e + 0.01*randn;

  desl_x = 0;
  desl_y = 0;
  
  if dist.e.^2 <= (robo.raio + obst.raio).^2
    desl_x = k*dx;
    desl_y = k*dy;
  end
end

function exibir_arena(robos, bolas, pedras, destinos)
  vRobo=[];
  for i=1:length(robos) 
    vRobo=[vRobo; robos(i).pos(1) robos(i).pos(2)];
  end

  vBolas=[];
  for i=1:length(bolas) 
    vBolas=[vBolas; bolas(i).pos(1) bolas(i).pos(2)];
  end

  vPedras=[];
  for i=1:length(pedras) 
    vPedras=[vPedras; pedras(i).pos(1) pedras(i).pos(2)];
  end

  vDestinos=[];
  for i=1:length(destinos) 
    vDestinos=[vDestinos; destinos(i).pos(1) destinos(i).pos(2)];
  end

  c=6.5;
  robo_raio = c*robos(1).raio;
  bola_raio = (c+0.5)*bolas(1).raio;
  pedra_raio = c*pedras(1).raio;

  plot(vRobo(:,1), vRobo(:,2), 'ro', 'MarkerSize', robo_raio, vBolas(:,1), vBolas(:,2), 'mo', 'MarkerSize', bola_raio, vPedras(:,1), vPedras(:,2), 'bx', 'MarkerSize', pedra_raio, vDestinos(:,1), vDestinos(:,2), 'r+');
  axis([0 100 0 100]);
  drawnow;
end