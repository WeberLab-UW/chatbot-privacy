library(stats)
library(dplyr)
library(rstatix)
library(tidyverse)

# Load in the Data
t_df <- read.csv("Downloads/Stats_Privacy/cleaned_survey_data.csv")
head(t_df)

# I am concerned that online companies are collecting too much personal information about me.
t.test(t_df$Q18_1, mu=50.0)
sd(t_df$Q18_1)

# In general, I trust websites.
t.test(t_df$Q19_1, mu=50.0)
sd(t_df$Q19_1)

# In general, I believe privacy is important.
t.test(t_df$Q20_1, mu=50.0)
sd(t_df$Q20_1)

# I have privacy concerns about my conversations with ChatGPT.
t.test(t_df$Q21_1, mu=50.0)
sd(t_df$Q21_1)

# In general, I believe that my conversations with chatbots like ChatGPT will remain private.
t.test(t_df$Q22_1, mu=50.0)
sd(t_df$Q22_1)

# People getting inaccurate information from AI
t.test(t_df$Q124_1, mu=50.0)
sd(t_df$Q124_1)

# People not understanding what AI can do
t.test(t_df$Q124_4, mu=50.0)
sd(t_df$Q124_4)

# People’s personal info being misused by AI 
t.test(t_df$Q124_5, mu=50.0)
sd(t_df$Q124_5)

# Personalization - Chatbot conversation history
t.test(t_df$Q114_1, mu=50.0)
sd(t_df$Q114_1)

# Personalization - Search history
t.test(t_df$Q114_2, mu=50.0)
sd(t_df$Q114_2)

# Personalization - Email 
t.test(t_df$Q114_3, mu=50.0)
sd(t_df$Q114_3)

# Personalization - Device
t.test(t_df$Q114_4, mu=50.0)
sd(t_df$Q114_4)

# Secondary Use - Search engine results
t.test(t_df$Q116_1, mu=50.0)
sd(t_df$Q116_1)

# Secondary Use - Product recommendations
t.test(t_df$Q116_5, mu=50.0)
sd(t_df$Q116_5)

# Secondary Use - Popularity of my posts on social media
t.test(t_df$Q116_2, mu=50.0)
sd(t_df$Q116_2)

# Secondary Use - Content moderation on my social media 
t.test(t_df$Q116_3, mu=50.0)
sd(t_df$Q116_3)

# Valuation - Chatbot conversation history
t.test(t_df$Q115_1, mu=50.0)
sd(t_df$Q115_1)

# Valuation - Search History
t.test(t_df$Q115_2, mu=50.0)
sd(t_df$Q115_2)

# Valuation - Email
t.test(t_df$Q115_3, mu=50.0)
sd(t_df$Q115_3)

# Valuation - Device
t.test(t_df$Q115_4, mu=50.0)
sd(t_df$Q115_4)
