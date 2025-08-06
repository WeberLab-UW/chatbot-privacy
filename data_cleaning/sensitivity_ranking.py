# %%
import pandas as pd
import re
import csv
import sys

# %%
df = pd.read_csv("cleaned_survey_data.csv")

# %%
rank_df = df[['ParticipantId','Q123_0_GROUP', 'Q123_1_GROUP', 'Q123_2_GROUP']]
rank_df = rank_df.rename(columns={'Q123_0_GROUP':'highly_sensitive', 'Q123_1_GROUP':'sensitive', 'Q123_2_GROUP': 'neutral'})

# %%
rank_df = rank_df.loc[:, ~rank_df.columns.str.contains("^Unnamed")]

# Dictionary for sensitivity levels
sensitivity_map = {
    "highly_sensitive": 1,
    "sensitive": 2,
    "neutral": 3
}

records = []

for idx, row in rank_df.iterrows():
    for col, level in sensitivity_map.items():
        if pd.notna(row[col]):
            items = [item.strip() for item in row[col].split(",") if item.strip()]
            for item in items:
                records.append({"Index": idx + 1, 'ParticipantId': row['ParticipantId'], item: level})

sensitivity_ranking_df = pd.DataFrame(records).groupby("Index").first().reset_index()

sensitivity_ranking_df = sensitivity_ranking_df.fillna("")

# The personal information type "Details of your physical location over a period of time, gathered from the GPS data from your cell phone" is incorrectly split into to two catagories, 
# so "gathered from the GPS data from your cell phone" is removed
sensitivity_ranking_df = sensitivity_ranking_df.drop('gathered from the GPS data from your cell phone', axis=1)

sensitivity_ranking_df.to_csv("sensitivity_rankings.csv")




