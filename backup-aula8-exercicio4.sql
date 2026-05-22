------------------------- Exercícios 4
-- 1. Mose tras escolas com mais de 2 matrículas, ordenadas pelo total.

SELECT 
escola.nome_escola,
COUNT(matricula.id) AS total_matriculas
FROM academico.escola 
INNER JOIN academico.matricula ON matricula.id_escola = escola.id
GROUP BY escola.nome_escola
HAVING COUNT(matricula.id) > 6000
ORDER BY total_matriculas DESC;

select * -- 5834
FROM academico.escola 
INNER JOIN academico.matricula ON matricula.id_escola = escola.id
where escola.nome_escola = 'Escola N'

-- 2. Exiba a média de nota por escola e disciplina.

SELECT 
AVG(nota) as media_nota,
disciplina.descricao,
escola.nome_escola
FROM academico.matricula
INNER JOIN academico.disciplina ON matricula.id_disciplina = disciplina.id
INNER JOIN academico.escola ON matricula.id_escola = escola.id
GROUP BY disciplina.descricao, escola.nome_escola

-- 3. Liste os gêneros com mais de 3 estudantes cadastrados.

SELECT 
genero.descricao,
COUNT(estudantes.id) as total_estudantes
FROM academico.estudantes 
INNER JOIN academico.genero ON estudantes.id_genero = genero.id
GROUP BY genero.descricao
HAVING COUNT(*) > 3

-- 4. Mostre as 3 disciplinas com maior média de nota.

SELECT 
disciplina.descricao,
ROUND(AVG(matricula.nota),0) as media_nota
FROM academico.matricula 
INNER JOIN academico.disciplina ON matricula.id_disciplina = disciplina.id
GROUP BY disciplina.descricao
ORDER BY media_nota DESC
LIMIT 3

-- 5. Liste a quantidade de matrículas por série, apenas para séries com
-- mais de 4 estudantes.

SELECT 
serie.descricao,
COUNT(matricula.id) as total_matriculas
FROM academico.estudantes
INNER JOIN academico.matricula ON matricula.id_estudante = estudantes.id
INNER JOIN academico.serie ON estudantes.id_serie = serie.id
GROUP BY serie.descricao
HAVING COUNT(*) > 4