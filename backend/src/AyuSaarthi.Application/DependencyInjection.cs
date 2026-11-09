using AyuSaarthi.Application.Abstractions.Messaging;
using Microsoft.Extensions.DependencyInjection;

namespace AyuSaarthi.Application;

public static class DependencyInjection
{
    private static readonly Type[] HandlerInterfaces = [typeof(ICommandHandler<,>), typeof(IQueryHandler<,>)];

    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        var assembly = typeof(DependencyInjection).Assembly;

        var registrations = assembly.GetTypes()
            .Where(t => t is { IsAbstract: false, IsInterface: false })
            .SelectMany(t => t.GetInterfaces()
                .Where(i => i.IsGenericType && HandlerInterfaces.Contains(i.GetGenericTypeDefinition()))
                .Select(i => (Service: i, Implementation: t)));

        foreach (var (service, implementation) in registrations)
            services.AddScoped(service, implementation);

        services.AddScoped<IDispatcher, Dispatcher>();
        return services;
    }
}
