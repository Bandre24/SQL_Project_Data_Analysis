# Introduction
Dive into the data job market! Focusing on data analyst roles, this project exlplores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project1_sql folder](/project1_sql/)

# Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-dmean skills, streamlining others work to find optimal jobs.

With a foundation in statistical reasoning and a love for technology, I began developing a versatile skill set to work with data across various formats and sources. My background includes exposure to:

1. Statistical analysis and hypothesis testing
2.Database querying and data wrangling
3. Data visualization and storytelling

These skills are rooted in formal training, personal projects, and practical work experiences.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?

2. What skills are required for these top-paying jobs?

3. What skilss are most in demand for data analysts?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills to learn?

# Tools I Used

**SQL**: Allows to query the database, data manipulation

**PostgreSQL**: The database management system that is ideal for handling the job posting data.


**Visual Studio Code**: Code editor for database management and executing SQL queries.

**Git & Github**: Important for sharing SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job marked. Here's how to approached each question:

### 1. Top Paying Data Analyst Jobs
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
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL 
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying analyst roles span from $104,000 to $650,000 indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAssest, Meta, and AT&T are among those offering high salaries, showing a broad interest across diferrent industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations withing data analytics.

# What I Learned

- **Clean data:** = clear insights: Data preparation takes up most of the work, but it’s essential for quality results.

- **Context is everything:** Numbers only make sense when interpreted within their business or research context.

- **Experimentation matters:** Trying different approaches to modeling or testing always leads to deeper understanding.

# Conclusion

Becoming a skilled "data nerd" is more than just knowing tools—it's about combining curiosity, technical know-how, and storytelling to solve real-world problems. The blend of analytical thinking, hands-on experience with tools, and a learner's mindset makes all the difference.

I’m excited to keep growing in this space—whether through advanced projects, working with diverse teams, or learning emerging tools in the data ecosystem.

