---------------- DESAFIO 1

-- Liste os nomes dos estudantes e os nomes das suas respectivas 
-- escolas, apenas para estudantes do gênero Feminino.

SELECT 
estudantes.nome_estudante,
escola.nome_escola,
genero.descricao
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.escola on escola.id = matricula.id_escola
inner join academico.genero on estudantes.id_genero = genero.id
WHERE descricao = 'Feminino'

-- Exiba os estudantes e as disciplinas em que estão matriculados,
-- somente para notas abaixo de 60.

SELECT 
estudantes.nome_estudante,
disciplina.descricao,
matricula.nota
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.disciplina on disciplina.id = matricula.id_disciplina
WHERE matricula.nota < 60


-- Liste os nomes dos estudantes que estudam na escola com o
-- nome contendo "Escola N".

SELECT 
estudantes.nome_estudante,
escola.nome_escola
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.escola on escola.id = matricula.id_escola
WHERE nome_escola = 'Escola Sol Nascente'


-- Mostre o nome da escola, a disciplina e os estudantes
-- matriculados apenas nas séries 8ª ou 9ª

SELECT 
escola.nome_escola,
disciplina.descricao,
estudantes.nome_estudante,
serie.descricao
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.disciplina on matricula.id_disciplina = disciplina.id
inner join academico.escola on escola.id = matricula.id_escola
inner join academico.serie on serie.id = estudantes.id_serie
WHERE serie.descricao = '8 série' OR serie.descricao = '9 série' 

-- Liste os estudantes do gênero Masculino que estão matriculados
-- em disciplinas onde a descrição contenha '8'Mat'

SELECT 
disciplina.descricao,
estudantes.nome_estudante,
genero.descricao
FROM academico.estudantes
inner join academico.matricula on estudantes.id = matricula.id_estudante
inner join academico.disciplina on matricula.id_disciplina = disciplina.id
inner join academico.genero on genero.id = estudantes.id_genero
WHERE disciplina.descricao like '%Mat%' AND genero.descricao = 'Masculino'
