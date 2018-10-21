#' ---
#' title: "Rdionica: priprema datoteke `podaci_upitnik.csv` za obradu"
#' author : "Denis Vlašiček"
#' date: ""
#' toc: true
#' ---

library(tidyverse)
library(magrittr)
library(conflicted)
library(foreign)
library(wrapr)
library(here)

# turn cats into factors
makeNA <- function(value) {
    return(ifelse(value == '', NA, value))
}

datframe_complete %<>%
    mutate_at(., .vars = vars(starts_with('pi_'), -pi_age),
              .funs = funs(makeNA)) %>%
    mutate_at(., .vars = vars(starts_with('pi_'), -pi_age),
              .funs = funs(as.factor))

# translating callToAction into three different variables - congruency (3) x
# norms (2) x charity (2)
datframe_complete %<>%
    add_column(., framing = case_when(.$callToAction %in% c(1:2, 7:8) ~ 'liberal',
                                         .$callToAction %in% c(3:4, 9:10) ~ 'conservative',
                                         TRUE ~ 'neutral'),
               norms = case_when(.$callToAction %in% c(1, 3, 5, 7, 9, 11) ~ 0,
                                 TRUE ~ 1),
               cause = case_when(.$callToAction %in% 1:6 ~ 'refugees',
                                 TRUE ~ 'children'))

datframe_complete %<>%
    mutate_at(., .vars = vars(framing, cause), .funs = funs(as.factor))

# handling cats
datframe_complete$pi_education %<>%
    fct_recode(., 'elem school' = 'Elementary School',
              'hi school' = 'High school',
              'MA' = 'Master\'s degree',
              'phd+' = 'PhD or higher',
              'pro dipl' = 'Some professional diploma, no degree',
              'BA' = 'The baccalaureate') %>%
    fct_relevel(., 'BA', after = 2) %>%
    fct_relevel(., 'pro dipl', after = Inf)

datframe_complete$pi_ideology %<>%
    fct_recode(., 'x-right' = 'Extremely conservative (right)',
              'x-left' = 'Extremely liberal (left)',
              'mid' = 'Neither liberal or conservative',
              'mid-right' = 'Somewhat conservative (right)',
              'mid-left' = 'Somewhat liberal (left)',
              'very-right' = 'Very conservative (right)',
              'very-left' = 'Very liberal (left)') %>%
    fct_relevel(., 'x-left', 'very-left', 'mid-left', 'mid',
               'mid-right', 'very-right', 'x-right')

datframe_complete$pi_income %<>%
    fct_recode(., 'avg' = 'About the average',
              '++avg' = 'Much above the average',
              '--avg' = 'Much below the average ',
              '+avg' = 'Somewhat above the average',
              '-avg' = 'Somewhat below the average') %>%
    fct_relevel(., '--avg', '-avg', 'avg', '+avg', '++avg')

datframe_complete$pi_religion %<>%
    fct_recode(., 'not' = 'Not at all religious',
              'slight-relig' = 'Slightly religious',
              'mod-relig' = 'Moderately religious',
              'very-relig' = 'Very religious',
              'ext-relig' = 'Extremely religious') %>%
    fct_relevel(., 'not', 'slight-relig', 'mod-relig', 'very-relig', 'ext-relig')

# handling nationalities
datframe_complete$pi_nationality %<>% tolower(.) %>% str_trim(.)

datframe_complete$pi_nationality %<>%
{case_when(str_detect(., 'united states|(\\w* )?american?|u\\.?s\\.?a?\\.?( \\w*)?') ~ 'american',
          str_detect(., 'british( \\w*)?|english|uk') ~ 'british',
          str_detect(., 'canad(a|ian)?') ~ 'canadian',
          str_detect(., 'croat(ian)?') ~ 'croatian',
          str_detect(., 'deutsch') ~ 'german',
          str_detect(., 'dutch|nederlandse?|netherlands|nl') ~ 'dutch',
          str_detect(., 'france') ~ 'french',
          str_detect(., 'greek') ~ 'greek',
          str_detect(., 'italian?a?') ~ 'italian',
          str_detect(., 'new zealand') ~ 'new zealand',
          str_detect(., 'polish') ~ 'polish',
          str_detect(., 'spain|spanish') ~ 'spanish',
          str_detect(., 'australian?(\\w*)?') ~ 'australian',
          str_detect(., 'belg(ian|ium)?') ~ 'belgian',
          TRUE ~ 'other')}

