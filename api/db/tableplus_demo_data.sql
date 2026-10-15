-- Dados de demonstração para executar no TablePlus (SQLite).
-- Execute cada bloco uma vez. Os emails e ISBNs fixos evitam duplicação
-- se você rodar novamente. A senha comum dos 15 usuários é: senha123
-- O password_digest abaixo é um hash BCrypt compatível com has_secure_password.

BEGIN TRANSACTION;

INSERT OR IGNORE INTO users (name, email, password_digest) VALUES
  ('Ana Silva', 'ana.silva@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Bruno Costa', 'bruno.costa@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Camila Oliveira', 'camila.oliveira@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Daniel Santos', 'daniel.santos@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Eduarda Lima', 'eduarda.lima@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Felipe Almeida', 'felipe.almeida@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Gabriela Rocha', 'gabriela.rocha@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Henrique Martins', 'henrique.martins@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Isabela Ferreira', 'isabela.ferreira@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('João Pedro Ribeiro', 'joao.ribeiro@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Larissa Gomes', 'larissa.gomes@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Marcos Carvalho', 'marcos.carvalho@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Natália Mendes', 'natalia.mendes@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Otávio Barros', 'otavio.barros@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK'),
  ('Paula Nascimento', 'paula.nascimento@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6YQ6W8f7Z4fJkSxZ7YqN5xwQmZ5uK');

-- Vincula os livros aos usuários pelos emails, sem depender dos IDs gerados.
INSERT OR IGNORE INTO books
  (title, author, category, isbn, price_cents, stock, description, user_id, created_at, updated_at)
SELECT demo.title, demo.author, demo.category, demo.isbn, demo.price_cents,
       demo.stock, demo.description, users.id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM (
  SELECT 'O cortiço' AS title, 'Aluísio Azevedo' AS author, 'Literatura brasileira' AS category, '9788535910667' AS isbn, 3990 AS price_cents, 7 AS stock, 'Romance naturalista ambientado no Rio de Janeiro.' AS description, 'ana.silva@example.com' AS email
  UNION ALL SELECT 'Capitães da Areia', 'Jorge Amado', 'Literatura brasileira', '9788535911695', 4590, 5, 'A vida de um grupo de meninos nas ruas de Salvador.', 'bruno.costa@example.com'
  UNION ALL SELECT 'Grande Sertão: Veredas', 'João Guimarães Rosa', 'Literatura brasileira', '9788520923257', 6990, 3, 'Uma jornada pelo sertão e pela memória de Riobaldo.', 'camila.oliveira@example.com'
  UNION ALL SELECT 'A paixão segundo G.H.', 'Clarice Lispector', 'Literatura brasileira', '9788532508599', 4290, 4, 'Romance introspectivo de Clarice Lispector.', 'daniel.santos@example.com'
  UNION ALL SELECT 'Memórias Póstumas de Brás Cubas', 'Machado de Assis', 'Literatura brasileira', '9788535910668', 3590, 9, 'Narrado por um defunto autor, com humor e ironia.', 'eduarda.lima@example.com'
  UNION ALL SELECT 'Vidas Secas', 'Graciliano Ramos', 'Literatura brasileira', '9788501067344', 3290, 6, 'A trajetória de uma família pelo sertão nordestino.', 'felipe.almeida@example.com'
  UNION ALL SELECT 'A Revolução dos Bichos', 'George Orwell', 'Ficção', '9788535909555', 2790, 11, 'Uma fábula política sobre poder e revolução.', 'gabriela.rocha@example.com'
  UNION ALL SELECT 'Fahrenheit 451', 'Ray Bradbury', 'Ficção', '9788525052244', 3890, 8, 'Uma sociedade que proíbe livros e incentiva o esquecimento.', 'henrique.martins@example.com'
  UNION ALL SELECT 'A Metamorfose', 'Franz Kafka', 'Ficção', '9788535914846', 2590, 10, 'Gregor Samsa desperta transformado em um inseto.', 'isabela.ferreira@example.com'
  UNION ALL SELECT 'Duna', 'Frank Herbert', 'Ficção', '9788576573138', 7990, 4, 'Intrigas políticas e ecológicas no planeta Arrakis.', 'joao.ribeiro@example.com'
  UNION ALL SELECT 'O Hobbit', 'J. R. R. Tolkien', 'Ficção', '9788595084742', 5490, 7, 'Bilbo Bolseiro parte em uma aventura inesperada.', 'larissa.gomes@example.com'
  UNION ALL SELECT 'Estruturas de Dados e Algoritmos', 'Michael T. Goodrich', 'Tecnologia', '9788582600270', 12990, 2, 'Introdução a estruturas de dados e algoritmos.', 'marcos.carvalho@example.com'
  UNION ALL SELECT 'Use a Cabeça! Java', 'Kathy Sierra', 'Tecnologia', '9788576081739', 11990, 3, 'Aprenda fundamentos de programação com exemplos visuais.', 'natalia.mendes@example.com'
  UNION ALL SELECT 'O Andar do Bêbado', 'Leonard Mlodinow', 'Não ficção', '9788575424039', 4990, 5, 'Como o acaso influencia nossas vidas e decisões.', 'otavio.barros@example.com'
  UNION ALL SELECT 'Sentimento do Mundo', 'Carlos Drummond de Andrade', 'Poesia', '9788501009697', 3190, 6, 'Poemas de uma das fases marcantes de Drummond.', 'paula.nascimento@example.com'
) AS demo
JOIN users ON users.email = demo.email;

COMMIT;

-- Verificação: deve retornar 15 para cada tabela quando não havia esses dados antes.
SELECT 'users' AS tabela, COUNT(*) AS total FROM users
WHERE email LIKE '%@example.com'
UNION ALL
SELECT 'books', COUNT(*) FROM books
WHERE isbn IN (
  '9788535910667','9788535911695','9788520923257','9788532508599','9788535910668',
  '9788501067344','9788535909555','9788525052244','9788535914846','9788576573138',
  '9788595084742','9788582600270','9788576081739','9788575424039','9788501009697'
);
