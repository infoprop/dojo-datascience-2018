library(ProjectTemplate)

## default project path
.old_path <- file.path('~', 'dojo-datascience-2018')
.version <- "dojo"

## load project version
setwd(file.path(.old_path, .version))

## load project
ProjectTemplate::load.project()