import std/[json, strformat]
import puppy
import ./[types, common]

proc complete*(apiKey: string, model: string, extro: JsonNode, asJson = false): ChatCompletion =
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
  let resp = post("https://api.openai.com/v1/chat/completions", headers= @{
      "Content-Type": "application/json",
      "Authorization": "Bearer " & apiKey,
    }, $msg)
  if resp.code != 200:
    raise getException(resp)
  resp.body.parseJson.to(ChatCompletion)

when isMainModule:
  import std/[envvars]
  let apiKey = getEnv("OPENAI_API_KEY")
  echo complete(apiKey, "gpt-3.5-turbo", %*{ "messages": [{ "role": "user", "content": "How can I get the name of the current day in Node.js" }] })