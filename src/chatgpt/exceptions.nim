type
  OpenAIError* = object of CatchableError
  InvalidAPIKeyError* = object of OpenAIError
  InsufficientQuotaError* = object of OpenAIError
  RateLimitExceededError* = object of OpenAIError
  BadRequestError* = object of OpenAIError
  AuthenticationError* = object of OpenAIError
  PermissionDeniedError* = object of OpenAIError
  NotFoundError* = object of OpenAIError
  ConflictError* = object of OpenAIError
  UnprocessableEntityError* = object of OpenAIError
  InternalServerError* = object of OpenAIError
