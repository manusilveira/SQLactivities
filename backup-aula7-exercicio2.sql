---------------- EXERCÍCIO 2
-- Liste os estudantes do gênero masculino (sigla = 'M') que estejam
-- nas séries de ID 1 ou 2.

SELECT 
estudantes.nome_estudante,
genero.sigla,
serie.id
FROM academico.estudantes
inner join academico.genero on estudantes.id_genero = genero.id
inner join academico.serie on estudantes.id_serie = serie.id
WHERE serie.id = 1 OR serie.id = 2 

-- Liste os nomes das disciplinas que contêm a palavra 'Mat'.

SELECT 
disciplina.descricao
FROM academico.disciplina
WHERE descricao LIKE '%Mat%'

-- Liste os estudantes que pertencem à série com ID IN (2, 3, 4) e
-- cujas notas estejam entre 60 e 100.

SELECT 
estudantes.nome_estudante,
serie.id,
matricula.nota
FROM academico.estudantes
inner join academico.serie on estudantes.id_serie = serie.id
inner join academico.matricula on estudantes.id = matricula.id_estudante
WHERE (
serie.id IN ('2','3','4')
AND nota BETWEEN 60 AND 100)

-- Encontre as escolas cujo nome termine com 'N' e tenham
-- orçamento maior que 1.500.000.

SELECT 
escola.nome_escola,
escola.orcamento_anual
FROM academico.escola
WHERE nome_escola LIKE '%N'
AND orcamento_anual > 1500000

-- Liste os nomes dos estudantes e suas respectivas disciplinas para
-- os estudantes com IDs IN (1, 3, 5).

SELECT 
estudantes.id,
estudantes.nome_estudante,
disciplina.descricao
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.disciplina on matricula.id_disciplina = disciplina.id
WHERE estudantes.id IN ('1','3','5')
