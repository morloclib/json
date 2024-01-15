#ifndef __morloc_test_json_foo_hpp__
#define __morloc_test_json_foo_hpp__

#include "nlohmann_json.h"

using ordered_json = nlohmann::ordered_json;

ordered_json cppfoo(ordered_json x){
  x["age"] = 42;
  return x;
}

#endif
