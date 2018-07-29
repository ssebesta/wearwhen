using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using WearWhenApi.Data;
using WearWhenApi.Models;
using WearWhenApi.Repositories;

namespace WearWhenApi
{
    public class Startup
    {        
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }               
        
        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<DbConfig>(Configuration.GetSection("ConnectionStrings"));

            services.AddMvc();

            services.AddTransient<IDbConnectionFactory, DbConnectionFactory>();
            services.AddTransient<IAccountRepository, AccountRepository>();
            services.AddTransient<IRepository<ClothingItem>, ClothingItemRepository>();
            services.AddTransient<IRepository<Outfit>, OutfitRepository>();            
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseMvc();

            app.UseMvc(routes =>
            {
                // Default route
                routes.MapRoute(
                  name: "default",
                  //template: "{controller=Home}/{action=Index}/{id?}");
                  template: "{controller=Home}/{action}/{id?}");
            });
        }
    }
}
