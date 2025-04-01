create table customer_support_tickets(
    ticket_id                    decimal(18),
    customer_name                varchar(2000000) utf8,
    customer_email               varchar(2000000) utf8,
    customer_age                 decimal(18),
    customer_gender              varchar(2000000) utf8,
    product_purchased            varchar(2000000) utf8,
    date_of_purchase             varchar(2000000) utf8,
    ticket_type                  varchar(2000000) utf8,
    ticket_subject               varchar(2000000) utf8,
    ticket_description           varchar(2000000) utf8,
    ticket_status                varchar(2000000) utf8,
    resolution                   varchar(2000000) utf8,
    ticket_priority              varchar(2000000) utf8,
    ticket_channel               varchar(2000000) utf8,
    first_response_time          varchar(2000000) utf8,
    time_to_resolution           varchar(2000000) utf8,
    customer_satisfaction_rating varchar(2000000) utf8
);