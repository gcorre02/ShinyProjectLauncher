#direct github launcher that allows for defining host ip
#from git
library(shiny)

runGitHubWHost =  function (repo, username = getOption("github.user"), ref = "master", 
                            subdir = NULL, port = NULL, launch.browser = getOption("shiny.launch.browser", 
                                                                                   interactive()), host = NULL) 
{
  if (is.null(ref)) {
    stop("Must specify either a ref. ")
  }
  message("Downloading github repo(s) ", paste(repo, ref, sep = "/", 
                                               collapse = ", "), " from ", paste(username, collapse = ", "))
  name <- paste(username, "-", repo, sep = "")
  url <- paste("https://github.com/", username, "/", repo, 
               "/archive/", ref, ".tar.gz", sep = "")
  runUrlWHost(url, subdir = subdir, port = port, launch.browser = launch.browser, host=host)
}

runUrlWHost = function (url, filetype = NULL, subdir = NULL, port = NULL, launch.browser = getOption("shiny.launch.browser", 
                                                                                       interactive()), host = NULL) 
{
  if (!is.null(subdir) && ".." %in% strsplit(subdir, "/")[[1]]) 
    stop("'..' not allowed in subdir")
  if (is.null(filetype)) 
    filetype <- basename(url)
  if (grepl("\\.tar\\.gz$", filetype)) 
    fileext <- ".tar.gz"
  else if (grepl("\\.tar$", filetype)) 
    fileext <- ".tar"
  else if (grepl("\\.zip$", filetype)) 
    fileext <- ".zip"
  else stop("Unknown file extension.")
  message("Downloading ", url)
  filePath <- tempfile("shinyapp", fileext = fileext)
  fileDir <- tempfile("shinyapp")
  dir.create(fileDir, showWarnings = FALSE)
  if (download(url, filePath, mode = "wb", quiet = TRUE) != 
        0) 
    stop("Failed to download URL ", url)
  on.exit(unlink(filePath))
  if (fileext %in% c(".tar", ".tar.gz")) {
    first <- untar2(filePath, list = TRUE)[1]
    untar2(filePath, exdir = fileDir)
  }
  else if (fileext == ".zip") {
    first <- as.character(unzip(filePath, list = TRUE)$Name)[1]
    unzip(filePath, exdir = fileDir)
  }
  on.exit(unlink(fileDir, recursive = TRUE), add = TRUE)
  appdir <- file.path(fileDir, first)
  if (!file_test("-d", appdir)) 
    appdir <- dirname(appdir)
  if (!is.null(subdir)) 
    appdir <- file.path(appdir, subdir)
  runApp(appdir, port = port, launch.browser = launch.browser, host = host)
}