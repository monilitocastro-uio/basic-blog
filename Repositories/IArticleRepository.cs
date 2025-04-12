using MoniliToDapper.Models;

namespace MoniliToDapper.Repositories
{
    public interface IArticleRepository
    {
        Task<IEnumerable<ArticleModel>> GetAllArticlesAsync();
        Task<ArticleModel?> GetArticleByIdAsync(int id);
        Task<int> CreateArticleAsync(ArticleModel article);
        Task<bool> UpdateArticleAsync(ArticleModel article);
        Task<bool> DeleteArticleAsync(int id);
    }
}
