function [] = aula1()
  robo(1)=criaobj([35 35],5,[10 10],.5);
  robo(2)=criaobj([65 65],5,[10 10],0.5);
  bola=criaobj([80 80],2,[80 80],0.01);
%  obst=criaobj([20 20],5,[0 0],0);
 
 robo(1).alvo=bola.local;
    robo(1).raio_alvo=bola.raio;
    robo(2).alvo=bola.local;
    robo(2).raio_alvo=bola.raio;
    robo(1).kr=-1;
    robo(2).kr=-1;
 
  while (1)
    
    robo(1)=move(robo(1),robo(2));
    robo(2)=move(robo(2),robo(1));
    
    
    
    plot(robo(1).local(1),robo(1).local(2),'r+', robo(2).local(1),robo(2).local(2),'b+', bola.local(1), bola.local(2), 'mo');
    axis([0 100 0 100]);
    drawnow;  
  end
end


function [obj]=criaobj(local,raio,alvo,k_a)
  obj.local=local; 
  obj.raio=raio;
  obj.alvo=alvo;
  obj.k=k_a;
end
  
function [obj]=move(obj,obs)
  robo.x=obj.local(1);
  robo.y=obj.local(2);
  alvo.x=obj.alvo(1);
  alvo.y=obj.alvo(2);
  r=obj.raio;
  ra=obj.raio_alvo;
  k=obj.k;  
  [robo]=atracao(alvo,robo,k,r,ra);
  if length(obs)>0
   kr=obj.kr;
   obst.x=obs.local(1);
   obst.y=obs.local(2);
   ro=obs.raio;
  [robo]=repulsao(obst,robo,kr,r,ro);
end
  obj.local(1)=robo.x;
  obj.local(2)=robo.y;
end

function [robo]=atracao(alvo,robo,k,ra,rr)
  dist.x = alvo.x - robo.x;
  dist.y = alvo.y - robo.y;
  dist.e = sqrt(dist.x^2 + dist.y^2);
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;
  if dist.e>rr+ra
    robo.x = robo.x + k*dx;
    robo.y = robo.y + k*dy;
  end
end 

function [robo]=repulsao(obst,robo,kr,rr,ro)
  dist.x = obst.x - robo.x;
  dist.y = obst.y - robo.y;
  dist.e = sqrt(dist.x^2 + dist.y^2);
  dx=dist.x/dist.e + 0.1*randn;
  dy=dist.y/dist.e + 0.1*randn;

  if dist.e.^2<(rr+ro).^2
    robo.x = robo.x + kr*dx;
    robo.y = robo.y + kr*dy;
  end
end 
