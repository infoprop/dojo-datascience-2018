library(ProjectTemplate)

## default project path
.old_path <- file.path('~', 'dojo-datascience-2018')
.version <- "dojo"

## load project version
setwd(file.path(.old_path, .version))

## load project
ProjectTemplate::load.project()

#.viewId <- ####
options(
  googleAuthR.scopes.selected = m_scopes,
  googleAuthR.client_id = Sys.getenv('GOOGLEAUTHR_CLIENT_ID'),
  googleAuthR.client_secret = Sys.getenv('GOOGLEAUTHR_CLIENT_SECRET'),
  googleAuthR.httr_oauth_cache = Sys.getenv('GA_AUTH_FILE')
)
