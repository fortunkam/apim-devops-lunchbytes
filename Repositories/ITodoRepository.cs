namespace apim_devops_demos.Models;

public interface ITodoRepository
{
    Task Add(TodoItem item);
    Task<TodoItem?> Get(long id);
    IAsyncEnumerable<TodoItem> GetAll();
    Task Remove(long id);
    Task Update(TodoItem item);
}
