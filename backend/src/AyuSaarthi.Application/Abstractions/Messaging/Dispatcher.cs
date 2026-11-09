using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace AyuSaarthi.Application.Abstractions.Messaging;

internal sealed class Dispatcher(IServiceProvider serviceProvider) : IDispatcher
{
    public Task<TResponse> Send<TResponse>(ICommand<TResponse> command, CancellationToken cancellationToken = default)
        => Invoke<TResponse>(typeof(ICommandHandler<,>), command, cancellationToken);

    public Task<TResponse> Query<TResponse>(IQuery<TResponse> query, CancellationToken cancellationToken = default)
        => Invoke<TResponse>(typeof(IQueryHandler<,>), query, cancellationToken);

    private async Task<TResponse> Invoke<TResponse>(Type handlerType, object request, CancellationToken cancellationToken)
    {
        await ValidateAsync(request, cancellationToken);

        var closedType = handlerType.MakeGenericType(request.GetType(), typeof(TResponse));
        var handler = serviceProvider.GetRequiredService(closedType);

        // Handle(request, ct) is the single method on both handler interfaces.
        var result = closedType.GetMethod("Handle")!.Invoke(handler, [request, cancellationToken]);
        return await (Task<TResponse>)result!;
    }

    private async Task ValidateAsync(object request, CancellationToken cancellationToken)
    {
        var validatorsType = typeof(IEnumerable<>).MakeGenericType(typeof(IValidator<>).MakeGenericType(request.GetType()));
        var validators = ((IEnumerable<IValidator>?)serviceProvider.GetService(validatorsType))?.ToList();
        if (validators is not { Count: > 0 })
            return;

        var context = new ValidationContext<object>(request);
        var results = await Task.WhenAll(validators.Select(v => v.ValidateAsync(context, cancellationToken)));
        var failures = results.SelectMany(r => r.Errors).ToList();

        if (failures.Count > 0)
            throw new ValidationException(failures);
    }
}
