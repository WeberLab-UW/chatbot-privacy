library(nlme)
library(plyr) # for ddply
library(dplyr)
library(car) # for Anova
library(emmeans) # for emmeans
library(multpois) # for glmer.mp, Anova.mp, glmer.mp.con
library(ordinal) # for clmm
library(RVAideMemoire) # for Anova.clmm
library(afex)
library(lme4)
library(lmtest)
library(DHARMa)
library(tab)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(clubSandwich)
library(sandwich)
library(parameters)

# Load in the cleaned, aligned data 
full_df <- read.csv("Downloads/Stats_Privacy/long_survey_data.csv")
colnames(full_df)

## SETTING THE LEVELS
full_df$role <- as.factor(full_df$role)
full_df$role <- relevel(full_df$role, ref = "a hospital")
full_df$location <- as.factor(full_df$location)
full_df$location <- relevel(full_df$location, ref = "the US")
full_df$purpose <- as.factor(full_df$purpose)
full_df$purpose <- relevel(full_df$purpose, ref = "improving user experience with AI")


#############################################################################################
# RQ: What factors have a significant impact on privacy concerns
# Linear mixed model with cluster robust estimation matrix 
#############################################################################################

## FULL MODEL -- APPROPRIATE 
app_model <- lmer(
  appropriate_score ~ role + location + purpose + content + consent + anonymity + privacy + (1|ParticipantId),
  data=full_df
)

## CLUSTER ROBUST ESTIMATION MATRIX -- APPROPRIATE 
app_coef_tests <- coef_test(app_model, 
                            vcov = vcovCR(app_model, 
                                          type = "CR1", 
                                          cluster = full_df$ParticipantId))
print(app_coef_tests)


app_anova_table <- Anova(app_model, 
                         vcov = vcovCR(app_model, 
                                       type = "CR1", 
                                       cluster = full_df$ParticipantId))
print(app_anova_table)
write.csv(app_coef_tests, "app_main_effects_levels.csv", row.names = FALSE)
write.csv(app_anova_table, "app_main_effects.csv", row.names = FALSE)

app_means <- emmeans(app_model, specs = ~ role, vcov = robust_vcov)
print(app_means)

intercept_row <- app_coef_tests[app_coef_tests$Coef == "(Intercept)", ]
print(intercept_row)
reference_value <- intercept_row$beta


## FULL MODEL -- CONCERN
con_model <- lmer(
  concern_score ~ role + location + purpose + content + consent + anonymity + privacy + (1|participantId),
  data=full_df
)

## CLUSTER ROBUST ESTIMATION MATRIX -- CONCERN
con_coef_tests <- coef_test(con_model, 
                            vcov = vcovCR(con_model, 
                                          type = "CR1", 
                                          cluster = full_df$participantId))
print(con_coef_tests)


con_anova_table <- Anova(con_model, 
                         vcov = vcovCR(con_model, 
                                       type = "CR1", 
                                       cluster = full_df$participantId))
print(con_anova_table)
write.csv(con_coef_tests, "con_main_effects_levels.csv", row.names = FALSE)
write.csv(con_anova_table, "con_main_effects.csv", row.names = FALSE)

#############################################################################################
# RQ: What are the interaction effects between Location and the privacy control questions 
# INTERACTION EFFECTS -- PRIVACY CONTROL X LOCATION X APPROPRIATE RATINGS
#############################################################################################

# In general, I trust websites.
appropriate_trust_model <- lmer(
  appropriate_score ~ trust_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|ParticipantId),
  data=full_df
)

appropriate_trust_coef_interaction <- coef_test(appropriate_trust_model, 
                                                vcov = vcovCR(appropriate_trust_model, 
                                                              type = "CR1", 
                                                              cluster = full_df$ParticipantId))

print(appropriate_trust_coef_interaction)


# In general, I believe privacy is important
appropriate_privacy_important_pc_model <- lmer(
  appropriate_score ~ privacy_important_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropriate_privacy_important_pc_interaction <- coef_test(appropriate_privacy_important_pc_model, 
                                                          vcov = vcovCR(appropriate_privacy_important_pc_model, 
                                                                        type = "CR1", 
                                                                        cluster = full_df$participantId))

print(appropriate_privacy_important_pc_interaction) 


# I am concerned that online companies are collecting too much personal information about me.
appropriate_concerned_pc_model <- lmer(
  appropriate_score ~ concerned_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|ParticipantId),
  data=full_df
)

appropriate_concerned_pc_interaction <- coef_test(appropriate_concerned_pc_model, 
                                                  vcov = vcovCR(appropriate_concerned_pc_model, 
                                                                type = "CR1", 
                                                                cluster = full_df$ParticipantId))

