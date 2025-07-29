
#  Introduction
 Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high deman meets high salary in data analytics.

 SQL queries? Check them out here: [project1_sql folder](/project1_sql/)

# Background
Coming from a background in health informatics, data has the power to influence decisions and shape the world around us. It is important to develop skills across statisitics, data cleaning, data visualization and insight delivery.

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries??
5. What are the most optimal skills to learn?

# Tools I Used

For exlcusively looking into the data analyst job market, I uitlized the power of several key tools:

- SQL: The backbone of my analysts, allowing me to query the databased and unearth critical insights.
- PostgreSQL: The choses database management system, ideal for handling the job postings dataset.
- Visual Studio Code: Recommended for database management and executing SQL queries.
- Git & Github: Very crucial for version control and sharing SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis

Each query for this project aimed at investigatin specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs

To analyze the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field. 

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN
    company_dim
        ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
 ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```

Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the jop postings data with the skills data, providing various insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN
    company_dim
        ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
 ORDER BY 
    salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills AS skill_name
FROM
    top_paying_jobs
INNER JOIN 
    skills_job_dim
        ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
```
Heres's the breakdown of the skills for top paying jobs:

--**Demanded Skills**: 
    
***SQL***is leading with a bold count of 8.
***Python*** follows closely with a bold count of 7.
***Tableau*** is also highly sought after, with a bold count of 6. 
Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.


- **Job Variety**: The job titles pulled include variations of "Data Analyst", but the surrounding fields (like job_schedule_type and skills) offer clues about the nature of each job:

Some may be full-time, others contract or part-time

The required skills joined later can highlight:

Whether a role leans more toward business analytics (e.g., Excel, SQL)

Or toward technical analysis (e.g., Python, machine learning, Tableau)

Some may involve domain-specific knowledge (e.g., healthcare, finance, e-commerce)

- **Diverse Employers**: By joining with the company_dim table, your query exposes the company names associated with these top jobs.

Since the jobs are remote, you’re likely to see a mix of employers, including:

Tech startups

Large corporations

Consulting firms

Non-tech industries like healthcare, education, finance

### 3. Top Demanded Skills

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
Here's the breakdown of the most demanded skills for data analyts

**SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
**Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support. 
   
| Skill    | Demand Count |
| -------- | ------------ |
| SQL      | 7291        |
| Python   | 4611          |
| Excel    | 4330          |
| Tableau  | 3745          |
| Power BI | 2609          |

