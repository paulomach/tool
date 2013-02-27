## -*- texinfo -*-
## @deftypefn  {Function File} {} lunender (@var{qtd_ped}, @var{qtd_est}, @var{atend_min}, @var{atend_max})
## dado vetores de qtd_ped (quantidade de pedidos) e qtd_est(quantidade em estoque),
## e porcentagem de atend_min e atend_max

## DataBase required data:
## qtd_ped:
##  SELECT t.pedite_quantidade FROM tool_pedido_item t WHERE t.id_pedido = :id_pedido
## qtd_est:
##  SELECT t.pec_wms_saldo FROM tool_peca t WHERE (SELECT a.id_pedido FROM tool_pedido_item
##    WHERE a.id_peca = t.id_peca) = :id_pedido
## atend_min, atend_max, tipo (a||b||c):
##  SELECT t.ped_atend_min t.ped_atend_max t.ped_tipo FROM tool_pedido t WHERE t.id_pedido = :id_pedido

## Return:
## atend_atual:
##  UPDATE tool_pedido t SET t.ped_atend_atual = :atend_atual WHERE t.id_pedido = :id_pedido
##

function lunender (qtd_ped, qtd_est, atend_min, atend_max)

  if length(qtd_est)!=length(qtd_ped)
    printf("vetor de pedidos tem tamanho diferente de vetor de estoque\n");
    break
  endif

  % calc grade
  l = length(qtd_ped);
  mdc=qtd_ped(1);
  for i=1:l
    if i<l
      mdc = gcd(mdc, qtd_ped(i+1));
    endif
  endfor
  for i=1:l
    grade(i) =  qtd_ped(i)/mdc;
  endfor

  % atend. por item em %
  for i=1:l
    if qtd_ped(i) > qtd_est(i)
      atend_p_item(i) = 100*qtd_est(i)/qtd_ped(i);
    else
      atend_p_item(i) = 100;
    endif
  endfor

  % item limitante(indice no vetor) e atendimento
  [atend, index_limit] = min(atend_p_item);
  printf("DADOS DO PEDIDO: \n");
  printf("Estoque: "); qtd_est
  printf("Venda:   "); qtd_ped
  printf("A "); grade
  printf("Atendimento minino: %d %%\n", atend_min);
  printf("Atendimento maximo (para compensar frete): %d %%\n", atend_max);
  printf("-------------------------------------\n\n");

  printf("Tipo A - RespeitaGrade && 100%%Ref:\n")
  % respeita grade
  A=false;
  if mean(atend_p_item) < 100
    printf("Status: Pedido em ESPERA\n\n");
  else
    A=true;
    printf("Status: Pedido COMPLETAMENTE ATENDIDO\n\n");
  endif
  printf("-------------------------------------\n\n");

  printf("Tipo B - RespeitaGrade e !100%%Ref:\n");
  if A == true;
    printf("Status:  Pedido COMPLETAMENTE ATENDIDO\n\n");
  else
    if atend < atend_min
      printf("Atendimento(%d%%) menor que atendimento minimo(%d%%)\n", atend, atend_min);
      printf("Status: Pedido em ESPERA\n\n");
    elseif atend > atend_max
      printf("Atendimento(%d%%) maior que atendimento maximo(%d%%)\n", atend, atend_max);
      printf("Status: Pedido em ESPERA\n\n");
    else
      printf("Status: Pedido ATENDIDO PARCIALMENTE\n");
      printf("O pedido é: ");
      qtd_ped
      printf("Sera atendido %d%% : ", atend);
      round((atend/100)*qtd_ped)
    endif
  endif
  printf("-------------------------------------\n\n");

  printf("Tipo C - !RespeitaGrade e !100%%Ref:\n");
  if A == true;
    printf("Status: Pedido COMPLETAMENTE ATENDIDO\n\n");
  else
    for i=1:l
      qtd_atend(i)=min(qtd_est(i),qtd_ped(i));
    endfor
    if mean(qtd_atend./qtd_ped) > atend_max
      printf("Atendimento(%d%%) maior que atendimento maximo(%d%%)\n", atend, atend_max);
      printf("Status: Pedido em ESPERA\n\n");
    else
      printf("Status: Pedido ATENDIDO PARCIALMENTE\n");
      printf("O pedido é: ");
      qtd_ped
      atend=100*sum(qtd_atend)/sum(qtd_ped);
      printf("Sera atendido %d%% : ", atend);
      qtd_atend
    endif
  endif
  printf("================================================\n\n");

endfunction