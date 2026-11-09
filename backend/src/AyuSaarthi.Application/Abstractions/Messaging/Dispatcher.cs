using Microsoft.Extensions.DependencyInjection;

namespace AyuSaarthi.Application.Abstractions.Messaging;

internal sealed class Dispatcher(IServiceProvider serviceProvider) : IDispatcher
{
    public Task<TResponse> Send<TResponse>(ICommand<TResponse> command, CancellationToken cancellationToken = default)
        => Invoke<TResponse>(typeof(ICommandHandler<,>), command, cancellationToken);

    public Task<TResponse> Query<TResponse>(IQuery<TResponse> query, CancellationToken cancellationToken = default)
        => Invoke<TResponse>(typeof(IQueryHandler<,>), query, cancellationToken);

    private Task<TResponse> Invoke<TResponse>(Type handlerType, object request, CancellationToken cancellationToken)
    {
        var closedType = handlerType.MakeGenericType(request.GetType(), typeof(TResponse));
        var handler = serviceProvider.GetRequiredService(closedType);

        // Handle(request, ct) is the single method on both handler interfaces.
        var result = closedType.GetMethod("Handle")!.Invoke(handler, [request, cancellationToken]);
        return (Task<TResponse>)result!;
    }
}
