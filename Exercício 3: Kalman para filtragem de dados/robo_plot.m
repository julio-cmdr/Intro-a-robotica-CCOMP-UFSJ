function [] = robo_plot()
     arquivo = fopen('posicoes_com_falhas.txt');

     INICIO = 1;
     FIM = 656;
     NUM_PONTOS = FIM - INICIO +1;

     entrada = fscanf(arquivo,'%f', [3 FIM]);

     Z = [];
     Z_plot = [];
     for i=INICIO:FIM
          if(entrada(1, i) != -1)
               Z_plot = [Z_plot; entrada(1, i) entrada(2, i)];     
          end
          Z = [Z; entrada(1, i) entrada(2, i)];
     end;

     [ordem, F, H, Q, P, R] = inicializa_matrizes(3, 0.005, 0, 1);  % ordem 3
     %[ordem, F, H, Q, P, R] = inicializa_matrizes(2, 0.2, 0, 1);   % ordem 2  
     %[ordem, F, H, Q, P, R] = inicializa_matrizes(1, 0.5, 0, 1);   % ordem 1

     % este vetor vai armazenar os estados filtrados. Na primeira posição não existe filtro
     [estados(1, :)] = inicializa_estados(ordem, Z(1,1), Z(1,2));

     perdeu = false;
     for i = 2:NUM_PONTOS
          if(Z(i,1) != -1)
               if(perdeu == false)
                    [estados(i,:), P] = Kalman(Z(i,:)', estados(i-1,:), P, F, H, Q, R);
               else
                    estados(i, :) = inicializa_estados(ordem, Z(i,1), Z(i,2));
                    perdeu = false;
               end;
          else
               [estados(i,:), P] = Kalman_predict(estados(i-1,:), P, F, H, Q, R);
               perdeu = true;
          end
     end

     p = plot(Z_plot(:,1), Z_plot(:,2), 'r.-', estados(:,1), estados(:,ordem + 1), 'b.-');
     waitfor(p)
end;

function [estados] = inicializa_estados(ordem, zx, zy)
     if ordem == 1
          estados(1,:) = [zx, zy];
     elseif ordem == 2
          estados(1,:) = [zx 0 zy 0];
     else
          estados(1,:) = [zx 0 0 zy 0 0];
     endif;
end

function [ordem, F, H, Q, P, R] = inicializa_matrizes(ordem, kq, kp, kr)
     if ordem == 1
          F = [1 0;
               0 1;];

          H = eye(2);

          Q = eye(2)*kq;

          P = eye(2)*kp;

          R = eye(2)*kr;

     elseif ordem == 2
          F = [1 1 0 0;
               0 1 0 0;
               0 0 1 1;
               0 0 0 1;];

          H = [1 0 0 0;
               0 0 1 0];

          Q = eye(4)*kq;

          P = eye(4)*kp;

          R = eye(2)*kr;

     else                            %terceira ordem
          F = [1 1 0 0 0 0;
               0 1 1 0 0 0;
               0 0 1 0 0 0;
               0 0 0 1 1 0;
               0 0 0 0 1 1;
               0 0 0 0 0 1;];

          H = [1 0 0 0 0 0;
               0 0 0 1 0 0];

          Q = eye(6)*kq;

          P = eye(6)*kp;

          R = eye(2)*kr;
     endif

end

function[x, P] = Kalman(z, last_x, P, F, H, Q, R)
    priori_x = F * last_x';                    % predição do estado (estimativa a priori)
    P_priori = F*P*F' + Q;                     % predição da covariância (estimativa a priori)
    y = (z - H*priori_x);                      % resíduo da medição
    S = (H*P_priori*H' + R);                   % resíduo da covariância
    K = P_priori*H'/S;                         % cálculo do ganho ótimo de kalman
    x = priori_x + K*y;                        % estado atualizado (estimativa a posteriori)
    P = (eye(length(x)) - K*H)*P_priori;       % covariância estimada (estimativa a posteriori)
    x = x';                                    % a transposta foi adicionada apenas por questões de implementação
end

function[x, P] = Kalman_predict(last_x, P, F, H, Q, R)
    priori_x = F * last_x';                    % predição do estado (estimativa a priori)
    x = priori_x';                             % a transposta foi adicionada apenas por questões de implementação
end