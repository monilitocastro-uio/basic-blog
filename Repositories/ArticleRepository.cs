using Dapper;
using MoniliToDapper.Models;
using System.Data;

namespace MoniliToDapper.Repositories
{
    public class ArticleRepository : IArticleRepository
    {
        private readonly IDbConnection _dbConnection;

        public ArticleRepository(IDbConnection dbConnection)
        {
            _dbConnection = dbConnection;
        }

        public async Task<IEnumerable<ArticleModel>> GetAllArticlesAsync()
        {
            var query = "SELECT * FROM articles";
            return await _dbConnection.QueryAsync<ArticleModel>(query);
        }

        public async Task<ArticleModel?> GetArticleByIdAsync(int id)
        {
            var query = "SELECT * FROM articles WHERE id = @Id";
            return await _dbConnection.QueryFirstOrDefaultAsync<ArticleModel>(query, new { Id = id });
        }

        public async Task<int> CreateArticleAsync(ArticleModel article)
        {
            var query = @"
                INSERT INTO articles (title, content, author, publish_date, is_unpublished) 
                VALUES (@Title, @Content, @Author, @PublishDate, @IsUnpublished)
                RETURNING id";
            return await _dbConnection.QuerySingleAsync<int>(query, article);
        }

        public async Task<bool> UpdateArticleAsync(ArticleModel article)
        {
            var query = @"
                UPDATE articles 
                SET title = @Title, 
                    content = @Content, 
                    author = @Author, 
                    publish_date = @PublishDate, 
                    is_unpublished = @IsUnpublished
                WHERE id = @Id";
            
            var affectedRows = await _dbConnection.ExecuteAsync(query, article);
            return affectedRows > 0;
        }

        public async Task<bool> DeleteArticleAsync(int id)
        {
            var query = "DELETE FROM articles WHERE id = @Id";
            var affectedRows = await _dbConnection.ExecuteAsync(query, new { Id = id });
            return affectedRows > 0;
        }
    }
}
