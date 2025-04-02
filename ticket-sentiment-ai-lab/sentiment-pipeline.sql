-- Activate SLC
-- This statement is specific for the setup and must be generated with Exasol AI Lab
alter session set script_languages='R=builtin_r JAVA=builtin_java PYTHON3=builtin_python3 PYTHON3_TE=localzmq+protobuf:///uploads/default/TE/exasol_transformers_extension_container_release?lang=python#/buckets/uploads/default/TE/exasol_transformers_extension_container_release/exaudf/exaudfclient_py3';

-- Exploration
-- How many tickets overall?
select count(*)
  from customer_support_tickets
;
-- 8446

-- How many tickets per type?
select ticket_type
     , count(*)
  from customer_support_tickets
 group by ticket_type
;

-- Add sentiment
--create or replace table mn_ailab.customer_support_tickets_sentiment
--as
with raw_data as (
    select ticket_id
         , product_purchased
         , ticket_description
         , customer_satisfaction_rating
      from customer_support_tickets
      limit 60 -- add limit for testing
),
tickets_cleaned as (
    select ticket_id
         , customer_satisfaction_rating
         -- replace {product_purchased} within ticket_description
         , replace(ticket_description, '{product_purchased}', product_purchased) as ticket_description
      from raw_data
),
descriptions_distinct as (
    -- get a distinct list of the descriptions - we just want to run the model once per text
    select distinct ticket_description
      from tickets_cleaned
),
add_sentiment as (
    select mn_ailab.te_sequence_classification_single_text_udf(
                null
               , 'TE_BFS_EXASOL_MN'
               , 'te_models'
               , 'cardiffnlp/twitter-roberta-base-sentiment-latest'
               , ticket_description
           )
      from descriptions_distinct
     group by iproc() -- distribute the UDF work on the cluster nodes
),
add_rank as (
    select text_data
         , label
         , score
         -- rank tickets based on the score, take only the highest score
         , rank() over (partition by text_data order by score desc) as text_rank
      from add_sentiment
),
combined as (
    select tickets.ticket_id
         , tickets.ticket_description
         , tickets.customer_satisfaction_rating
         , rank.score as sentiment_score
         , rank.label as sentiment_label
      from tickets_cleaned as tickets
      join add_rank as rank
        on tickets.ticket_description = rank.text_data
       and rank.text_rank = 1 -- only use the label with the highest score
)
select *
  from combined
;