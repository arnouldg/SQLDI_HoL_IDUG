-- SQL1
SELECT * FROM
(SELECT AI_SIMILARITY(LOAN_SEQ_NUM, 'F21Q11276092') AS SIMILARITY, C.*
FROM <schema>.FMACTB_ORIG1 C
WHERE LOAN_SEQ_NUM <> 'F21Q11276092')
WHERE SIMILARITY > 0.3
ORDER BY SIMILARITY DESC
FETCH FIRST 20 ROWS ONLY;

-- SQL-1 AI_SIMILARITY -- Find loans who are the most similar to the loan sequence number
-- with LOAN_SEQ_NUM ‘F21Q11276092’ that was known to have defaulted their payment and
-- including LOAN_SEQ_NUM ‘F21Q11276092’. 
-- This particular query is targeting a different table now. 
-- Note you are now using the Db2 View joining the 2 tables FMACTB_ORIG1 and FMACTB_PERF1. 
-- Using this trained view gives us the possibility to enrich the data we used for creating our AI model and thus produces a different result set.
select loan_seq_num, similarity from
(select loan_seq_num,
avg(AI_SIMILARITY(LOAN_SEQ_NUM,'F21Q11276092' using model column
LOAN_SEQ_NUM)) as similarity
from ZDWxx.FMAC_default_risk_min_view1
-- where loan_seq_num <> 'F21Q11276092'
group by loan_seq_num ) as temp
WHERE SIMILARITY > 0.3
order by similarity desc
fetch first 100000 rows only ;

-- SQL-2 AI_SIMILARITY – Same as above but now find loans who are the most similar to the 
-- loan sequence number with LOAN_SEQ_NUM ‘F21Q11276092’ that was known to have defaulted their payment and excluding LOAN_SEQ_NUM ‘F21Q11276092’
select loan_seq_num, similarity from
(select loan_seq_num,
avg(AI_SIMILARITY(LOAN_SEQ_NUM,'F21Q11276092' using model column
LOAN_SEQ_NUM)) as similarity
from ZDWxx.FMAC_default_risk_min_view1
where loan_seq_num <> 'F21Q11276092'
group by loan_seq_num ) as temp
WHERE SIMILARITY > 0.3
order by similarity desc
fetch first 100000 rows only ;

-- SQL-3 AI_DISSIMILARITY -- Find loans who are the least similar to the loan sequence
-- number with LOAN_SEQ_NUM ‘F21Q11276092’ that was known to have defaulted their payment and exclude LOAN_SEQ_NUM ‘F21Q11276092’
select loan_seq_num, similarity from
(select loan_seq_num,
avg(AI_SIMILARITY(LOAN_SEQ_NUM,'F21Q11276092' using model column
LOAN_SEQ_NUM)) as similarity
from ZDWxx.FMAC_default_risk_min_view1
where loan_seq_num <> 'F21Q11276092'
group by loan_seq_num ) as temp
WHERE SIMILARITY < 0.3
order by similarity asc
fetch first 100000 rows only ;

-- SQL-4 AI_SIMILARITY -- Use “defaulted” loans and return information on which US state customers are living. 
-- The idea here is to try identify any differences based on where people are living and propency to default based on your property_state.
SELECT DISTINCT AI_SIMILARITY( 1 USING MODEL COLUMN
CURRENT_LOAN_DLQCY_STATUS, PROPERTY_STATE),PROPERTY_STATE
FROM ZDWxx.FMAC_DEFAULT_RISK_MIN_VIEW1
ORDER BY 1 DESC ;

-- SQL-5 AI_SIMILARITY -- Used “defaulted” and return information on wether customers are FIRST_TIME_HOMEBUYERS or not.
SELECT DISTINCT AI_SIMILARITY( 1 USING MODEL COLUMN
CURRENT_LOAN_DLQCY_STATUS, FIRST_TIME_HOMEBUYER_FLAG ),
FIRST_TIME_HOMEBUYER_FLAG
FROM ZDWxx.FMAC_DEFAULT_RISK_MIN_VIEW1
ORDER BY 1 DESC ;

-- SQL-6 AI_SEMANTIC_CLUSTER -- Still based on LOAN_SEQ_NUM F21Q11276092, find
-- the cluster of similar loans. In this first query we want a cluster centered on only 1 LOAN_SEQ_NUM.
SELECT * FROM
(SELECT C.*, AI_SEMANTIC_CLUSTER(loan_seq_num, 'F21Q11276092') AS
SIMILARITY
FROM ZDWxx.FMAC_default_risk_min_view1 C
WHERE loan_seq_num <> 'F21Q11276092')
WHERE SIMILARITY > 0.3
ORDER BY SIMILARITY ASC
FETCH FIRST 20 ROWS ONLY;

-- SQL-7 AI_SEMANTIC_CLUSTER -- Based on SQL-1 results, find the similar customers with the group of other LOAN_SEQ_NUM.
SELECT AI_SEMANTIC_CLUSTER(LOAN_SEQ_NUM, 'F21Q11276092',
'F21Q11276366' , 'F21Q11276333') AS SCORE, X.*
FROM ZDWxx.FMAC_DEFAULT_RISK_MIN_VIEW1 X
ORDER BY SCORE DESC
fetch first 10 rows only ;

-- SQL-8 AI_ANALOGY: Examines relationships between Sales channel for the loans and servicer names. 
-- This type of query can help identify servicer names most likely to use sales channel ‘R’ the same way ‘US Bank N.A.’ uses channel ‘C’.
SELECT DISTINCT SERVICER_NAME,
AI_ANALOGY('C' USING MODEL COLUMN CHANNEL,
'U.S. BANK N.A.' USING MODEL COLUMN SERVICER_NAME,
'R', SERVICER_NAME ) AS ANALOGY_SCORE
FROM ZDWxx.FMAC_DEFAULT_RISK_MIN_VIEW1
GROUP BY SERVICER_NAME
ORDER BY ANALOGY_SCORE DESC ;

-- SQL-9 AI_SIMILARITY -- Find loans who are the most similar to the loan sequence number
-- with LOAN_SEQ_NUM ‘F21Q11276092’ that was known to have defaulted their payment and including LOAN_SEQ_NUM ‘F21Q11276092’. 
-- This particular query is targeting a different table now.
select loan_seq_num, similarity from
(select loan_seq_num,
avg(AI_SIMILARITY(LOAN_SEQ_NUM,'F21Q11276092' using model column
LOAN_SEQ_NUM)) as similarity
from ZDWxx. AVZS_VZDWxx_FMACTB_LOAN_DEFAULT_RISK_MIN_VV
where loan_seq_num <> 'F21Q11276092'
group by loan_seq_num ) as temp
WHERE SIMILARITY > 0.3
order by similarity desc
fetch first 100000 rows only ;

