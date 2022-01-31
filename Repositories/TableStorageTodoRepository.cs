using Azure;
using Azure.Data.Tables;

namespace apim_devops_demos.Models;

/// <summary>
/// mplementation of <c href="ITodoRepository">ITodoRepository</c> that uses Azure Table Storage to store the data
/// </summary>
public class TableStorageTodoRepository : ITodoRepository
{
    private const string TableName = "Todo";
    private const string PartitionKey = "Common";
    private readonly TableClient _tableClient;


    public TableStorageTodoRepository(IConfiguration configuration)
    {
        _tableClient = new TableClient(configuration["StorageConnectionString"], TableName);
        _tableClient.CreateIfNotExists();
    }

    public async Task Add(TodoItem item)
    {
        await _tableClient.UpsertEntityAsync(new TableEntity(PartitionKey, item.Id.ToString())
        {
            {"Name", item.Name },
            {"IsComplete", item.IsComplete },
        });
    }

    public async Task<TodoItem?> Get(long id)
    {
        var tableEntity = _tableClient.Query<TableEntity>(r=>r.PartitionKey == PartitionKey && r.RowKey == id.ToString()).FirstOrDefault();
        if (tableEntity == null) return null;
        return new TodoItem
        {
            Id = long.Parse(tableEntity.RowKey),
            Name = tableEntity["Name"].ToString(),
            IsComplete = bool.Parse(tableEntity["IsComplete"].ToString())
        };
    }

    public async IAsyncEnumerable<TodoItem> GetAll()
    {
        var pageableData = _tableClient.QueryAsync<TableEntity>(ent => ent.PartitionKey == PartitionKey);

        await foreach( Page<TableEntity> page in pageableData.AsPages())
        {
            foreach(var tableEntity in page.Values)
            {
                yield return new TodoItem
                {
                    Id = long.Parse(tableEntity.RowKey),
                    Name = tableEntity["Name"].ToString(),
                    IsComplete = bool.Parse(tableEntity["IsComplete"].ToString())
                };
            }
                

        }
    }

    public async Task Remove(long id)
    {
        await _tableClient.DeleteEntityAsync(PartitionKey, id.ToString());
    }

    public async Task Update(TodoItem item)
    {
        await Add(item);
    }
}

