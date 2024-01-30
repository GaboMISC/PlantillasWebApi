using AutoMapper;
using Microservicio._02.Application.Business.Handlers;
using Microservicio._03.Infraestructure.AutoMapper;
using Microservicio.Application.Business;
using Microservicio.Application.Business.Contracts;
using Microsoft.AspNetCore.Mvc;

namespace Microservicio
{
    public static class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            // *** Auto Mapper ***
            var mapperConfiguration = new MapperConfiguration(cfg =>
            {
                cfg.AddProfile(new AutoMapperProfiles()); // Clase Mapper en Handdlers
            });
            var mapper = mapperConfiguration.CreateMapper();
            builder.Services.AddSingleton(mapper);
            // --------------------------------------------------

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // *** Business ***
            builder.Services.AddTransient<IValidationBusiness, ValidationBusiness>();
            // --------------------------------------------------

            // *** Control de errores en todos los controladores ***
            builder.Services.AddControllers(options =>
            {
                options.Filters.Add<ErrorHandler>();
            });
            // --------------------------------------------------

            // Errores Data Notations
            builder.Services.Configure<ApiBehaviorOptions>(options =>
            {
                options.InvalidModelStateResponseFactory = actionContext =>
                {
                    return DataNotationsErrorHandler.CustomErrorResponse(actionContext);
                };
            });
            // --------------------------------------------------

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseAuthorization();
            app.MapControllers();
            app.Run();
        }
    }
}