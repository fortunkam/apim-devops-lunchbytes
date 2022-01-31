namespace apim_devops_demos.Models;


/// <summary>
/// Implementation of <c href="ITodoRepository">ITodoRepository</c> that uses an in memory list to store the data
/// Will give you odd results if used in a load balanced environment!
/// </summary>
public class InMemoryTodoRepository : ITodoRepository
{
    public InMemoryTodoRepository()
    {
        if (this._todoItems == null)
        {
            this._todoItems = new List<TodoItem>();
            this._todoItems.Add(new TodoItem { Id = 1, Name = "Item 1", IsComplete = false });
        }
    }

    private readonly List<TodoItem> _todoItems;

    public async Task Add(TodoItem item)
    {
        await Task.Run(() => this._todoItems.Add(item));
    }

    public async Task Remove(long id)
    {
        await Task.Run(() => this._todoItems.RemoveAll(i => i.Id == id));
    }

    public async Task<TodoItem?> Get(long id)
    {
        return await Task.Run(() =>
        {
            var todoItem = this._todoItems.FirstOrDefault(i => i.Id == id);
            return todoItem;
        });
    }

    public async IAsyncEnumerable<TodoItem> GetAll()
    {
        foreach(var item in this._todoItems)
        {
            yield return item;
        }
        
    }

    public async Task Update(TodoItem item)
    {
        await Task.Run(() =>
        {
            var todoItem = this._todoItems.FirstOrDefault(i => i.Id == item.Id);
            if (todoItem != null)
            {
                todoItem.IsComplete = item.IsComplete;
                todoItem.Name = item.Name;
            }
        });
    }
}
