using Microsoft.Extensions.Configuration;

namespace monilitodapper.Services
{
    public class BlogConfig
    {
        private readonly IConfiguration _configuration;

        public BlogConfig(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string Name => _configuration["Blog:Name"] ?? "Monilito";
    }
}
