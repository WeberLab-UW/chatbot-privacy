# %%
import pandas as pd
import csv
from statistics import stdev
import re
from collections import defaultdict

# %%
# Load in CSV containing demographic data from Cloud Reseach Connect and survey responses collected from Qualtrics
raw_survey_data = pd.read_csv("raw_survey_data.csv")

# %%
# Data Exclusion 
# Exclude all invalid survey responses (completed in less than 9 min)

raw_survey_data['Duration (in seconds)'] = pd.to_numeric(raw_survey_data['Duration (in seconds)'], errors='coerce')
raw_survey_data['Finished'] = raw_survey_data['Finished']

cleaned_survey_data = raw_survey_data.copy()

# Filtering for included data: (1) 9+ min, (2) Finished
included_survey_data = cleaned_survey_data[
    cleaned_survey_data['Duration (in seconds)'].notna() &
    (cleaned_survey_data['Duration (in seconds)'] >= 540) &
    (cleaned_survey_data['Finished'] == "TRUE")
]

# Filtering for excluded data: (1) under 9 min
excluded_survey_data = cleaned_survey_data[
    cleaned_survey_data['Duration (in seconds)'].notna() &
    (cleaned_survey_data['Duration (in seconds)'] < 540)
]

# Saving results
cleaned_survey_data.to_csv('cleaned_survey_data.csv')
excluded_survey_data.to_csv('excluded_data.csv')

# %%
#####################################################
# Data Cleaning -- Normalize and Rename Column Names
#####################################################

# Rename the Privacy Control Questions
cleaned_survey_data.rename(columns={
    'Q114_1': 'chatbot_conversation_history_personalization',
    'Q114_2': 'search_history_personalization',
    'Q114_3': 'email_personalization',
    'Q114_4': 'device_personalization',
    
    'Q115_1': 'chatbot_conversation_history_valuation',
    'Q115_2': 'search_history_valuation',
    'Q115_3': 'email_valuation',
    'Q115_4': 'device_valuation',
    
    'Q116_1': 'search_engine_history',
    'Q116_2': 'popularity_history',
    'Q116_3': 'content_mod_history',
    'Q116_5': 'product_recs_history',
    
    'Q18_1': 'concerned_pc',
    'Q19_1': 'trust_pc',
    'Q20_1': 'privacy_important_pc',
    'Q21_1': 'concerns_gpt_pc',
    'Q22_1': 'private_gpt_pc',
    
    'Q124_1': 'inaccurate_info_concern',
    'Q124_4': 'not_understanding_what_AI_can_do_concern',
    'Q124_5': 'misused_concern',
    
    'Q120': 'Usage',
    'Q33': 'year_start_using',
    'Q122': 'account_type'
}, inplace=True)

# Standarized the column names for all of the factors
def standardize_column_names(columns):
    """
    The qualtrics survey data labels the factors in an unstandardized way. 
    Return the old names into the following standardized format : "factor_shown_x".
    Reindex all factors. 
    """
    factors = ['role', 'location', 'purpose', 'content', 'consent', 'anonymity', 'privacy']
    mapping = {}
    counter = defaultdict(int)

    for col in columns:
        for factor in factors:
            if re.fullmatch(rf"{factor}\s*\d*", col, re.IGNORECASE): #regex pattern to match with the provided factors
                new_col = f"{factor}_shown_{counter[factor]}" #create new column name if match is found
                mapping[col] = new_col
                counter[factor] += 1
                break
            elif col.lower().startswith(f"{factor}_shown"): 
                new_col = f"{factor}_shown_{counter[factor]}"
                mapping[col] = new_col
                counter[factor] += 1
                break

    return mapping


def standardize_scores(columns):
    """
    The columns containing the ratings are unstandardized.
    Rename the columns with the ratings in the following format: QX_A for appropriateness socres and QX_C for concern scores.
    Reindex all column based on the order that it appears in the CSV. 
    """
    mapping = {}
    q_group = defaultdict(list)
    pattern = re.compile(r"Q(\d+)_(\d+)")
    seen_order = [] 

    # Group by prefix
    for col in columns:
        match = pattern.fullmatch(col)
        if match:
            prefix = match.group(1)
            if prefix not in seen_order:
                seen_order.append(prefix)
            q_group[prefix].append(col)

    # Map new column names based on the order that it appears in the CSV
    for new_index, prefix in enumerate(seen_order):
        cols = q_group[prefix]
        cols_sorted = sorted(cols, key=lambda c: int(pattern.fullmatch(c).group(2)))
        mapping[cols_sorted[0]] = f"Q{new_index}_A"
        for col in cols_sorted[1:]:
            mapping[col] = f"Q{new_index}_C"

    for col in columns:
        if col not in mapping:
            mapping[col] = col

    return mapping

