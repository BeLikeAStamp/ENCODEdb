if(FALSE) {
  library( "RUnit" )
  library( "ENCODEdb" )
}


md5sum_test_file = "b58b4847e8d71d95471c4c017b4a5dc7"

load(file = system.file("extdata/test_rest_query_file.rda", package = "ENCODEdb")) #query_file

# check when arguments are missing
test.mandatory_args_missing <- function() {
  obs = tryCatch(download(),error=function(e) e, warning=conditionMessage)
  exp = "You have to provide both results set and its origin to use the download function"
  msg = "the function should return a NULL value if the result set and its origin are missing"
  
  checkIdentical(obs, exp, msg)
}

test.mandatory_origin_missing <- function() {
  obs = tryCatch(download(resultSet = query_file),error=function(e) e, warning=conditionMessage)
  exp = "You have to provide both results set and its origin to use the download function"
  msg = "the function should return a NULL value if the result set origin is missing"
  
  checkIdentical(obs, exp, msg)
  
}

test.mandatory_results_missing <- function() {
  obs = tryCatch(download(resultOrigin = "search"),error=function(e) e, warning=conditionMessage)
  exp = "You have to provide both results set and its origin to use the download function"
  msg = "the function should return a NULL value if the result set is missing"
  
  checkIdentical(obs, exp, msg)
  
}

#check when arguments are incorrect
test.argument_consistency_ori <- function() {
  obs = tryCatch(download(resultSet = query_file, resultOrigin = "web"),error=function(e) e, warning=conditionMessage)
  exp = "You have to provide a valid results set origin to use the download function : search or query"
  msg = "the function should return a NULL value if the result set origin is different from search or query"
  
  checkIdentical(obs, exp, msg)
  
}

test.argument_consistency_dir <- function() {
  obs = tryCatch(download(resultSet = query_file, resultOrigin = "query", 
                                    dir = "/aabbbccc"),error=function(e) e, warning=conditionMessage)
  exp = "Can't write in /aabbbccc"
  msg = "the function should return a NULL value if the result set origin is different from search or query"
  
  checkIdentical(obs, exp, msg) 
}

# check download file

test.download_small_file <- function() {
  download(resultSet = query_file, resultOrigin = "query", format = "bed_broadPeak", dir = system.file("extdata/", package = "ENCODEdb"))  
  checkTrue(file.exists(system.file("extdata/ENCFF001VCK.broadPeak.gz",  package = "ENCODEdb")), 
            msg = "the file ENCFF001VCK.broadPeak.gz is missing")
  file.remove(system.file("extdata/ENCFF001VCK.broadPeak.gz",  package = "ENCODEdb"))
}

test.md5sum <- function() {
  download(resultSet = query_file, resultOrigin = "query", format = "bed_broadPeak", dir = system.file("extdata/", package = "ENCODEdb"))
  checkEquals(as.character(tools::md5sum(system.file("extdata/ENCFF001VCK.broadPeak.gz",  package = "ENCODEdb"))),
              md5sum_test_file)
  file.remove(system.file("extdata/ENCFF001VCK.broadPeak.gz",  package = "ENCODEdb"))
}


