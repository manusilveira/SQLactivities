-- 1. Crie uma VIEW chamada vw_clientes_localizacao que contenha as seguintes informações:
-- Cidade / Estado / Tipo do cliente (Pessoa Física ou Jurídica) / Quantidade de clientes
-- Ordene pela quantidade de clientes, do maior para o menor.

CREATE VIEW geral.vw_clientes_localizacao as
SELECT 
cidade.descricao as cidade,
estado.descricao as estado,
case when pf.id is not null then 'Pessoa Física'
	 when pj.id is not null then 'Pessoa Jurídica'
	 end as Tipo,
COUNT(*) quantidade
FROM geral.pessoa
left join geral.pessoa_fisica pf on pf.id = pessoa.id
left join geral.pessoa_juridica pj on pj.id = pessoa.id
inner join geral.endereco on endereco.id_pessoa = pessoa.id
inner join geral.bairro on bairro.id = endereco.id_bairro
inner join geral.cidade on bairro.id_cidade = cidade.id
inner join geral.estado on cidade.id_estado = estado.id
GROUP BY 1,2,3
ORDER BY quantidade desc;


-- 2. A gerência comercial deseja visualizar rapidamente o histórico de compras dos 
-- clientes. Crie uma VIEW chamada vw_resumo_clientes contendo as seguintes 
-- informações:
-- Cliente
-- Quantidade de notas fiscais
-- Valor total comprado
-- Ticket médio

CREATE VIEW vendas.vw_resumo_clientes as
SELECT 
	case
	when pessoa_fisica.nome is not null then pessoa_fisica.nome
	when pessoa_juridica.razao_social is not null then pessoa_juridica.razao_social
	end nome,
count(nota_fiscal.id) quantidade,
sum(nota_fiscal.valor) valor_total,
ROUND(avg(nota_fiscal.valor), 2) ticket_medio
FROM geral.pessoa
LEFT JOIN geral.pessoa_fisica on pessoa.id = pessoa_fisica.id
LEFT JOIN geral.pessoa_juridica on pessoa.id = pessoa_juridica.id
INNER JOIN vendas.nota_fiscal on nota_fiscal.id_cliente = pessoa.id
GROUP BY 1
ORDER BY 1;


-- 3. Crie uma VIEW chamada vw_desempenho_vendedores que contenha as seguintes 
-- informações para as vendas do mês passado:
-- Nome do vendedor
-- Quantidade de notas fiscais emitidas
-- Valor total vendido
-- Comissão (10% do valor total vendido)
CREATE VIEW vendas.vw_desempenho_vendedores as
SELECT 
pessoa_fisica.nome as nome,
COUNT(nota_fiscal.id) as qtd_nf,
SUM(nota_fiscal.valor)::money as valor_vendido,
SUM(nota_fiscal.valor * 0.1)::money as comissao
FROM geral.pessoa
INNER JOIN geral.pessoa_fisica on pessoa_fisica.id = pessoa.id
INNER JOIN vendas.nota_fiscal on nota_fiscal.id_vendedor = pessoa.id
WHERE data_venda >= DATE_TRUNC('month',CURRENT_DATE) - INTERVAL '1 month'
AND data_venda < DATE_TRUNC('month',CURRENT_DATE)
group by nome


-- 4. Crie uma VIEW chamada vw_produtos_vendidos que contenha as seguintes informações:
-- Produto
-- Categoria
-- Quantidade total vendida
-- Valor total vendido
-- Considerando as vendas dos últimos 6 meses.

CREATE VIEW vendas.vw_produtos_vendidos as
SELECT 
produto.nome,
categoria.descricao,
COUNT(item_nota_fiscal.quantidade),
SUM(nota_fiscal.valor)::money as soma_valor_nf
FROM vendas.nota_fiscal
INNER JOIN vendas.item_nota_fiscal ON item_nota_fiscal.id_nota_fiscal = nota_fiscal.id
LEFT JOIN vendas.produto ON produto.id = item_nota_fiscal.id_produto
INNER JOIN vendas.categoria ON categoria.id = produto.id_categoria
WHERE data_venda >= DATE_TRUNC('month',CURRENT_DATE) - INTERVAL '6 month'
AND data_venda < DATE_TRUNC('month',CURRENT_DATE)
GROUP BY nome, descricao

-- 5. Crie uma MATERIALIZED VIEW chamada mv_vendas_mensais que contenha as seguintes informações para as vendas:
-- Ano da Venda
-- Mês da Venda
-- Quantidade de Notas Fiscais
-- Valor Total Vendido
-- Ticket Médio

CREATE MATERIALIZED VIEW mv_vendas_mensais as
SELECT 
item_nota_fiscal.id_nota_fiscal as id_nf,
SUM(nota_fiscal.valor)::money as soma_valor_nf,
EXTRACT(MONTH FROM nota_fiscal.data_venda) as mes,
EXTRACT(YEAR FROM nota_fiscal.data_venda) as ano,
ROUND(AVG(nota_fiscal.valor),2)::money as ticket_medio
FROM vendas.nota_fiscal
INNER JOIN vendas.item_nota_fiscal ON item_nota_fiscal.id_nota_fiscal = nota_fiscal.id
GROUP BY id_nota_fiscal, mes, ano
ORDER BY ano DESC

-- 5.1. Consulta view

SELECT * FROM mv_vendas_mensais, comments

COMMENT ON MATERIALIZED VIEW mv_vendas_mensais
IS 'Relatório mensal de vendas.
Atualizado um dia antes
Fonte: schema vendas.
Responsável: data_girl'

-- 5.2. Refresh view

REFRESH MATERIALIZED VIEW mv_vendas_mensais
