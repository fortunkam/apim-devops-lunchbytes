using Microsoft.AspNetCore.Mvc;
using apim_devops_demos.Models;

namespace apim_devops_demos.Controllers;


[ApiController]
[Route("[controller]")]
public class TodoController : ControllerBase
{
    private readonly ITodoRepository _repository;

    public TodoController(ITodoRepository repository)
    {
        _repository = repository;
    }

    // GET: Todo
    [HttpGet]
    public async Task<ActionResult<IEnumerable<TodoItem>>> GetTodoItem()
    {
        return new JsonResult(_repository.GetAll());
    }

    // GET: Todo/5
    [HttpGet("{id}")]
    public async Task<ActionResult<TodoItem>> GetTodoItem(long id)
    {
        var todoItem = await _repository.Get(id);

        if (todoItem == null)
        {
            return NotFound(id);
        }

        return todoItem;
    }

    [HttpPut("{id}")]
    public async Task<ActionResult> PutTodoItem(long id, TodoItem todoItem)
    {
        if (id != todoItem.Id)
        {
            return BadRequest();
        }

        await _repository.Add(todoItem);
        
        return CreatedAtAction("PutTodoItem", new { id = todoItem.Id }, todoItem);
    }

    [HttpPost]
    public async Task<ActionResult<TodoItem>> PostTodoItem(TodoItem todoItem)
    {
        await _repository.Update(todoItem);

        return CreatedAtAction("PostTodoItem", new { id = todoItem.Id }, todoItem);
    }

    // DELETE: api/Todo/5
    [HttpDelete("{id}")]
    public async Task<ActionResult<TodoItem>> DeleteTodoItem(long id)
    {
        var todoItem = await _repository.Get(id);
        if (todoItem == null)
        {
            return NotFound();
        }
        await _repository.Remove(id);
        return todoItem;
    }

}