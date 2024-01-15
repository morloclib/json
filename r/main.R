require(rjson)

#  packJsonObj   Py :: pack   => "str" -> "dict"
morloc_packJsonObj <- function(json_str):
    return rjson::fromJSON(json_str)

#  unpackJsonObj Py :: unpack => "dict" -> "str"
morloc_unpackJsonObj <- function(json_obj):
    return rjson::toJSON(json_obj)
