using Microsoft.AspNetCore.Mvc;
using MoniliToDapper.Models;
using MoniliToDapper.Repositories;

namespace MoniliToDapper.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ArticlesController : ControllerBase
    {
        private readonly IArticleRepository _articleRepository;

        public ArticlesController(IArticleRepository articleRepository)
        {
            _articleRepository = articleRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ArticleModel>>> GetAllArticles()
        {
            var articles = await _articleRepository.GetAllArticlesAsync();
            return Ok(articles);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ArticleModel>> GetArticleById(int id)
        {
            var article = await _articleRepository.GetArticleByIdAsync(id);
            if (article == null)
            {
                return NotFound();
            }
            return Ok(article);
        }

        [HttpPost]
        public async Task<ActionResult<int>> CreateArticle(ArticleModel article)
        {
            var id = await _articleRepository.CreateArticleAsync(article);
            return CreatedAtAction(nameof(GetArticleById), new { id }, id);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateArticle(int id, ArticleModel article)
        {
            if (id != article.Id)
            {
                return BadRequest();
            }
            
            var success = await _articleRepository.UpdateArticleAsync(article);
            if (!success)
            {
                return NotFound();
            }
            
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteArticle(int id)
        {
            var success = await _articleRepository.DeleteArticleAsync(id);
            if (!success)
            {
                return NotFound();
            }
            
            return NoContent();
        }
    }
}
