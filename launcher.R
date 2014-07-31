#file to launch from github
library(shiny)
source("GitLauncher.R")
source("globals.R")
source("map.R")
source("tar.R")
source("utils.R")

runGitHubWHost("ShinyServer", username = "gcorre02", subdir = "handTailoredPortfolio",port = 7958, launch.browser = F, host = "192.168.1.4")