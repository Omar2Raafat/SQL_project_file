 # Introduction
 📊 Dive into the data job market! Focusing on data analyst role, this project explore 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

 🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

 # Background
 The demand for **data-related roles** has grown rapidly in recent years, with organizations relying heavily on data to drive decision-making. Careers such as **Data Analyst**, **Data Engineer**, and **Data Scientist** are now at the forefront of this transformation.  

However, for job seekers, one major challenge remains:  
👉 *Which skills should I focus on to maximize both job opportunities and salary potential?*  

This project was built to address that challenge by analyzing a large dataset of job postings using **SQL**. By exploring job titles, salaries, and required skills, the goal is to uncover **actionable insights** that help aspiring data professionals make smarter career decisions.  


 # Tools I Used
 This project was built using a combination of industry-standard tools that enabled me to **query, analyze, manage, and share** data effectively:  

- **PostgreSQL** 🐘  
  A powerful open-source relational database system used to store and query the job postings dataset. PostgreSQL allowed me to handle **large-scale data (1GB+) efficiently**, run complex SQL queries, and extract meaningful insights about job trends, salaries, and skills.  

- **Visual Studio Code (VS Code)** 💻  
  A lightweight yet powerful code editor that I used to **write, test, and manage SQL scripts**. Its extensions and integrated terminal made it easy to interact with PostgreSQL and keep my workflow organized.  

- **Git** 🌱  
  A version control system that helped me **track changes** in my project files, maintain different versions of my queries, and ensure my work remained structured and reproducible.  

- **GitHub** 🌐  
  A collaboration and hosting platform where I published my project. It allowed me to **share my work publicly**, showcase it in a professional way, and make it accessible for others to explore.  

 # The Analysis
 Each query of this project aimed at investagating specific aspects of the data analyst job market here's how I approched each question

 ### 1.Top paying Data Analyst jobs 
 In this step, I wanted to find out which Data Analyst roles pay the most.
 To do this, I queried the dataset, filtered for Data Analyst jobs focusing on remote jobs, and ordered them by average yearly salary.

 ```sql
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
```
here's a breakdown of the top data analyst jobs in 2023:
- 🚀 The highest salary is striking: a Data Analyst role at Mantys with $650,000/year — far above the others (likely a senior/unique listing).
- 🏆 After that, top-paying roles cluster between $180,000 – $336,000, mainly senior positions (Director, Principal Analyst).
- 🛠️ Companies like Meta, AT&T, Pinterest, and SmartAsset appear in the top list, showing that big tech and finance companies dominate the high-salary segment.
- 📈 Even non-director analyst roles (like Data Analyst, Marketing or Hybrid/Remote Data Analyst) are commanding well above $200,000, proving demand is strong.

![Top paying roles](/assets\top_paying_jobs_dark.png)

### 2.Top Paying jobs skills 
The query is designed to find the top 10 highest-paying remote Data Analyst jobs and then list the specific skills required for each of those roles.

