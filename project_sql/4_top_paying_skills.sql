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


/*
- High Demand for Big Data & ML Skills: Tools like PySpark, Databricks, DataRobot, Jupyter, Pandas,
  NumPy command top salaries, showing how valuable advanced data processing and predictive analytics
  are becoming.
- Software & DevOps Proficiency: Knowledge of Bitbucket, GitLab, Jenkins, Kubernetes,
  Airflow highlights the crossover between analytics and engineering, rewarding analysts who can automate
  workflows and manage pipelines.
- Cloud & Specialized Tools Expertise: Familiarity with GCP, ElasticSearch, Couchbase, MicroStrategy,
  Twilio boosts pay, reflecting the growing shift to cloud-based environments and the premium on niche,
  hard-to-find skills.

[
  {
    "skills": "pyspark",
    "avg_salary_for_skill": "208172"
  },
  {
    "skills": "bitbucket",
    "avg_salary_for_skill": "189155"
  },
  {
    "skills": "couchbase",
    "avg_salary_for_skill": "160515"
  },
  {
    "skills": "watson",
    "avg_salary_for_skill": "160515"
  },
  {
    "skills": "datarobot",
    "avg_salary_for_skill": "155486"
  },
  {
    "skills": "gitlab",
    "avg_salary_for_skill": "154500"
  },
  {
    "skills": "swift",
    "avg_salary_for_skill": "153750"
  },
  {
    "skills": "jupyter",
    "avg_salary_for_skill": "152777"
  },
  {
    "skills": "pandas",
    "avg_salary_for_skill": "151821"
  },
  {
    "skills": "elasticsearch",
    "avg_salary_for_skill": "145000"
  },
  {
    "skills": "golang",
    "avg_salary_for_skill": "145000"
  },
  {
    "skills": "numpy",
    "avg_salary_for_skill": "143513"
  },
  {
    "skills": "databricks",
    "avg_salary_for_skill": "141907"
  },
  {
    "skills": "linux",
    "avg_salary_for_skill": "136508"
  },
  {
    "skills": "kubernetes",
    "avg_salary_for_skill": "132500"
  },
  {
    "skills": "atlassian",
    "avg_salary_for_skill": "131162"
  },
  {
    "skills": "twilio",
    "avg_salary_for_skill": "127000"
  },
  {
    "skills": "airflow",
    "avg_salary_for_skill": "126103"
  },
  {
    "skills": "scikit-learn",
    "avg_salary_for_skill": "125781"
  },
  {
    "skills": "jenkins",
    "avg_salary_for_skill": "125436"
  },
  {
    "skills": "notion",
    "avg_salary_for_skill": "125000"
  },
  {
    "skills": "scala",
    "avg_salary_for_skill": "124903"
  },
  {
    "skills": "postgresql",
    "avg_salary_for_skill": "123879"
  },
  {
    "skills": "gcp",
    "avg_salary_for_skill": "122500"
  },
  {
    "skills": "microstrategy",
    "avg_salary_for_skill": "121619"
  }
]
*/