def main():
    step1 = cleaned_survey_data.rename(columns=standardize_column_names(cleaned_survey_data.columns))
    normalized_data = step1.rename(columns=standardize_scores(step1.columns))

    normalized_data.to_csv("normalized_cleaned_survey_data.csv", index=False)

if __name__ == "__main__":
    main()


# %%
final_survey_data = pd.read_csv("normalized_cleaned_survey_data.csv")


# %%
############################################################
# Data Reformatting --> Convert df from wide to long format
############################################################
factors = ['role', 'location', 'purpose', 'content', 'consent', 'anonymity', 'privacy']

# Privacy Battery Questions
privacy_questions = ['Political Party', 'Education', 'Gender', 'Race', 'Current U.S State of Residence',
                    'chatbot_conversation_history_personalization', 'search_history_personalization', 'email_personalization', 'device_personalization',
                    'chatbot_conversation_history_valuation', 'search_history_valuation', 'email_valuation', 'device_valuation',
                    'search_engine_history', 'popularity_history', 'content_mod_history', 'product_recs_history',
                    'concerned_pc', 'trust_pc', 'privacy_important_pc', 'concerns_gpt_pc','private_gpt_pc', 
                    'inaccurate_info_concern', 'not_understanding_what_AI_can_do_concern', 'misused_concern',
                    'Usage', 'year_start_using', 'account_type']

# Transform the factors shown from wide to long format
factors_dfs = []

for i in range(30):
    cols = [f"{factor}_shown_{i}" for factor in factors]
    
    subset = final_survey_data[['ParticipantId'] + privacy_questions+ cols].copy()
    rename_dict = {old_col: new_col for old_col, new_col in zip(cols, factors)}
    
    subset.rename(columns=rename_dict, inplace=True)
    
    subset['observation_id'] = i
    
    factors_dfs.append(subset)
factors_result = pd.concat(factors_dfs, ignore_index=True)

# Transform the "appropriateness" scores from wide to long format
appropriate_scores_df = []
for i in range(30):
    col_name = f"Q{i}_P"
    
    if col_name in final_survey_data.columns:
        subset = final_survey_data[[col_name, 'ParticipantId']].copy()
        subset.rename(columns={col_name: 'appropriate_score'}, inplace=True)
        subset['observation_id'] = i
        
        appropriate_scores_df.append(subset)
        
if appropriate_scores_df: 
    appropriate_result_scores = pd.concat(appropriate_scores_df, ignore_index=True)
else:
    appropriate_result_scores = pd.DataFrame()

# Transform the "concern" scores from wide to long format
concern_scores_df = []

for i in range(30):
    col_name = f"Q{i}_C"
    if col_name in final_survey_data.columns:
        subset = final_survey_data[[col_name, 'ParticipantId']].copy()
        subset.rename(columns={col_name: 'concern_score'}, inplace=True)
        subset['observation_id'] = i
        
        concern_scores_df.append(subset)
        
if concern_scores_df: 
    concern_result_scores = pd.concat(concern_scores_df, ignore_index=True)
else:
    concern_result_scores = pd.DataFrame()

# Merge together all data
long_survey_data = factors_result.copy()

if not appropriate_result_scores.empty:
    long_survey_data = long_survey_data.merge(appropriate_result_scores, on=['ParticipantId', 'observation_id'])

if not concern_result_scores.empty:
    long_survey_data = long_survey_data.merge(concern_result_scores, on=['ParticipantId', 'observation_id'])

# Resolve the inconsistency in the 'Consent' factor --> remove 'were' from 'were not informed that your data was collected' 
long_survey_data['consent'] = long_survey_data['consent'].replace('were not informed that your data was collected', 'not informed that your data was collected')

long_survey_data.to_csv("long_survey_data.csv")



