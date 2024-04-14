import std/[httpcore,json]
import puppy
import ./[types, exceptions]

proc getException*(resp: Response): ref OpenAIError =
  case resp.code
  of 400:
    result = newException(BadRequestError, $Http400)
  of 401:
    let data = parseJson(resp.body)
    let err = data{"error"}.to(GPTError)
    case err.code
      of "invalid_api_key":
        result = newException(InvalidAPIKeyError, err.message)
      else:
        result = newException(AuthenticationError, $Http401)
  of 403:
    result = newException(PermissionDeniedError, $Http403)
  of 404:
    result = newException(NotFoundError, $Http404)
  of 409:
    result = newException(ConflictError, $Http409)
  of 422:
    result = newException(UnprocessableEntityError, $Http422)
  of 429:
    let data = parseJson(resp.body)
    let err = data{"error"}.to(GPTError)
    case err.code
      of "insufficient_quota":
        result = newException(InsufficientQuotaError, err.message)
      of "rate_limit_exceeded":
        result = newException(RateLimitExceededError, err.message)
      else: result = newException(RateLimitExceededError, err.message)
  of 500:
    result = newException(InternalServerError, $Http500)
  else:
    result = newException(OpenAIError, "OpenAI request error, code: " & $resp.code)
  result.code = resp.code
