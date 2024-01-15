#ifndef __morloc_json_hpp__
#define __morloc_json_hpp__

#include "nlohmann_json.h"
#include <string>

using ordered_json = nlohmann::ordered_json;

// packJsonObj   :: pack   => Str -> JsonObj
ordered_json morloc_packJsonObj(std::string x){
  return ordered_json::parse(x); 
}

// unpackJsonObj :: unpack => JsonObj -> Str
std::string morloc_unpackJsonObj(ordered_json x){
  return x.dump();
}

#endif
