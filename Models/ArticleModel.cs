namespace MoniliToDapper.Models
{
    public class ArticleModel
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string Author { get; set; } = string.Empty;
        public DateTime PublishDate { get; set; }
        public bool IsUnpublished { get; set; }
    }
}