👉 In other words:
It connects job postings + companies + required skills so you can see which skills are most in demand among the very best-paying analyst jobs.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        ROUND(COALESCE(salary_year_avg ,2), 0) AS salary_avg, -- here I used round and coalesce to make numbers looks better without extra zeros
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
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_avg DESC
```
📊 Breakdown of Results

The query highlights the top 10 highest-paying remote Data Analyst jobs and their required skills. Results show that SQL, Python, and Tableau are the most in-demand skills across these roles, while cloud and big data tools (Azure, AWS, Databricks, Hadoop, Snowflake) appear in the highest-paying positions. Some industry-specific tools like Crystal, Oracle, and Flow also emerge, showing variation by sector.

👉 Key takeaway: mastering the core trio (SQL, Python, Tableau) is essential, with cloud and big data expertise pushing salaries even higher.

![Top paying jobs skills](/assets\professional_dark_skills_analysis.png)

This chart provide “Top 10 Most In-Demand Skills for High-Paying Data Roles” summarizes how often each skill appears across the top-paying jobs:

SQL → 8 roles (100% of jobs)

Python → 7 roles (88%)

Tableau → 6 roles (75%)

R → 4 roles (50%)

Pandas, Excel, Snowflake → 3 roles each (38%)

Azure, AWS, Power BI → 2 roles each (25%)

### 3.Most Demand Skills
For this query, the goal is to identify which skills appear most frequently in job postings for Data Analyst roles. The logic is straightforward: the more often a skill shows up, the higher its demand in the job market.

```sql
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
```
| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7,291        |
| Excel     | 4,611        |
| Python    | 4,330        |
| Tableau   | 3,745        |
| Power BI  | 2,609        |

The results show that:

- SQL is by far the most in-demand skill (appearing in over 7,000 postings).

- Excel and Python remain essential, highlighting their importance in everyday analysis tasks.

- Tableau and Power BI emphasize the need for data visualization and business intelligence tools.

- This suggests that mastering SQL, Python, and one BI tool forms the most competitive skillset for remote Data Analysts.

### 4.Top Paying skills
In this query I Compute the average advertised salary for each skill found in remote Data Analyst job postings, then rank skills from highest to lowest. This reveals which skills are associated with higher pay in the market.

```sql
SELECT
    skills_dim.skills,
    ROUND(COALESCE(AVG(job_postings_fact.salary_year_avg), 2), 0) AS avg_salary_for_skill
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary_for_skill DESC
LIMIT 25;
```

| Skill      | Avg. Salary ($) |
|------------|-----------------|
| pyspark    | 208,172 |
| bitbucket  | 189,155 |
| couchbase  | 160,515 |
| watson     | 160,515 |
| dplyr      | 154,500 |
| gitlab     | 154,500 |
| swift      | 153,750 |
| jupyter    | 152,777 |
| pandas     | 151,821 |
| golang     | 145,000 |
| hadoop     | 141,000 |
| snowflake  | 140,000 |
| oracle     | 139,000 |
| mysql      | 138,500 |
| java       | 138,000 |

📝 Simple breakdown of the result

- The highest-paying skills skew toward big data / engineering and DevOps tools (e.g., PySpark, Couchbase, Bitbucket/GitLab), not just classic analyst tools.

- Data science/analysis libraries also appear among the top (e.g., Jupyter, Pandas, dplyr), showing value in end-to-end analysis and experimentation.

- Some general-purpose languages (Go, Swift) show up—these can correlate with hybrid analyst/engineering roles that command higher salaries.

- Keep in mind: averages can be pulled up by a few high-paying postings; skills with small sample sizes may look inflated. It’s good to pair this with a minimum demand cutoff (e.g., only consider skills with ≥ X postings).

### 5.Optimal Skills
The goal here is to find the “sweet spot” skills — those that are both:

   - **In-demand** (appear frequently in job postings), and

   - **Well-paid** (associated with higher average salaries).

To do this, the query first calculates demand for each skill, then calculates average salary per skill, and finally combines both to rank the top skills that meet a **minimum demand threshold**.

```sql
WITH demand_skills AS (
    SELECT  
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
) , top_paying_skills AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary_for_skill
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    demand_skills.skill_id,
    demand_skills.skills,
    demand_count,
    avg_salary_for_skill
FROM
    demand_skills
INNER JOIN top_paying_skills ON demand_skills.skill_id = top_paying_skills.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary_for_skill,
    demand_count DESC
LIMIT 25;


-- rewrite of this query


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary_for_skill
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary_for_skill DESC,
    demand_count DESC
LIMIT 25;
```

📝 Simple breakdown of result

- SQL, Python, and Tableau remain the core foundation: high demand and solid salaries.

- Cloud & Big Data tools like AWS, Spark, Hadoop, Snowflake, Azure push salaries well above $110K, making them highly valuable.

- Programming languages (Java, C++, Scala, Go) show up as strong “hybrid” skills, indicating crossover with engineering-heavy analyst roles.

- Excel and PowerPoint still appear due to wide demand, but salaries are lower compared to advanced technical skills.
 # What I Learned
 Working on this project gave me the opportunity to strengthen both my **technical** and **analytical** skills:  

- Improved my ability to write and optimize **SQL queries** for large datasets (1GB+).  
- Learned how to break down **business questions** (e.g., “What are the most in-demand skills?”) into structured queries and meaningful results.  
- Gained experience in **data cleaning and filtering** using SQL conditions (such as handling missing salaries or focusing on remote jobs).  
- Understood the importance of combining **demand** and **salary data** to identify the most valuable skills for career growth.  
- Practiced using **version control (Git/GitHub)** to keep my work organized and shareable.  
- Realized the power of **data storytelling** — transforming raw numbers into insights that can guide real-world decisions.  

This project not only improved my SQL skills but also taught me how to think like a **data analyst**: asking the right questions, extracting insights, and presenting them in a clear and actionable way.  
 

 # Conclusion 
 From the analysis, several clear trends emerged:  

- **SQL and Python** are the undisputed foundations for Data Analysts, appearing in both high-demand and high-paying roles.  
- **Visualization tools** such as *Tableau* and *Power BI* are essential for communicating insights and remain consistently in demand.  
- **Cloud and Big Data technologies** (e.g., AWS, Spark, Hadoop, Snowflake) are strongly associated with higher salaries, making them valuable skills for analysts aiming to advance.  
- While tools like **Excel and PowerPoint** are still widely required, their associated salaries are lower compared to more technical skills.  

👉 Overall, the findings suggest that a **combination of SQL, Python, and a BI tool**, supplemented with **cloud or big data skills**, provides the most optimal skillset for a Data Analyst in today’s job market.  

As a next step, I plan to expand this project by incorporating **data visualization tools** (such as Power BI) to present these insights more interactively, making the results even more accessible and impactful.  
