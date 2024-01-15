#!/usr/bin/env Rscript

source("foo.R")

.morloc_run <- function(f, args){
  fails <- ""
  isOK <- TRUE
  warns <- list()
  notes <- capture.output(
    {
      value <- withCallingHandlers(
        tryCatch(
          do.call(f, args),
          error = function(e) {
            fails <<- e$message
            isOK <<- FALSE
          }
        ),
        warning = function(w){
          warns <<- append(warns, w$message)
          invokeRestart("muffleWarning")
        }
      )
    },
    type="message"
  )
  list(
    value = value,
    isOK  = isOK,
    fails = fails,
    warns = warns,
    notes = notes
  )
}

# dies on error, ignores warnings and messages
.morloc_try <- function(f, args, .log=stderr(), .pool="_", .name="_"){
  x <- .morloc_run(f=f, args=args)
  location <- sprintf("%s::%s", .pool, .name)
  if(! x$isOK){
    cat("** R errors in ", location, "\n", file=stderr())
    cat(x$fails, "\n", file=stderr())
    stop(1)
  }
  if(! is.null(.log)){
    lines = c()
    if(length(x$warns) > 0){
      cat("** R warnings in ", location, "\n", file=stderr())
      cat(paste(unlist(x$warns), sep="\n"), file=stderr())
    }
    if(length(x$notes) > 0){
      cat("** R messages in ", location, "\n", file=stderr())
      cat(paste(unlist(x$notes), sep="\n"), file=stderr())
    }
  }
  x$value
}

.morloc_unpack <- function(unpacker, x, .pool, .name){
  x <- .morloc_try(f=unpacker, args=list(as.character(x)), .pool=.pool, .name=.name)
  return(x)
}

.morloc_foreign_call <- function(cmd, args, .pool, .name){
  .morloc_try(f=system2, args=list(cmd, args=args, stdout=TRUE), .pool=.pool, .name=.name)
}

m9 <- function(s0)
{
    n3 <- rfoo(m8(s0))
    s4 <- rmorlocinternals::mlc_serialize(n3, '"character"')
    return(s4)
}

m8 <- function(s0)
{
    s1 <- .morloc_foreign_call( "python3"
    , list("pool.py", "8", paste0("'", s0, "'"))
    , "_"
    , "_" )
    n2 <- rmorlocinternals::mlc_deserialize(s1, '"character"')
    return(n2)
}

args <- as.list(commandArgs(trailingOnly=TRUE))
if(length(args) == 0){
  stop("Expected 1 or more arguments")
} else {
  mlc_pool_cmdID <- args[[1]]
  mlc_pool_function_name <- paste0("m", mlc_pool_cmdID)
  if(exists(mlc_pool_function_name)){
    mlc_pool_function <- eval(parse(text=paste0("m", mlc_pool_cmdID)))
    result <- do.call(mlc_pool_function, args[-1])
    if(result != "null"){
        cat(result, "\n")
    }
  } else {
    cat("Could not find manifold '", mlc_pool_cmdID, "'\n", file=stderr())
  }
}
