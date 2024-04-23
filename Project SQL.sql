--transaction_2020
SELECT * FROM fact_transaction_2020

SELECT * FROM dim_scenario

--the trend of the number of successful payment transactions with promotion and account for how much of the total number of successful payment transactions
WITH promotion AS (
    SELECT 
        DATEPART(WEEK,transaction_time) [Week],
        COUNT(transaction_id) promotion_trans
    FROM fact_transaction_2020 fact20
    INNER JOIN dim_scenario sce ON fact20.scenario_id = sce.scenario_id
    WHERE (sub_category = 'Electricity')
    AND (promotion_id <>'0')
    AND (status_id = 1)
    GROUP BY DATEPART(WEEK,transaction_time)
),
non_promotion AS (
    SELECT 
        DATEPART(WEEK,transaction_time) [Week],
        COUNT(transaction_id) promotion_ratio
    FROM fact_transaction_2020 fact20
    INNER JOIN dim_scenario sce ON fact20.scenario_id = sce.scenario_id
    WHERE (sub_category = 'Electricity')
    AND (status_id = 1)
    GROUP BY DATEPART(WEEK,transaction_time)
)
SELECT promotion.[Week], promotion_trans, promotion_ratio,
    FORMAT(CAST(promotion_trans AS DECIMAL)/promotion_ratio,'p') [percentage]
FROM promotion
INNER JOIN non_promotion ON promotion.[Week] = non_promotion.[Week]



-- % of customers have incurred any other successful payment transactions that are not promotional transactions
-- table with all transaction success
WITH trans_suc AS (
    SELECT customer_id, transaction_id, promotion_id,
        IIF(promotion_id <> '0','promo','normal') trans_type,
        LAG ( IIF(promotion_id <> '0' , 'promo', 'normal') , 1) OVER ( partition by customer_id order by transaction_id ) last_trans,
        ROW_NUMBER() OVER ( partition by customer_id order by transaction_id ) AS row_number
    FROM fact_transaction_2020 fact20
    INNER JOIN dim_scenario sce ON fact20.scenario_id = sce.scenario_id
    WHERE sub_category = 'Electricity'
    AND status_id = 1
    ),
-- table with customers have the fisrt transaction is promotion
first_promo AS (
    SELECT DISTINCT customer_id
    FROM trans_suc
    WHERE row_number = 1 AND trans_type = 'promo'
)
-- 
SELECT COUNT (distinct trans_suc.customer_id) AS number_customer
, (SELECT COUNT (customer_id ) from first_promo ) AS total
, FORMAT (COUNT (distinct trans_suc.customer_id)*1.0 / (SELECT COUNT (customer_id ) from first_promo ),'p') pct
FROM first_promo
INNER JOIN trans_suc
ON first_promo.customer_id = trans_suc.customer_id
WHERE trans_type = 'normal' AND last_trans = 'promo'
