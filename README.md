# Understanding Privacy Norms Around LLM-Based Chatbots: A Contextual Integrity Perspective (Repository)

This is the data and code repository for the AIES'2025 paper ***Understanding Privacy Norms Around LLM-Based Chatbots: A Contextual Integrity Perspective***, availiable at {LINK ARXIV}

**Paper Abstract**: LLM-driven chatbots like ChatGPT have created unprecedented volumes of conversational data, yet little is known about user privacy expectations for this information. We surveyed 300 US ChatGPT users to understand privacy norms around chatbot data sharing using the contextual integrity framework. Our findings reveal a stark disconnect between user concerns and behavior. While 82\% of respondents rated chatbot conversations as sensitive or highly sensitive—more than email or social media posts—nearly half reported discussing health topics and over one-third discussed personal finances with ChatGPT. Participants expressed strong privacy concerns (t(299) = 8.5, p $<$.01) and doubted their conversations would remain private (t(299) = -6.9, p  $<$.01). Despite this, users uniformly rejected sharing personal data (search history, emails, device access) for improved services, even in exchange for premium features worth \$200. To identify which factors influence appropriate chatbot data sharing, we presented participants with factorial vignettes manipulating seven contextual factors. Linear mixed models revealed that only the transmission principle factors, informed consent, data anonymization, and the removal of personally identifiable information, significantly affected perceptions of appropriateness and concern. Surprisingly, contextual factors including the recipient of the data (hospital vs. tech company), purpose (research vs. advertising), type of content and geographic location did not show significant effects. Our results suggest that users apply consistent baseline privacy expectations to chatbot data, prioritizing procedural safeguards over recipient trustworthiness. This has important implications for emerging agentic AI systems that assume user willingness to integrate personal data across platforms.

**Preregistered Study**: [Contextual Integrity and Chatlogs: A Factorial Vignette Survey](https://osf.io/f43tb)
<p>
    
**Preregistered Study Amendments**: [Transparent Changes Document](https://osf.io/xs5cm)

**Data additionally made available at**: [Replication Data for: Understanding Privacy Norms Around LLM-Based Chatbots: A Contextual Integrity Perspective](https://doi.org/10.7910/DVN/MOOSR8)


**1. Repository Structure**
```
├── README.md
├── data # PII and demographic information (i.e political affiliation) have been removed from the data
│   ├── aligned_data 
│   │   ├── final_aligned_survey_data.csv # This CSV contains the data for evlauting the factorial vignettes
│   │   └── sensitivity_rankings.csv # This CSV contains the data for evaluating chat data sensitivity
│   ├── clean
│   │   └── cleaned_survey_data.csv 
│   └── raw
│       └── raw_survey_data.csv
├── data_analysis
│   ├── chat_data_sensitivity.R # Contains the R code for evaluating 'Chat Data Sensitivity'
│   ├── linear_mixed_model.R # Contains the R code for the linear mixed models used to evaluate the factorial vignettes
│   └── privacy_control_questions.R # Contains the R code for the t-tests used to evaluate privacy attitudes and private data exchange value.
└── data_cleaning
    ├── data_cleaning.py # Script used to create the final_aligned_survey_data.csv
    └── sensitivity_ranking.py # Script used to create the sensitivity_rankings.csv

```

**2. Paper & Citation**
```
@article{tran2025understanding,
  title={Understanding Privacy Norms Around LLM-Based Chatbots: A Contextual Integrity Perspective},
  author={Tran, Sarah and Lu, Hongfan and Slaughter, Isaac and Herman, Bernease and Dangol, Aayushi and Fu, Yue and Chen, Lufei and Gebreyohannes, Biniyam and Howe, Bill and Hiniker, Alexis and Weber, Nicholas and Wolfe, Robert}
  journal={arXiv preprint arXiv:},
  year={2025}
}
```
**3. Data Citation**
```
@data{DVN/MOOSR8_2025,
    author={Tran, Sarah Huynh},
    publisher={Harvard Dataverse},
    title={{Replication Data for: Understanding Privacy Norms Around LLM-Based Chatbots: A Contextual Integrity Perspective}},
    UNF={UNF:6:H0O2egZLXaDZedvPKaI8wA==},
    year={2025},
    doi={10.7910/DVN/MOOSR8},
    url={https://doi.org/10.7910/DVN/MOOSR8}
}
```
