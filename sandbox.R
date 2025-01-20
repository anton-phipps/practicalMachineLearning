library(dplyr)

training <- as_tibble(read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"))
testing <- as_tibble(read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"))
training <- training %>%
        mutate(across(7:ncol(training), ~ ifelse(is.numeric(.), as.numeric(.)),
                .names = "converted_{col}"
        )) %>%
        select(-starts_with("converted_classe")) %>%
        rename_with(~ gsub("converted_", "", .), starts_with("converted_"))

training <- training %>%
        mutate(across(8:ncol(training), ~ ifelse(names(.) != "classe", as.numeric(.), .), .names = "converted_{col}")) %>%
        mutate(across(starts_with("converted_"), ~ ifelse(is.na(.), NA, .))) %>%
        select(-starts_with("converted_classe")) %>%
        rename_with(~ gsub("converted_", "", .), starts_with("converted_"))


head(training)
