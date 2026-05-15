---------------- EXERCÍCIO 1

-- Liste os nomes das escolas com orçamento superior a 2.000.000
-- ou inferior a 500.000

SELECT 
nome_escola,
orcamento_anual
FROM academico.escola
WHERE orcamento_anual > 2000000 OR orcamento_anual < 500000 

-- Liste os estudantes que estão matriculados nas séries com IDs 1, 2
-- ou 4

SELECT 
estudantes.nome_estudante,
serie.id
FROM academico.estudantes
inner join academico.serie on estudantes.id_serie = serie.id
WHERE serie.id = 1 OR serie.id = 2 OR serie.id = 4

-- Recupere os estudantes cujo nome comece com a letra "A"

SELECT 
estudantes.nome_estudante
FROM academico.estudantes
WHERE nome_estudante
LIKE 'A_%'

-- Mostre as escolas com orçamento entre 1.000.000 e 3.000.000

SELECT 
nome_escola,
orcamento_anual
FROM academico.escola
WHERE orcamento_anual
BETWEEN 1000000 AND 3000000

-- Liste os estudantes do gênero feminino (sigla = 'F') que estão
-- matriculados na 9ª série (descrição = '9ª Série').

SELECT 
estudantes.nome_estudante,
genero.sigla,
serie.descricao
FROM academico.estudantes
inner join academico.serie on estudantes.id_serie = serie.id
inner join academico.genero on estudantes.id_genero = genero.id
WHERE genero.sigla = 'F' AND serie.descricao = '9 série'