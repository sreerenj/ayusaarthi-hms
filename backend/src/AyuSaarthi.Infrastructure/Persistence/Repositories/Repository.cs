using AyuSaarthi.Domain.Common;
using AyuSaarthi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;

namespace AyuSaarthi.Infrastructure.Persistence.Repositories;

internal class Repository<T>(AppDbContext context) : IRepository<T> where T : BaseEntity
{
    protected readonly AppDbContext Context = context;

    public async Task<T?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        => await Context.Set<T>().FindAsync([id], cancellationToken);

    public async Task<IReadOnlyList<T>> ListAsync(CancellationToken cancellationToken = default)
        => await Context.Set<T>().AsNoTracking().ToListAsync(cancellationToken);

    public async Task AddAsync(T entity, CancellationToken cancellationToken = default)
        => await Context.Set<T>().AddAsync(entity, cancellationToken);

    public void Update(T entity) => Context.Set<T>().Update(entity);

    public void Remove(T entity) => Context.Set<T>().Remove(entity);
}
