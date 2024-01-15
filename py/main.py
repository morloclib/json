import json

#  packJsonObj   Py :: pack   => "str" -> "dict"
def morloc_packJsonObj(json_str):
    return json.loads(json_str)

#  unpackJsonObj Py :: unpack => "dict" -> "str"
def morloc_unpackJsonObj(json_obj):
    return json.dumps(json_obj)
