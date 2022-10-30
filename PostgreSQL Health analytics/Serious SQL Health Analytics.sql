--schema health
--table user_logs
-- id varchar
-- log_date date
-- measure text
-- measure_value numeric
-- systolic numeric
-- diastolic numeric

--How many unique users exist in the logs dataset? A=554
select
    count (distinct (id)) as unique_id
from health.user_logs; 

--How many duplicated records are there? A=19449
with cte as (
select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  count(*) as count_records
from health.user_logs
group by
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic)
select
  sum(count_records)
from cte
where count_records > 1;

--How many unquie records are there? A=24442
with cte as (
select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  count(*) as count_records
from health.user_logs
group by
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic)
select
  sum(count_records)
from cte
where count_records = 1;


--Who are the users with the most duplicated records? 054250c692e07a9fa9e62e345231df4b54ff435d with 17279 duplicated records

with cte as (
select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  count(*) as count_records
from health.user_logs
group by
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic)
select
  id,
  sum(count_records) as sum_records
from cte
where count_records > 1
group by id
order by sum_records desc;

--How many duplicated records in each measure category? blood_glucose = 18471; weight = 677; blood_pressure = 301
with cte as (
select
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic,
  count(*) as count_records
from health.user_logs
group by
  id,
  log_date,
  measure,
  measure_value,
  systolic,
  diastolic)
select
  measure,
  sum(count_records) as sum_records
from cte
where count_records > 1
group by measure
order by sum_records desc;

-- Ignore duplications, for weight, what are the minimum and maximum records? A = 39642120 and 0
select
  max(measure_value) as max_rec,
  min(measure_value) as min_rec
from health.user_logs
where measure = 'weight';
-- Ignore duplications, allocate weights in to 100 percentitles and find outliers. A = ouliers are out side the range of 1.8 to 201
SELECT
  measure_value,
  NTILE(100) OVER (ORDER BY measure_value) AS percentile
FROM health.user_logs
WHERE measure = 'weight';

-- Ignore duplications and exclude outliers, what are the avg, median, mode, stde of weight measures? A = mean_value/median_value/mode_value/standard_deviation = 80.76/75.98/68.49/26.91
SELECT
   ROUND(AVG(measure_value), 2) AS mean_value,
   ROUND(
      CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY measure_value) AS NUMERIC),2
       ) AS median_value,
   ROUND(MODE() WITHIN GROUP (ORDER BY measure_value),2
      ) AS mode_value,
   ROUND(STDDEV(measure_value), 2) AS standard_deviation

FROM health.user_logs
WHERE measure = 'weight' and (measure_value between 1.8 and 201);

--How many total measurements do we have per user on average? A=79.23
with cte as(
select
  id,
  count (*) as frequency
from health.user_logs
group by id)
select
  round (sum (frequency)::numeric / count (distinct id),2) as record_per_customer
from cte; 

--What about the median number of measurements per user? A=2
with cte as(
select
  id,
  count (*) as frequency
from health.user_logs
group by id)
select
  round(percentile_cont(0.5) within group (order by frequency)::numeric,2) as median
from cte; 

--How many users have 3 or more measurements? A=209
with cte as(
select
  id,
  count (*) as frequency
from health.user_logs
group by id)
select
  count (id)
from cte
where frequency >= 3; 

--How many users have 1,000 or more measurements? A=5
with cte as(
select
  id,
  count (*) as frequency
from health.user_logs
group by id)
select
  count (id)
from cte
where frequency >= 1000; 
--answer=5


--How many users Have logged blood glucose measurements? A=325
with cte as(
select
  id,
  measure,
  count (*) as frequency
from health.user_logs
group by id, measure)
select
  count (id)
from cte
where measure = 'blood_glucose'; 

--How many user have at least 2 types of measurements? A=204
with cte as(
select
  id,
  count (distinct measure) as frequency
from health.user_logs
group by id)
select
  count (id)
from cte
where frequency >=2; 

--How many users have all 3 measures - blood glucose, weight and blood pressure? A=50
with cte as(
select
  id,
  count (distinct measure) as frequency
from health.user_logs
group by id)
select
  count (id)
from cte
where frequency =3;

--For users that have blood pressure measurements, what is the median systolic/diastolic blood pressure values? A=126 and 79
select
  percentile_cont(0.5) within group (order by systolic)::numeric as median_systolic,
  percentile_cont(0.5) within group (order by diastolic)::numeric as median_diastolic
from health.user_logs
where (measure = 'blood_pressure') and (systolic is not null) and (diastolic is not null);