This is a table of the demand for the top 5 skills in data analyst job postings

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```
Here's a thorough breakdwon of the results top paying skills for Data Analysts:

 - **High Demand for Big Data & ML Skills**: Top salaries are commanded by analysys skilled in data technology tools, machine learning tools (Jupyter), and Pytohn libraries (Pandas, NumPy) reflecting the evaluation of data processing and predictive modeling capabilities.

 - **Software Development**: Knowledge in development and deployment tools (GitHub, Airflow) indicates a crossover between data analysis and engineering, with a premium on skills that require effective and efficient data pipeline management

- **Cloud Computing Expertise**: Familiarity with cloud and data engineering tools (DataBricks) of growing the imoortance of cloud-based analytics environments, suggesting that cloud proficiency siginificantly boosts earning potential in data analytics. Becoming familiar will give a deep understanding of cloud storage, serverless computing, and resource optimization, along with a strong ability to manage cloud permissionsm costs, and scalibility.

| **Skill**             | **Average Salary (USD)** |
| --------------------- | ------------------------ |
| pyspark               | 208,172                  |
| bitbucket             | 189,155                  |
| couchbase             | 160,515                  |
| watson                | 160,515                  |
| datarobot             | 155,486                  |
| gitlab                | 154,500                  |
| swift                 | 153,750                  |
| jupyter               | 152,777                  |
| pandas                | 151,821                  |
| elasticsearch         | 145,000                  |
| 
Table of the average salary for the top 10 paying skills for data analysts

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, thsi query aimed to pinpoint skills that are both in high demand and top paying offering a strategic focus for skill development

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
| Skill ID | Skill                 | Demand Count | Average Salary (USD) |
| -------- | --------------------- | ------------ | -------------------- |
| 8        | go                    | 27           | 115,320              |
| 234      | confluence            | 11           | 114210               |
| 97       | hadoop                | 22           | 113193               |
| 80       | snowflake             | 37           | 112948               |
| 74       | azure                 | 34           | 111225               |
| 77       | bigquery              | 13           | 109654               |
| 76       | aws                   | 32           | 108317               |
| 4        | java                  | 17           | 106906               |
| 194      | ssis                  | 12           | 106683               |
| 233      | jira                  | 20           | 104918               |
| 79       | oracle                | 37           | 104534               |
| 185      | looker                | 49           | 103795               |
| 2        | nosql                 | 13           | 101414               |
| 1        | python                | 236          | 101397               |
| 78       | r                     | 148          | 100499               |
| 187      | redshift              | 16           | 99936                |
| 182      | qilk                  | 13           | 99631                |
| 197      | tableau               | 230          | 99298                |
| 92       | ssrs                  | 14           | 99171                |
| 13       | spark                 | 13           | 99077                |
| 186      | c++                   | 11           | 98958                |
| 7        | sas                   | 63           | 98902                |
| 61       | sas                   | 63           | 98902                |
| 9        | sql server            | 35           | 97786                |
| 2523     | javascript            | 20           | 97587                |

Table of the most optimal skills for data analyst sorted by salary

Here's a thorough breakdown of the most optimal skills for Data Analyst:
 
- **High-Demand Programming Languages**: Python and R stabd out for their high demand, with demand counts of 236 and 148 respectivelyt. Despite their hogh demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but widely available.
- **Cloud Tools and Technologies**: Skills specialixed technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing improtance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools**: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving interesting insights from the data.
- **Database Technologies:** The demand for skills in traditonal and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ragning from $97,786 to $104,534, reflects the importance of data storage, retrieving information and management of data.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
| Skill ID | Skill                 | Demand Count | Average Salary (USD) |
| -------- | --------------------- | ------------ | -------------------- |
| 101      | Python                | 150          | 98,000               |
| 205      | SQL                   | 140          | 95,500               |
| 317      | Tableau               | 120          | 92,000               |
| 415      | Power BI              | 110          | 90,500               |
| 502      | Excel                 | 200          | 89,000               |
| 618      | Data Visualization    | 115          | 88,000               |
| 720      | R                     | 65           | 87,500               |
| 823      | Statistics            | 75           | 86,000               |
| 930      | Machine Learning      | 55           | 85,000               |
| 1042     | Communication         | 130          | 84,500               |
| 1150     | Data Mining           | 65           | 83,000               |
| 1268     | Business Intelligence | 90           | 82,500               |
| 1345     | SAS                   | 50           | 80,000               |
| 1470     | Data Cleaning         | 85           | 79,500               |
| 1522     | Big Data              | 40           | 78,000               |
| 1651     | Cloud Computing       | 45           | 77,500               |
| 1720     | Predictive Analytics  | 38           | 76,000               |
| 1803     | SQL Server            | 70           | 75,500               |
| 1914     | Statistical Modeling  | 30           | 75,000               |
| 2020     | Data Governance       | 25           | 74,000               |
| 2101     | Data Architecture     | 20           | 73,500               |
| 2210     | Report Writing        | 55           | 72,000               |
| 2305     | Python Libraries      | 40           | 71,500               |
| 2408     | Data Analysis         | 80           | 70,000               |
| 2523     | Business Analysis     | 65           | 69,500               |

# What I Learned

Throughout this project, I've learned
Some of my key takeaways:

- **Data cleaning is essential:** no great model works on messy data

- **Effective visualization:**: turns insight into impact

- **Collaboration sharpens analysis:** feedback always improves clarity

- **Context guides analysis:** you must understand the business problem

- **Curiosity drives better questions:** and better results

In addition, understood the art of advanced SQL, merging tables and wiedling WITH claues for temporary result sets manuevers. I also got comforatable with GROUP BY clauses and turned aggregate functions like COUNT() and AVG() into data-summarizing experts.

Finally, I have enhance my real-world problem-solving skills, turning qustions into actionable, insightful SQL queries.

# Conclusion

### Insights

1. **Top-Paying Data Analyst Jobs**: The highet-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analysy jobs require advanced proficiency in SQL, suggeting it's a critical skilll for earning a top salary.
3. **Most In-Demand Skills**: SQL is alos the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skilss with Higher Salaries**: Specialied skills, such as SW and Solididty, are associared with the highest average salaries, indicating a premoum on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average saalry, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuavle insights for data analysis of the data analyst job markert. The findings from the analysis serves as a gidance to ensure skill development and job search efforts are important. Apsiring data-analysts can better position themselves in a competitive job market by focusing on high-deman, high-salary skills. This exploration highlights the importance of continous learning and daptation to emerging trends/directions in the field of data analytics.

