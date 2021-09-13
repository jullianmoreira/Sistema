select 1 as ordem, 'ITENS NÃO ENTREGUES' as visao, count(*) as qtde, coalesce(sum(i.valor_total),0.00) as valor
from itempedido i inner join pedido p on i.pedido_codigo  = p.codigo
where i.data_entrega is null
union all
select 3 as ordem, 'ITENS ENTREGUES' as visao, count(*) as qtde, coalesce(sum(i.valor_total),0.00) as valor
from itempedido i inner join pedido p on i.pedido_codigo  = p.codigo
where i.data_entrega is not null
union all
select 2 as ordem, 'PEDIDOS CONCLUÍDOS' as visao, count(*) as qtde, coalesce(sum(p.vlr_total),0.00) as valor
from pedido p
where p.data_fechamento is not null
union all
select 0 as ordem, 'PEDIDOS EM ANDAMENTO' as visao, count(*) as qtde, coalesce(sum(p.vlr_total),0.00) as valor
from pedido p
where p.data_fechamento is null
order by 1