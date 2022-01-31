using apim_devops_demos.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//// Use the commented out version to run without a storage account
//builder.Services.AddSingleton<ITodoRepository>(s=>new InMemoryTodoRepository());

//// To run this locally use either the Azure Storage Emulator or Azurite
builder.Services.AddSingleton<ITodoRepository>(s => new TableStorageTodoRepository(builder.Configuration));

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
