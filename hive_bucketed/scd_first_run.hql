-- First RUN

-- Execution command -> hive -hiveconf FILE_DATE='20180731' -hiveconf RUN_DATE='2018-07-31' -f scd_first_run.hql;

-- Set the database
use yelp_data_bucket_sbhange;

-- Set the TEZ as an execution engine
set hive.execution.engine=tez;

-- Load CSV file data to 'yelp_user_stg_text' table
dfs -copyFromLocal /home/sahilbhange/landing/yelp_data/yelp_user_${hiveconf:FILE_DATE}.csv /user/sahilbhange/bucket/yelp_stg_text/.;

-- Insert text data from 'yelp_user_stg_text' to 'yelp_user_stg' STG table in ORC format
insert into yelp_user_stg select * from yelp_user_stg_text;

-- Load data from STG to HIST table and set expiry and effective date
insert into yelp_user_hist
select user_id,  name,  review_count,  yelping_since,  useful,  funny,  cool,  fans,  elite,  average_stars,  compliment_hot,  compliment_more,  compliment_profile,  compliment_cute,  compliment_list,  compliment_note,  compliment_plain,  compliment_cool,  compliment_funny,  compliment_writer,  compliment_photos, '${hiveconf:RUN_DATE}', '2099-12-31', month_date from yelp_user_stg;
