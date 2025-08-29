/*
Q: what are the most demand skills for my role (Data Analyst) ?
- Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include the skill ID, name, and count of postings requiring the skill
*/

WITH remote_job_skills AS ( 
    SELECT
        skill_id,
        COUNT(*) AS job_count
    FROM
        skills_job_dim
    INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.job_work_from_home = TRUE 
    GROUP BY
        skill_id
)

SELECT
    s.skill_id,
    s.skills,
    remote_job_skills.job_count
FROM
    remote_job_skills
INNER JOIN skills_dim AS s ON s.skill_id = remote_job_skills.skill_id
ORDER BY
    job_count DESC
LIMIT 5;

-- Another approach 

SELECT  
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
