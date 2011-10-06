function lunender (qtd_ped, qtd_est, atend_min, atend_max)

  % validacao lunender
  % clear all;
  %atend_min = 60;
  %atend_max = 80;
  %qtd_ped=[50 100 100 50];
  %qtd_est=[30 70 100 200];

  %qtd_ped=[100 200 200 300];
  %qtd_est=[40 100 50 100];

  %qtd_ped=[20 40 20];
  %qtd_est=[80 100 60];

  %qtd_ped=[20 40 20 30 90 10 35];
  %qtd_est=[80 100 60 30 58 30 37];

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
    printf("Status: Pedido ATENDIDO PARCIALMENTE\n");
    printf("O pedido é: ");
    qtd_ped
    printf("Sera atendido: ");
    for i=1:l
      qtd_atend(i)=min(qtd_est(i),qtd_ped(i));
    endfor
    qtd_atend
  endif
  printf("================================================\n\n");

endfunction