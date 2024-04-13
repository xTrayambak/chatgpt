import std/[json, strformat]
import puppy
import ./[types, common]

proc createImage*(apiKey: string, model: string, prompt:string, extro: JsonNode, n = 1, format = "url", size = "1024x1024"): seq[ImageRes] =
  ## `model`: Only "dall-e-2" is supported at this time.
  ## `format`: Must be one of `url` or `b64_json`
  ## `size`: Must be one of `256x256`, `512x512`, or `1024x1024`.
  ## `style`: Must be one of `vivid` or `natural`, This param is only supported for `dall-e-3`.
  let msg = newJObject()
  msg.add "model", newJString(model)
  msg.add "prompt", newJString(prompt)
  msg.add "response_format", newJString(format)
  msg.add "n", newJInt(n)
  msg.add "size", newJString(size)
  for key, val in extro:
    msg.add key, val
  let resp = post("https://api.openai.com/v1/images/generations", headers= @{
      "Content-Type": "application/json",
      "Authorization": "Bearer " & apiKey,
    }, $msg)
  if resp.code != 200:
    raise getException(resp)
  resp.body.parseJson.to(seq[ImageRes])