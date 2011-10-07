## -*- texinfo -*-
## @deftypefn  {Function File} {} lunender (@var{qtd_ped}, @var{qtd_est}, @var{atend_min}, @var{atend_max})
## dado vetores de qtd_ped (quantidade de pedidos) e qtd_est(quantidade em estoque),
## e porcentagem de atend_min e atend_max

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
  printf("Atendimento minino: %d [porcento]\n", atend_min);
  printf("Atendimento maximo (para compensar frete): %d [porcento]\n", atend_min);
  printf("-------------------------------------\n\n");

  printf("Tipo A - RespeitaGrade && 100Ref:\n")
  % respeita grade
  A=false;
  if mean(atend_p_item) < 100
    printf("Status: Pedido em ESPERA\n\n");
  else
    A=true;
    printf("Status: Pedido COMPLETAMENTE ATENDIDO\n\n");
  endif
  printf("-------------------------------------\n\n");

  printf("Tipo B - RespeitaGrade e !100Ref:\n");
  if A == true;
    printf("Status:  Pedido COMPLETAMENTE ATENDIDO\n\n");
  else
    if atend < atend_min
      printf("Atendimento(%d) menor que atendimento minimo(%d)\n", atend, atend_min);
      printf("Status: Pedido em ESPERA\n\n");
    elseif atend > atend_max
      printf("Atendimento(%d) maior que atendimento maximo(%d)\n", atend, atend_max);
      printf("Status: Pedido em ESPERA\n\n");
    else
      printf("Status: Pedido ATENDIDO PARCIALMENTE\n");
      printf("O pedido é: ");
      qtd_ped
      printf("Sera atendido: ");
      round((atend/100)*qtd_ped)
    endif
  endif
  printf("-------------------------------------\n\n");

  printf("Tipo C - !RespeitaGrade e !100Ref:\n");
  if A == true;
    printf("Status: Pedido COMPLETAMENTE ATENDIDO\n\n");
  else
    for i=1:l
      qtd_atend(i)=min(qtd_est(i),qtd_ped(i));
    endfor
    if mean(qtd_atend./qtd_ped) > atend_max
      printf("Atendimento(%d) maior que atendimento maximo(%d)\n", atend, atend_max);
      printf("Status: Pedido em ESPERA\n\n");
    else
      printf("Status: Pedido ATENDIDO PARCIALMENTE\n");
      printf("O pedido é: ");
      qtd_ped
      printf("Sera atendido: ");
      qtd_atend
    endif
  endif
  printf("================================================\n\n");

endfunction