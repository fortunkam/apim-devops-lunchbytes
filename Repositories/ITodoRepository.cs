using apim_devops_demos.Models;

namespace apim_devops_demos.Repositories;

public interface ITodoRepository
{
    Task Add(TodoItem item);
    Task<TodoItem?> Get(long id);
    IAsyncEnumerable<TodoItem> GetAll();
    Task Remove(long id);
    Task Update(TodoItem item);
}
