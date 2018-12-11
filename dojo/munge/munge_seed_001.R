
query_gogl <- function(.view_id, .metrics, .dimensions, .date_from, .date_to){
  
  googleAnalyticsR::google_analytics(
    .view_id, 
    date_range = c(.date_from, .date_to), 
    metrics = .metrics, 
    dimensions = .dimensions,
    max = -1, samplingLevel = 'LARGE') %>% 
    dplyr::tbl_df()
  
}

loop_dates <- function(query, .date_from, .date_to, .split_dates = TRUE){
  
  if(.split_dates){
    .dates <- seq(.date_from, .date_to, 1)
    .dt_from <- .dates[-length(.dates)]
    .dt_to <- .dates[-1]
  }else{
    .dt_from <- .date_from
    .dt_to = .date_to
  }
  
  
  plyr::llply(seq_along(.dt_from), function(i){
    
    query(.dt_from[i], .dt_to[i])
    
  })
  
}

query_data <- function(.date_from, .date_to){
  
  query_gogl(.viewId, c('sessions', 'bounces', 'sessionDuration',
                        'users', 'newUsers'), 
             c('date', 'city', 'region'), .date_from, .date_to)
  
}

sessions <- loop_dates(query_data, as.Date('2017-01-01'), as.Date('2018-11-30'), FALSE)

data_seed <- list(
  sessions = dplyr::bind_rows(sessions)
)

ProjectTemplate::cache('data_seed')

res_users <- googleAnalyticsR::google_analytics(
  viewId, 
  date_range = c("2017-01-01", "2017-03-31"), 
  metrics = c('users', 'newUsers'), 
  dimensions = c("date", 'country'),
  max = -1, samplingLevel = 'LARGE') %>% 
  dplyr::tbl_df() %>% 
  dplyr::filter(!grepl('not set', country, TRUE))

tb_countries <- res_users %>% 
  dplyr::group_by(country) %>% 
  dplyr::summarise(total = sum(users)) %>% 
  dplyr::arrange(dplyr::desc(total)) %>% 
  dplyr::top_n(4)

xdf_users <- res_users %>% 
  dplyr::filter(grepl('brazil', country, TRUE)) %>% 
  tidyr::gather(., key = 'usrMetric', value = 'total', c('users', 'newUsers')) %>% 
  dplyr::arrange(date, country, usrMetric)

plt <- ggplot2::ggplot(xdf_users,
                       ggplot2::aes(x = date, y = total)) +
  ggplot2::geom_line(colour = "black", alpha = 1/2, size = 1/2) + 
  ggplot2::facet_wrap(~ usrMetric) +
  ggplot2::stat_smooth() +
  ggplot2::theme_light()

plotly::ggplotly(plt)
