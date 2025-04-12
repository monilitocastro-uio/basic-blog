CREATE TABLE IF NOT EXISTS articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(100) NOT NULL,
    publish_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_unpublished BOOLEAN NOT NULL DEFAULT FALSE
);

-- Optional: Insert some sample data
INSERT INTO articles (title, content, author, publish_date, is_unpublished)
VALUES 
    ('Getting Started with Dapper', 'This is a tutorial about Dapper ORM...', 'John Doe', CURRENT_TIMESTAMP, false),
    ('PostgreSQL Best Practices', 'Learn how to optimize your PostgreSQL database...', 'Jane Smith', CURRENT_TIMESTAMP, false);