datframe_complete$pi_nationality %<>% fct_relevel(., 'other', after = Inf)

# rename MF questions to reflect foundation being addressed
colnames(datframe_complete) %<>%
    str_replace(., '(moralFoundations)(01|07|12|17|23|28)', '\\1\\2_care') %>%
    str_replace(., '(moralFoundations)(02|08|13|18|24|29)', '\\1\\2_fair') %>%
    str_replace(., '(moralFoundations)(03|09|14|19|25|30)', '\\1\\2_loyal') %>%
    str_replace(., '(moralFoundations)(04|10|15|20|26|31)', '\\1\\2_author') %>%
    str_replace(., '(moralFoundations)(05|11|16|21|27|32)', '\\1\\2_sanct') %>%
    str_replace(., '(moralFoundations)(06|22)', '\\1\\2_control')

# filtering cases based on answers to control questions
datframe_complete %<>%
    filter(moralFoundations06_control <= 1 & moralFoundations22_control >= 4)

# recoding reverse-coded variables
datframe_complete %<>%
    mutate(., moralIdentityInternalization03_recode = max(moralIdentityInternalization03, na.rm = T) + 1 - moralIdentityInternalization03,
           moralIdentityInternalization04_recode = max(moralIdentityInternalization04, na.rm = T) + 1 - moralIdentityInternalization04,
           attitudesAndNorms02_recode = max(attitudesAndNorms02, na.rm = T) + 1 - attitudesAndNorms02,
           attitudesAndNorms03_recode = max(attitudesAndNorms03, na.rm = T) + 1 - attitudesAndNorms03,
           attitudesAndNorms04_recode = max(attitudesAndNorms04, na.rm = T) + 1 - attitudesAndNorms04,
           attitudesAndNorms05_recode = max(attitudesAndNorms05, na.rm = T) + 1 - attitudesAndNorms05,
           attitudesAndNorms06_recode = max(attitudesAndNorms06, na.rm = T) + 1 - attitudesAndNorms06)

# add composite scores for moral identity internalization and norms toward
# cahritable giving
datframe_complete %<>%
    select(matches('attitudesAnd.*(01|07|08)|attitudesAnd.*recode')) %>%
    apply(., FUN = function(x) mean(x, na.rm = T), MARGIN = 1) %>%
    {cbind(datframe_complete, 'attitudesAndNorms_total' = .)}

datframe_complete %<>%
    select(matches('moralIdentity.*recode|moralIdentity.*(01|02|05)')) %>%
    apply(., FUN = function(x) mean(x, na.rm = T), MARGIN = 1) %>%
    {cbind(datframe_complete, 'moralIdentityInternalization_total' = .)}

datframe_complete %<>%
    select(matches('descriptiveSoc')) %>%
    apply(., FUN = function(x) mean(x, na.rm = T), MARGIN = 1) %>%
    {cbind(datframe_complete, 'descriptiveSocialNorms_total' = .)}

# in the end, we'll drop the e-mail fields
datframe_complete %<>% select(-charitableBehaviorEmail)

# handling dates
datframe_complete$timest %<>% as.character(.) %>% str_trim(.)

datframe_complete$timest_zagreb <- datframe_complete$timest %>% str_replace(., '^\\w{3} {1}(?=\\w)', '')

datframe_complete$timest_zagreb %<>% mdy_hms(.) %>% with_tz(., 'Europe/Zagreb')

# add variable which assumes that NA on money donation is $0 if time donation is
# not NA
datframe_complete %<>%
    add_column(., moneyDonationAssumed = case_when(is.na(.$charitableBehavior01) &
                                                  !is.na(.$charitableBehavior02) ~ 0L,
                                              TRUE ~ .$charitableBehavior01))

# discarding cases with case = children of europe prior to 08 August 2018, 10:30
# (Zagreb, GTM+2) because there was an error in the data collection app prior to
# that point - the children of europe call to action was written incorrectly
datframe_complete %<>%
    filter(!(cause == 'children' & timest_zagreb < ymd_hm('2018-08-08 10:30', tz = 'Europe/Zagreb')))

# datframe_complete %<>%
#     add_column(., odbaceni = ifelse(!(.$cause == 'children' & .$timest_zagreb < ymd_hm('2018-08-08 10:30', tz = 'Europe/Zagreb')), 0, 1))
# 
# write.csv(datframe_complete, '../data/nikola.csv')