print(appropriate_concerned_pc_interaction)



# I have privacy concerns about my conversations with ChatGPT.
appropiate_concerns_gpt_pc_model <- lmer(
  appropriate_score ~ concerns_gpt_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropiate_concerns_gpt_pc_interaction <- coef_test(appropiate_concerns_gpt_pc_model, 
                                                    vcov = vcovCR(appropiate_concerns_gpt_pc_model, 
                                                                  type = "CR1", 
                                                                  cluster = full_df$participantId))

print(appropiate_concerns_gpt_pc_interaction) 


# In general, I believe that my conversations with chatbots like ChatGPT will remain private.

appropiate_private_gpt_pc_model <- lmer(
  appropriate_score ~ private_gpt_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropiate_private_gpt_pc_interaction <- coef_test(appropiate_private_gpt_pc_model, 
                                                   vcov = vcovCR(appropiate_private_gpt_pc_model, 
                                                                 type = "CR1", 
                                                                 cluster = full_df$participantId))

print(appropiate_private_gpt_pc_interaction)


#############################################################################################
# RQ: What are the interaction effects between Location and the privacy control questions 
# INTERACTION EFFECTS -- PRIVACY CONTROL X LOCATION X CONCERN RATINGS
#############################################################################################
# In general, I trust websites.
trust_model <- lmer(
  concern_score ~ trust_pc*location + role + purpose + content + consent + anonymity + privacy + 
    (1|ParticipantId),
  data=full_df
)

concern_trust_coef_interaction <- coef_test(trust_model, 
                                            vcov = vcovCR(trust_model, 
                                                          type = "CR1", 
                                                          cluster = full_df$ParticipantId))

print(concern_trust_coef_interaction)



# In general, I believe privacy is important
concern_privacy_important_pc_model <- lmer(
  concern_score ~ privacy_important_pc*location + role + purpose + content + consent + anonymity + privacy + 
    (1|participantId),
  data=full_df
)

concern_privacy_important_pc_interaction <- coef_test(privacy_important_pc_model, 
                                                      vcov = vcovCR(privacy_important_pc_model, 
                                                                    type = "CR1", 
                                                                    cluster = full_df$participantId))

print(concern_privacy_important_pc_interaction)


# I am concerned that online companies are collecting too much personal information about me.
concern_concerned_pc_model <- lmer(
  concern_score ~ concerned_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

concern_concerned_pc_interaction <- coef_test(concerned_pc_model, 
                                              vcov = vcovCR(concerned_pc_model, 
                                                            type = "CR1", 
                                                            cluster = full_df$participantId))

print(concern_concerned_pc_interaction)




# I have privacy concerns about my conversations with ChatGPT.
concern_concerns_gpt_pc_model <- lmer(
  concern_score ~ concerns_gpt_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

concern_concerns_gpt_pc_interaction <- coef_test(concerns_gpt_pc_model, 
                                                 vcov = vcovCR(concerns_gpt_pc_model, 
                                                               type = "CR1", 
                                                               cluster = full_df$participantId))

print(concerns_gpt_pc_interaction)



# In general, I believe that my conversations with chatbots like ChatGPT will remain private.

concern_private_gpt_pc_model <- lmer(
  concern_score ~ private_gpt_pc*location + role + purpose + content + consent + anonymity + privacy +
    (1|participantId),
  data=full_df
)

concern_private_gpt_pc_interaction <- coef_test(private_gpt_pc_model, 
                                                vcov = vcovCR(private_gpt_pc_model, 
                                                              type = "CR1", 
                                                              cluster = full_df$participantId))

print(concern_private_gpt_pc_interaction)


#############################################################################################
# RQ: What are the interaction effects between Consent and the privacy control questions 
# INTERACTION EFFECTS -- PRIVACY CONTROL X Consent X APPROPIATE RATINGS
#############################################################################################

# In general, I trust websites.
appropriate_trust_model <- lmer(
  appropriate_score ~ trust_pc*consent + location + role + purpose + content + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropriate_trust_coef_interaction <- coef_test(appropriate_trust_model, 
                                                vcov = vcovCR(appropriate_trust_model, 
                                                              type = "CR1", 
                                                              cluster = full_df$participantId))

print(appropriate_trust_coef_interaction)


# In general, I believe privacy is important
appropriate_privacy_important_pc_model <- lmer(
  appropriate_score ~ privacy_important_pc*consent + location + role + purpose + content + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropriate_privacy_important_pc_interaction <- coef_test(appropriate_privacy_important_pc_model, 
                                                          vcov = vcovCR(appropriate_privacy_important_pc_model, 
                                                                        type = "CR1", 
                                                                        cluster = full_df$participantId))

print(appropriate_privacy_important_pc_interaction) 
write.csv(appropriate_privacy_important_pc_interaction, "consentximportant.csv", row.names = FALSE)

# I am concerned that online companies are collecting too much personal information about me.
appropriate_concerned_pc_model <- lmer(
  appropriate_score ~ concerned_pc*consent + location + role + purpose + content + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropriate_concerned_pc_interaction <- coef_test(appropriate_concerned_pc_model, 
                                                  vcov = vcovCR(appropriate_concerned_pc_model, 
                                                                type = "CR1", 
                                                                cluster = full_df$participantId))

print(appropriate_concerned_pc_interaction)




# I have privacy concerns about my conversations with ChatGPT.
appropiate_concerns_gpt_pc_model <- lmer(
  appropriate_score ~ concerns_gpt_pc*consent + location + role + purpose + content + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropiate_concerns_gpt_pc_interaction <- coef_test(appropiate_concerns_gpt_pc_model, 
                                                    vcov = vcovCR(appropiate_concerns_gpt_pc_model, 
                                                                  type = "CR1", 
                                                                  cluster = full_df$participantId))

print(appropiate_concerns_gpt_pc_interaction) 



# In general, I believe that my conversations with chatbots like ChatGPT will remain private.

appropiate_private_gpt_pc_model <- lmer(
  appropriate_score ~ private_gpt_pc*consent + location + role + purpose + content + anonymity + privacy +
    (1|participantId),
  data=full_df
)

appropiate_private_gpt_pc_interaction <- coef_test(appropiate_private_gpt_pc_model, 
                                                   vcov = vcovCR(appropiate_private_gpt_pc_model, 
                                                                 type = "CR1", 
                                                                 cluster = full_df$participantId))

print(appropiate_private_gpt_pc_interaction)


#############################################################################################
# RQ: What are the interaction effects between Location and the privacy control questions 
# INTERACTION EFFECTS -- PRIVACY CONTROL X CONSENT X CONCERN RATINGS
#############################################################################################
# In general, I trust websites.
trust_model <- lmer(
  concern_score ~ trust_pc*consent + role + purpose + content + location + anonymity + privacy + 
    (1|participantId),
  data=full_df
)

concern_trust_coef_interaction <- coef_test(trust_model, 
                                            vcov = vcovCR(trust_model, 
                                                          type = "CR1", 
                                                          cluster = full_df$participantId))

print(concern_trust_coef_interaction)



# In general, I believe privacy is important
concern_privacy_important_pc_model <- lmer(
  concern_score ~ privacy_important_pc*consent + role + purpose + content + location + anonymity + privacy +  
    (1|participantId),
  data=full_df
)

concern_privacy_important_pc_interaction <- coef_test(concern_privacy_important_pc_model, 
                                                      vcov = vcovCR(concern_privacy_important_pc_model, 
                                                                    type = "CR1", 
                                                                    cluster = full_df$participantId))

print(concern_privacy_important_pc_interaction)


# I am concerned that online companies are collecting too much personal information about me.
concern_concerned_pc_model <- lmer(
  concern_score ~ concerned_pc*consent + role + purpose + content + location + anonymity + privacy + 
    (1|participantId),
  data=full_df
)

concern_concerned_pc_interaction <- coef_test(concern_concerned_pc_model, 
                                              vcov = vcovCR(concern_concerned_pc_model, 
                                                            type = "CR1", 
                                                            cluster = full_df$participantId))

print(concern_concerned_pc_interaction)




# I have privacy concerns about my conversations with ChatGPT.
concern_concerns_gpt_pc_model <- lmer(
  concern_score ~ concerns_gpt_pc*consent + role + purpose + content + location + anonymity + privacy + 
    (1|participantId),
  data=full_df
)

concern_concerns_gpt_pc_interaction <- coef_test(concern_concerns_gpt_pc_model, 
                                                 vcov = vcovCR(concern_concerns_gpt_pc_model, 
                                                               type = "CR1", 
                                                               cluster = full_df$participantId))

print(concerns_gpt_pc_interaction)


# In general, I believe that my conversations with chatbots like ChatGPT will remain private.

concern_private_gpt_pc_model <- lmer(
  concern_score ~ private_gpt_pc*consent + role + purpose + content + location + anonymity + privacy + 
    (1|participantId),
  data=full_df
)

concern_private_gpt_pc_interaction <- coef_test(concern_private_gpt_pc_model, 
                                                vcov = vcovCR(concern_private_gpt_pc_model, 
                                                              type = "CR1", 
                                                              cluster = full_df$participantId))

print(concern_private_gpt_pc_interaction)
