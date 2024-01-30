using Microsoft.EntityFrameworkCore;
using WebApiEntityFramework.Data;
using WebApiEntityFramework.Handlers;
using WebApiEntityFramework.Repositories;

/* ---------- *** Nuggets *** ----------
 * Microsoft.EntityFrameworkCore.Design
 * Microsoft.EntityFrameworkCore.SqlServer
 * 
 * Cambiar la siguiente etiqueta de true a false o eliminarla para Entity Framework por el tema del idioma.
    <InvariantGlobalization>false</InvariantGlobalization>
// -------------------------------------------------- */

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ---------- *** Entity Framework *** ----------
builder.Configuration.AddJsonFile("appsettings.json");

builder.Services.AddDbContext<EmployeeContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlServerOptionsAction => sqlServerOptionsAction.EnableRetryOnFailure()));
// --------------------------------------------------

// ---------- *** Repositories *** ----------
builder.Services.AddScoped<EmployeeRepository>();
// --------------------------------------------------

// ---------- *** Control de errores en todos los controladores *** ----------
builder.Services.AddControllers(options =>
{
    options.Filters.Add<ErrorHandler>();
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