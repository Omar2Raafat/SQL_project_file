SELECT
    job_postings_fact.job_id,
    job_title,
    job_location,
    job_schedule_type,
    ROUND(COALESCE(salary_year_avg ,2), 0),
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;



-- Enhanced query to include skills for each job posting
SELECT 
    jp.job_id,
    jp.job_title,
    jp.job_location,
    jp.job_schedule_type,
    ROUND(COALESCE(jp.salary_year_avg, 2), 0) AS salary_year_avg,
    jp.job_posted_date,
    c.name AS company_name,
    STRING_AGG(s.skills, ', ') AS skill_list -- collect all skills per job
FROM job_postings_fact jp
LEFT JOIN company_dim c 
    ON jp.company_id = c.company_id
LEFT JOIN skills_job_dim sj 
    ON jp.job_id = sj.job_id
LEFT JOIN skills_dim s 
    ON sj.skill_id = s.skill_id
WHERE 
    jp.job_title_short = 'Data Analyst'
    AND jp.job_location = 'Anywhere'
    AND jp.salary_year_avg IS NOT NULL
GROUP BY 
    jp.job_id, jp.job_title, jp.job_location, 
    jp.job_schedule_type, jp.salary_year_avg, 
    jp.job_posted_date, c.name
ORDER BY 
    salary_year_avg DESC
LIMIT 10;