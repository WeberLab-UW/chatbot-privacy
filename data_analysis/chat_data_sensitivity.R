library(stats)
library(dplyr)
library(rstatix)
library(tidyverse)

# Load in the data -- this CSV file contains the catagorical ranking of 14 different types of personal information in numeric form
# This CSV file can be found in data/clean/sensitivity_rankings.csv in the git repository

rank_df <- read.csv("Downloads/Stats_Privacy/sensitivity_rankings.csv")
colnames(rank_df)

# Transforming data from wide to long form
rank_long <- rank_df %>% gather(key = "information", value = "ranking", Content.of.your.conversations.with.chatbots.like.ChatGPT, Content.of.your.social.media.posts, Content.of.your.verbal.phone.conversations., Social.Security.Number, 
                                The.media.you.like, Your.political.views.and.the.candidates.you.support, Content.of.your.email.messages,Content.of.your.text.phone.conversations., Details.of.your.physical.location.over.a.period.of.time,
                                Record.of.the.websites.you.have.visited.online, State.of.your.health.and.medications.you.take, Who.your.friends.are.and.what.they.are.like, Your.religious.and.spiritual.views,
                                Your.basic.purchasing.habits...things.like.the.food.and.clothes.and.stores.you.prefer)

nrow(rank_long)

# Friedman Test
friedman.test(y = rank_long$ranking, groups = rank_long$information, blocks = rank_long$ParticipantId)
friedman.test(ranking ~ information | ParticipantId, data = rank_long)

# Paired Wilcoxon signed-rank tests
pwc1 <- rank_long %>%
  pairwise_wilcox_test(
    ranking ~ information,
    paired = TRUE,
    p.adjust.method = "bonferroni"
  )


pwc1

# Save results to csv
write.csv(pwc1, "C:\\saraht45\\Downloads\\Stats_Privacy\\sensitivity_wilcoxon.csv", row.names = FALSE)
print ('CSV created Successfully :)')
