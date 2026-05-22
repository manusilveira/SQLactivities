----------------------------- Exercícios 3
-- 1. Liste o total de estudantes por série.

SELECT 
serie.descricao,
COUNT(*) AS soma_series
FROM academico.estudantes
INNER JOIN academico.serie ON estudantes.id_serie = serie.id
GROUP BY serie.descricao

-- 2. Liste as disciplinas com mais de 3000 matrículas.

SELECT 
disciplina.descricao,
count (*) as qtd_matricula
FROM academico.disciplina
INNER JOIN academico.matricula ON matricula.id_disciplina = disciplina.id
GROUP BY disciplina.descricao
HAVING COUNT(DISTINCT id_estudante) > 3000

-- 3. Mostre a média de notas por disciplina, ordenada da maior para a menor.

SELECT 
disciplina.descricao,
AVG(nota) as media_nota
FROM academico.matricula
INNER JOIN academico.disciplina ON matricula.id_disciplina = disciplina.id
GROUP BY disciplina.descricao
ORDER BY media_nota DESC

-- 4. Mostre os 5 estudantes com maior média de nota.

SELECT 
estudantes.id,
estudantes.nome_estudante,
AVG(nota) as media_nota
FROM academico.estudantes
INNER JOIN academico.matricula ON estudantes.id = matricula.id_estudante
GROUP BY estudantes.nome_estudante
ORDER BY media_nota DESC
LIMIT 5

-- 5. Liste a quantidade de escolas por tipo de escola.

SELECT 
tipo_escola.descricao,
COUNT(*) as qtd_escola
FROM academico.escola
INNER JOIN academico.tipo_escola ON escola.id_tipo_escola = tipo_escola.id
GROUP BY tipo_escola.descricao