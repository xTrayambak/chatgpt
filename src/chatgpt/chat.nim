import std/[json, strformat]
import curly
import ./[types, common]

proc complete*(
  pool: CurlPool,
  apiKey: string, model: string, extro: JsonNode, asJson = false
): ChatCompletion =
  let msg = newJObject()
  msg.add "model", newJString(model)
  if asJson == true:
    case model:
      of "gpt-3.5-turbo", "gpt-3.5-turbo-0125":
        msg.add "response_format", %* { "type": "json_object" }
      else:
        raise newException(ValueError, fmt"model {model} doesn't support response_format" )

  for key, val in extro:
    msg.add key, val

  let resp = pool.post(
    "https://api.openai.com/v1/chat/completions", 
    headers = @[
      ("Content-Type", "application/json"),
      ("Authorization", "Bearer " & apiKey)
    ], 
    $msg
  )

  if resp.code != 200:
    raise getException(resp)

  resp.body.parseJson.to(ChatCompletion)
