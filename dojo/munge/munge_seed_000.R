
file.remove('~/ga.auth')

ga_token <- googleAnalyticsR::ga_auth('~/ga.auth', new_user = TRUE)

al <-  googleAnalyticsR::ga_account_list()

meta <- googleAnalyticsR::google_analytics_meta() %>% 
  dplyr::tbl_df()
ProjectTemplate::cache('meta')
