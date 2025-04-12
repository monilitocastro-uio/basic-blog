-- First, delete the sample data that was inserted
DELETE FROM articles 
WHERE (title = 'Getting Started with Dapper' AND author = 'John Doe')
   OR (title = 'PostgreSQL Best Practices' AND author = 'Jane Smith');

-- Then, drop the articles table
DROP TABLE IF EXISTS articles;