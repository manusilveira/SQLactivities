-------------------- Desafio 2
-- 1. Quantidade mínima de matrículas
-- Liste as escolas com mais de 5 matrículas, exibindo: nome da escola, 
-- total de matrículas e Ordene pelo maior número de matrículas.

SELECT 
escola.nome_escola,
COUNT(matricula.id) as total_matriculas
FROM academico.matricula
INNER JOIN academico.escola ON matricula.id_escola = escola.id
GROUP BY escola.nome_escola
HAVING COUNT(*) > 5
ORDER BY total_matriculas DESC

-- 2. Média de notas por disciplina filtrada
-- Mostre as disciplinas com média de notas acima de 7, em ordem decrescente da
-- média. Inclua: nome da disciplina, média das notas

SELECT 
disciplina.descricao,
ROUND(AVG(matricula.nota),0) as media_notas
FROM academico.matricula
INNER JOIN academico.disciplina ON matricula.id_disciplina = disciplina.id
GROUP BY disciplina.descricao
HAVING AVG(matricula.nota) > 7
ORDER BY media_notas DESC

-- 3. Séries com mais alunos Femininos
-- Liste as séries que possuem pelo menos 3 estudantes do gênero feminino, 
-- mostrando: série, total de estudantes femininas.
-- Ordene da maior para a menor.

SELECT 
serie.descricao,
COUNT(estudantes.id) as total_estudantes,
genero.descricao
FROM academico.estudantes
INNER JOIN academico.serie ON estudantes.id_serie = serie.id
INNER JOIN academico.genero ON estudantes.id_genero = genero.id
WHERE genero.descricao = 'Feminino'
GROUP BY serie.descricao, genero.descricao
ORDER BY total_estudantes DESC

-- 4. Desempenho por disciplina nas séries avançadas
-- Exiba as disciplinas com mais de 4 matrículas na 8ª ou 9ª série,
-- mostrando: nome da disciplina, quantidade de matrículas.
-- Ordenando: 1º pela série (crescente) 2º pelas maiores quantidades

SELECT 
disciplina.descricao as disciplinas,
COUNT(matricula.id) as total_matriculas,
serie.descricao as serie
FROM academico.matricula
INNER JOIN academico.estudantes ON matricula.id_estudante = estudantes.id
INNER JOIN academico.disciplina ON matricula.id_disciplina = disciplina.id
INNER JOIN academico.serie ON estudantes.id_serie = serie.id
WHERE serie.descricao = '8 série' OR serie.descricao = '9 série'
GROUP BY disciplina.descricao, serie.descricao
ORDER BY serie.descricao ASC, total_matriculas DESC
