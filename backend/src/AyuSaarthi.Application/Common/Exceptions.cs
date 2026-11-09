namespace AyuSaarthi.Application.Common;

public class NotFoundException(string entity, object key)
    : Exception($"{entity} with key '{key}' was not found.");

public class ConflictException(string message) : Exception(message);
