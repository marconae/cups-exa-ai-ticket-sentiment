# Setup environment with AI Lab

## Prerequisites

* Download and start [Exasol AI Lab](https://github.com/exasol/ai-lab), e.g. the Docker edition
* Follow the setup instructions

## Setup environment in Exasol

* Copy `sentiment_generation.ipynb` to `/transformers` and follow the notebook
* Run the notebook to upload the model and do a test run
* Create the table with `ddl-customer-support-tickets.sql`
* Import the CSV file from Kaggle into the table
* Use the last two SQL statements within the data pipeline

## Usage in SQL

The following example shows the usage. Schema of the setup is `MN_AILAB`. Note: the `ALTER SESSION...` must be executed to activate the Script Language Container. 

```sql
ALTER SESSION SET SCRIPT_LANGUAGES='R=builtin_r JAVA=builtin_java PYTHON3=builtin_python3 PYTHON3_TE=...';

SELECT MN_AILAB.TE_SEQUENCE_CLASSIFICATION_SINGLE_TEXT_UDF(
    NULL,
    'TE_BFS_EXASOL_MN',
    'te_models',
    'cardiffnlp/twitter-roberta-base-sentiment-latest',
    'I''m having an issue with the Bose Sound Link. Please assist. This problem started occurring after the recent software update. I haven''t made any other changes to the device.'
)
```

## Performance overview

