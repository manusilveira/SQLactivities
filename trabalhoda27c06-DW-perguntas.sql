-- Quais planos de saúde possuem maior valor de cobrança?

SELECT 
plano_de_saude,
SUM(total_cobrado) as total_cobrado,
SUM(total_pago) as total_pago
FROM (-- aqui inicia a subquery
SELECT 
dsin.id,
dps.nome_pagador as plano_de_saude,
dsin.total_cobrado as total_cobrado,
SUM(dwft.total_pago) as total_pago
FROM data_warehouse.fato_transacoes dwft
inner join data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
inner join data_warehouse.dim_sinistro dsin ON dsin.id = dwft.id_sinistro
GROUP BY 1,2,3 )
 AS grao_por_sinistro -- aqui termina a subquery
GROUP BY plano_de_saude
ORDER BY total_cobrado DESC;

-- Quais pagadores são responsáveis pelos maiores valores?

SELECT 
COALESCE (dps.nome_pagador, 'Paciente') as pagador,
SUM(dwft.total_pago) as total_pago
FROM data_warehouse.fato_transacoes dwft
LEFT JOIN data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
GROUP BY 1
ORDER BY total_pago DESC


-- Quanto foi pago pelos planos de saúde?

SELECT
pgto_por_plano.plano,
SUM(pgto_por_plano.valor_sinistro) as valor_sinistro,
SUM(pgto_por_plano.total_pago) as total_pago,
(SUM(pgto_por_plano.total_pago) / SUM(pgto_por_plano.valor_sinistro)) * 100 as pct
FROM (
	SELECT 
		dt.id as id_tipo,
		dps.nome_pagador as plano,
		dsin.id,
		dsin.total_cobrado as valor_sinistro,
		SUM(dwft.total_pago) as total_pago
	FROM data_warehouse.fato_transacoes dwft
	INNER JOIN data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
	inner join data_warehouse.dim_sinistro dsin ON dsin.id = dwft.id_sinistro
	inner join data_warehouse.dim_tipo dt ON dt.id = dwft.id_tipo
	WHERE dt.descricao = 'Plano'
	GROUP BY 1,2,3,4
) AS pgto_por_plano
GROUP BY 1
ORDER BY total_pago DESC


-- Quanto foi pago diretamente pelos pacientes?

SELECT 
dt.id,
COALESCE (dps.nome_pagador, 'Paciente') as pagador,
SUM(dwft.total_pago) as total_pago
FROM data_warehouse.fato_transacoes dwft
LEFT JOIN data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
LEFT JOIN data_warehouse.dim_tipo dt ON dt.id = dwft.id_tipo
where dt.id = 3
GROUP BY 1,2
ORDER BY total_pago DESC


-- Qual a participação do plano e do paciente no valor total?

SELECT
  	COALESCE(pgto_por_plano.pagador, 'Paciente') AS pagador,
	SUM(pgto_por_plano.total_pago) as s_valor_pago,
	SUM(pgto_por_plano.valor_sinistro) as s_valor_sinistro,
	SUM(pgto_por_plano.valor_sinistro) - SUM(pgto_por_plano.total_pago) as s_valor_restante,
		ROUND(  (SUM(pgto_por_plano.total_pago) / SUM(pgto_por_plano.valor_sinistro)) ,0) as porc_paga,
		ROUND(  ((SUM(pgto_por_plano.valor_sinistro) - SUM(pgto_por_plano.total_pago)) / SUM(pgto_por_plano.valor_sinistro))
		,0) as porc_restante
		FROM (
    		SELECT
			 dt.id as id_tipo,
			 dsin.id as id_sin,
       		 dps.nome_pagador as pagador,
       		 dsin.total_cobrado as valor_sinistro,
       		 SUM(dwft.total_pago) as total_pago
    		 FROM data_warehouse.fato_transacoes dwft
    		 left JOIN data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
    		 left join data_warehouse.dim_sinistro dsin ON dsin.id = dwft.id_sinistro
    		 left join data_warehouse.dim_tipo dt ON dt.id = dwft.id_tipo
    		 GROUP BY 1,2,3,4
		) AS pgto_por_plano
WHERE pgto_por_plano.id_tipo = 3 OR pgto_por_plano.id_tipo = 2
GROUP BY 1
ORDER BY s_valor_sinistro DESC


-- Quais planos possuem maior quantidade de atendimentos associados?

SELECT 
dps.nome_pagador,
COUNT (DISTINCT dwft.id_atendimento) as num_atendimentos
FROM data_warehouse.fato_transacoes dwft
left JOIN data_warehouse.dim_plano_saude dps ON dps.id = dwft.id_plano_saude
left join data_warehouse.dim_tipo dt ON dt.id = dwft.id_tipo
WHERE dps.nome_pagador IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC


-- Quais planos apresentam maior valor médio por atendimento?

SELECT
    COALESCE(por_atendimento.pagador, 'Paciente') AS pagador,
    AVG(por_atendimento.valor_atendimento) AS valor_medio
FROM (
    -- Segunda etapa: uma linha por atendimento
    SELECT
        por_sinistro.id_atendimento,
        por_sinistro.pagador,
        SUM(por_sinistro.valor_sinistro) AS valor_atendimento
    FROM (
        -- Primeira etapa: uma linha por sinistro
        SELECT
            dwft.id_atendimento,
            dps.nome_pagador AS pagador,
            dsin.id AS id_sinistro,
            dsin.total_cobrado AS valor_sinistro
        FROM data_warehouse.fato_transacoes dwft
        LEFT JOIN data_warehouse.dim_plano_saude dps
            ON dps.id = dwft.id_plano_saude
        LEFT JOIN data_warehouse.dim_sinistro dsin
            ON dsin.id = dwft.id_sinistro
        GROUP BY
            dwft.id_atendimento,
            dps.nome_pagador,
            dsin.id,
            dsin.total_cobrado
    ) AS por_sinistro
    GROUP BY
        por_sinistro.id_atendimento,
        por_sinistro.pagador
) AS por_atendimento
GROUP BY
    por_atendimento.pagador
ORDER BY
    valor_medio DESC;





--- Atualização do banco original
update financeiro.transacoes_financeiras
set id_tipo = 3
where id_tipo is null;

















-----------------
ROUND(
    100.0 * SUM(CASE WHEN pgto_por_plano.id_tipo = 3 THEN pgto_por_plano.total_pago END)
    / (SUM(pgto_por_plano.valor_sinistro)), 0
  	) AS pct_paciente,
	ROUND(
 	100.0 * SUM(CASE WHEN pgto_por_plano.id_tipo = 2 THEN pgto_por_plano.total_pago END)
	/ (SUM(pgto_por_plano.valor_sinistro)), 0
	) AS pct_plano,
