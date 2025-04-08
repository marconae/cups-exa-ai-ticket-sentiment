alter session set script_languages='R=builtin_r JAVA=builtin_java PYTHON3=builtin_python3 PYTHON3_TE=localzmq+protobuf:///uploads/default/TE/exasol_transformers_extension_container_release?lang=python#/buckets/uploads/default/TE/exasol_transformers_extension_container_release/exaudf/exaudfclient_py3';

with tickets as (
    select ticket_id
         , ticket_description
         , sentiment_label
         , sentiment_score
      from mn_ailab.customer_support_tickets_sentiment
     limit 10
),
zero_shot as (
    select mn_ailab.te_zero_shot_text_classification_udf(
        NULL,
        'TE_BFS_EXASOL_MN',
        'te_models',
        'cross-encoder/nli-deberta-base',
        tickets.ticket_description,
            --'sentiment positive, sentiment neutral, sentiment negative'
            --'customer is happy, customer is upset, customer satisfaction neutral'
         'priority high,priority low,priority medium'
          )
    from tickets
),
zero_shot_rankend as (
    select test_data
         , label
         , score
         -- rank tickets based on the score, take only the highest score
         , rank() over (partition by test_data order by score desc) as text_rank
      from zero_shot
)
select tickets.ticket_id
     , tickets.ticket_description
     , tickets.sentiment_score
     , tickets.sentiment_label
     , zsr.label zero_shot_label
     , zsr.score zero_shot_score
     , tickets_orig.ticket_priority
  from tickets
  join MN_AILAB.CUSTOMER_SUPPORT_TICKETS tickets_orig
    on tickets.TICKET_ID = tickets_orig.TICKET_ID
  join zero_shot_rankend zsr
    on tickets.ticket_description = zsr.test_data
   and text_rank = 1

