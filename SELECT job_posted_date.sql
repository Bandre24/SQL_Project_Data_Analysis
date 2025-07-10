SELECT job_posted_date
FROM job_postings_fact
LIMIT 10 ;

SELECT
    '2023-02-19'::DATE,
    '123'::INT,
    'true'::BOOLEAN,
    '3.14'::REAL;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM
    job_postings_fact ;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT
    5 ;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;

CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date
FROM march_jobs ;

/* Find the average salary both yearly (salary_year_avg) and hourly 
(salary_hour_avg) for job postings using the job_postings_fact table that were posted after June 1, 2023. 
Group the results by job schedule type. 
Order by the job_schedule_type in ascending order. */

SELECT  
    job_schedule_type,
    AVG(salary_year_avg) as avg_year_salary, 
    AVG(salary_hour_avg) AS avg_hour_salary
FROM
    job_postings_fact
WHERE 
    job_posted_date::DATE > '2023-06-01'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type ;

/* Count the number of job postings for each month, adjusting the job_posted_date to be in 'America/New_York' 
time zone before extracting the month. 
Assume the job_posted_date is stored in UTC. Group by and order by the month. */

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS job_months,
    COUNT(*) AS job_posting_count
FROM 
    job_postings_fact
GROUP BY 
    job_months
ORDER BY 
    job_months;

/* Find companies (include company name) that have posted jobs offering health insurance, 
where these postings were made in the second quarter of 2023. 
Use date extraction to filter by quarter. And order by the job postings count from highest to lowest. */

SELECT 
    company_dim.name AS comapny_name, COUNT(job_postings_fact.job_id) AS jop_postings_count
FROM job_postings_fact
    INNER JOIN company_dim
        ON job_postings_fact.company_id = comapny_dim.company_id
WHERE jop_postings_fact.job_health_insurance = true
AND EXTRACT(QUARTER FROM job_postings_fact.job_posted_date) = 2
GROUP BY company_dim.name
HAVING 
COUNT(job_positngs_fact.job_id) > 0
ORDER BY jop_postings_count DESC ;

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

/* From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs, 
and that have yearly salary information. 
Put salary into 3 different categories:

If the salary_year_avg is greater than or equal to $100,000, then return ‘high salary’.
If the salary_year_avg is greater than or equal to $60,000 but less than $100,000, then return ‘Standard salary.’
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also, order from the highest to the lowest salaries. */

SELECT 
    job_id, job_title, salary_year_avg,
CASE
    WHEN salary_year_avg >= 100000 THEN 'high salary'
    WHEN salary_year_avg >= 60000 AND salary_year_avg < 100000 THEN 'Standard salary'
    WHEN salary_year_avg < 60000 THEN 'Low salary'
END AS salary_range
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC ;

/* Count the number of unique companies that offer work from home (WFH) versus those requiring work to be on-site. 
Use the job_postings_fact table to count and compare the distinct companies 
based on their WFH policy (job_work_from_home). */

SELECT
   COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS Remote,
   COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS On_Site
   FROM job_postings_fact ;


/* Write a SQL query using the job_postings_fact table that returns the following columns:

job_id

salary_year_avg

experience_level (derived using a CASE WHEN)

remote_option (derived using a CASE WHEN)

Only include rows where salary_year_avg is not null.

Instructions
Experience Level
Create a new column called experience_level based on keywords in the job_title column:

Contains "Senior" → 'Senior'

Contains "Manager" or "Lead" → 'Lead/Manager'

Contains "Junior" or "Entry" → 'Junior/Entry'

Otherwise → 'Not Specified'

Use ILIKE instead of LIKE to perform case-insensitive matching (PostgreSQL-specific).

Remote Option
Create a new column called remote_option:

If job_work_from_home is true → 'Yes'

Otherwise → 'No'

Filter and Order

Filter out rows where salary_year_avg is NULL

Order the results by job_id */

SELECT job_title FROM job_postings_fact 
LIMIT 50 ;

SELECT job_id, salary_year_avg,
CASE
    WHEN job_title ILIKE '%Senior%' THEN 'Senior'
    WHEN job_title ILIKE '%Manager%' OR ILIKE '%Lead%' THEN 'Lead/Manager'
    WHEN job_title ILIKE '%Junior%' OR ILIKE '%Entry%' THEN 'Junior/Entry'
    ELSE 'Not Specified'
END AS experience_level,
CASE
    WHEN job_work_from_home = TRUE THEN 'Yes'
    ELSE 'No'
END AS remote_option
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL 
ORDER BY
     job_id ;

SELECT job_title_short, salary_year_avg FROM job_postings_fact 
LIMIT 10 ;


SELECT job_title
FROM (
    SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs


WITH february_jobs AS (
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
)

SELECT 
    job_title
FROM 
    february_jobs ;


SELECT 
    company_id, 
    name AS comapny_name
FROM 
    company_dim
WHERE 
    company_id IN (
   SELECT
    company_id
   FROM 
    job_postings_fact
   WHERE 
    job_no_degree_mention = TRUE 
    ORDER BY
        company_id
)

WITH 
    company_job_count AS 
(
    SELECT 
        company_id, 
        COUNT(*) AS total_jobs
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN 
    company_job_count 
        ON company_job_count.company_id = company_dim.company_id
ORDER BY 
    total_jobs DESC ;

WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM 
    skills_job_dim AS skills_to_job 
INNER JOIN 
    job_postings_fact AS job_postings 
        ON job_postings.job_id = skills_to_job.job_id
WHERE 
    job_postings.job_work_from_home = TRUE  
    AND job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT 
    skills.skill_id, 
    skills AS skill_name,
    skill_count
FROM 
    remote_job_skills 
INNER JOIN 
    skills_dim AS skills 
        ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5;

/* Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table and then 
join this result with the skills_dim table to get the skill names. */
SELECT * FROM
(
SELECT 
    skills_job_dim.skill_id, 
    skills_dim.skills AS skill_name,
    COUNT(*) AS skills_count
FROM 
    skills_job_dim
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
     skills_job_dim.skill_id, skill_name
) AS job_postings_skills
LIMIT 5;

SELECT skills
FROM skills_dim
INNER JOIN
(
SELECT 
    skill_id,
    COUNT(job_id) AS skill_count
FROM skills_job_dim
GROUP BY skill_id
ORDER BY COUNT(job_id) DESC
LIMIT 5)
 AS top_skills ON skills_dim.skill_id = top_skills.skill_id
ORDER BY top_skills.skill_count DESC ;


/* Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have. 
Use a subquery to calculate the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job postings is between 10 and 50, 
and 'Large' if it has more than 50 job postings.
Implement a subquery to aggregate job counts per company before classifying them based on size. */

SELECT
    company_id,
    name,
CASE
        WHEN job_count < 10 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        WHEN job_count > 50 THEN 'Large'
END AS size_category
FROM
(
SELECT
    company_dim.company_id,
    company_dim.name,
    COUNT(job_postings_fact.job_id) AS job_count
FROM
    company_dim
INNER JOIN job_postings_Fact
    ON company_dim.company_id = job_postings_fact.company_id
GROUP BY 
    company_dim.company_id, company_dim.name
) AS comapny_job_count;

/* Find companies that offer an average salary above the overall average yearly salary of all job postings. 
Use subqueries to select companies with an average salary higher than the overall average salary (which is another subquery). */

SELECT 
    name
FROM 
    company_dim
INNER JOIN (
SELECT 
    company_id,
    AVG(salary_year_avg) AS avg_salary
FROM 
    job_postings_fact
GROUP BY
    company_id
) AS company_salaries ON company_dim.company_id = company_salaries.company_id
WHERE company_salaries.avg_salary > (
    SELECT AVG(salary_year_avg)
    FROM job_postings_fact
);

WITH october_jobs AS (
SELECT 
    name AS company_name,
    job_title_short, 
    salary_year_avg, 
    job_posted_date
FROM 
    job_postings_fact
INNER JOIN 
    company_dim
    ON 
        job_postings_fact.company_id = company_dim.company_id
WHERE EXTRACT(MONTH FROM job_posted_date) = 10
)

SELECT 
    * 
FROM 
    october_jobs
WHERE 
    salary_year_avg IS NOT NULL 
    AND job_title_short LIKE '%Engineer%' ;

/* Identify companies with the most diverse (unique) job titles. 
Use a CTE to count the number of unique job titles per company, then select companies with the highest diversity in job titles. */



WITH unique_jobs AS 
(
    SELECT
        company_id, 
        COUNT(DISTINCT job_title) AS job_titles
    FROM
        job_postings_fact 
    GROUP BY company_id 
)
SELECT 
    company_dim.name AS company_name,
    unique_jobs.job_titles
FROM
     unique_jobs
INNER JOIN company_dim ON unique_jobs.company_id = company_dim.company_id 
ORDER BY 
    unique_jobs.job_titles DESC 
LIMIT 10 ;

/* Explore job postings by listing job id, job titles, company names, and their average salary rates, 
while categorizing these salaries relative to the average in their respective countries. 
Include the month of the job posted date. 
Use CTEs, conditional logic, and date functions, to compare individual salaries with national averages. */


WITH country_salary AS 
(
SELECT
    job_country,
    AVG(salary_year_avg) AS avg_country_salary
FROM 
    job_postings_fact 
GROUP BY 
    job_country
)
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    name AS company_name,
    job_postings_fact.salary_year_avg AS avg_job_salary,
    CASE    
        WHEN job_postings_fact.salary_year_avg > country_salary.avg_country_salary 
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_comparison,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
INNER JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
INNER JOIN 
    country_salary ON job_postings_fact.job_country = country_salary.job_country
ORDER BY
    month DESC ;

/* Calculate the number of unique skills required by each company. 
Aim to quantify the unique skills required per company and 
identify which of these companies offer the highest average 
salary for positions necessitating at least one skill. 
For entities without skill-related job postings, list it as 
a zero skill requirement and a null salary. Use CTEs to 
separately assess the unique skill count 
and the maximum average salary offered by these companies. */

WITH unique_skills AS (
SELECT 
    company_dim.company_id,
    COUNT(DISTINCT skill_id) AS skills_count
FROM 
    company_dim
LEFT JOIN job_postings_fact
    ON company_dim.company_id = job_postings_fact.company_id
LEFT JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
GROUP BY 
    company_dim.company_id 
),
high_salary AS (
    SELECT
        company_id,
        MAX(salary_year_avg) AS max_average_salary
    FROM
        job_postings_fact
    WHERE
        job_id IN (SELECT job_id FROM skills_job_dim)
    GROUP BY 
        company_id
)

SELECT 
    name,
    unique_skills.skills_count,
    high_salary.max_average_salary
FROM 
    company_dim
LEFT JOIN unique_skills 
    ON company_dim.company_id = unique_skills.company_id
LEFT JOIN high_salary
    ON company_dim.company_id = high_salary.company_id
ORDER BY
    name;


SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs 

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs 


SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::date,
    quarter1_job_postings.salary_year_avg
FROM (
SELECT * 
FROM january_jobs 
UNION ALL
SELECT *
FROM february_jobs
UNION ALL
SELECT * 
FROM march_jobs 
) AS quarter1_job_postings
WHERE 
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC ;


 /* Create a unified query that categorizes job postings into two groups: 
 those with salary information (salary_year_avg or salary_hour_avg is 
 not null) and those without it. 
 Each job posting should be listed with its job_id, job_title, 
 and an indicator of whether salary information is provided.  */


(
    SELECT 
    job_id,
    job_title,
    'With Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL OR
    salary_hour_avg IS NOT NULL
)
UNION ALL
(
SELECT
    job_id,
    job_title,
    'Without Salary Info' AS salary_info
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NULL OR
    salary_hour_avg IS NULL
)
ORDER BY
    salary_info DESC,
    job_id;

/* Retrieve the job id, job title short, job location, job via, skill 
and skill type for each job posting from the first quarter (January to March). 
Using a subquery to combine job postings from the first quarter 
(these tables were created in the Advanced Section - 
Practice Problem 6 [include timestamp of Youtube video])
Only include postings with an average yearly salary greater than $70,000. */

SELECT 
    first_quarter_postings.job_id,
    first_quarter_postings.job_title_short,
    first_quarter_postings.job_location,
    first_quarter_postings.job_via,
    first_quarter_postings.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM (
SELECT 
    *
FROM 
    january_jobs
UNION ALL
SELECT
    *
FROM
    february_jobs
UNION ALL
SELECT 
    *
FROM
    march_jobs
) AS first_quarter_postings
LEFT JOIN 
    skills_job_dim
        ON first_quarter_postings.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg > 70000
ORDER BY 
    first_quarter_postings.job_id ;

/* Analyze the monthly demand for skills by counting the number of 
job postings for each skill in the first quarter (January to March), 
utilizing data from separate tables for each month. 
Ensure to include skills from all job postings across these months. 
The tables for the first quarter 
job postings were created in Practice Problem 6. */


WITH total_job_postings AS (
SELECT
    job_id,
    job_posted_date
FROM 
    january_jobs
UNION ALL
SELECT 
    job_id, 
    job_posted_date
FROM
    february_jobs
UNION ALL
SELECT 
    job_id,
    job_posted_date
FROM 
    march_jobs
),

monthly_skill_demand AS (

SELECT 
    skills_dim.skills,
    EXTRACT(YEAR FROM total_job_postings.job_posted_date) AS year,
    EXTRACT(MONTH FROM total_job_postings.job_posted_date) AS month,
    COUNT(total_job_postings.job_id) AS postings_count
FROM 
    total_job_postings
INNER JOIN skills_job_dim 
    ON total_job_postings.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills,
    year,
    month
)


SELECT
    skills,
    year,
    month,
    postings_count
FROM
    monthly_skill_demand
ORDER BY
    skills,
    year,
    month;


WITH salary_skills AS (
SELECT 
    company_id,
    job_title_short,
    salary_year_avg,
    skills AS skill_name
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    salary_year_avg > 80000 

)

SELECT 
    salary_skills.company_id,
    company_dim.name AS company_name,
    salary_skills.job_title_short,
    salary_skills.salary_year_avg,
    skill_name

FROM
    salary_skills
INNER JOIN
    company_dim
        ON salary_skills.company_id = company_dim.company_id

WITH annual_job_salary AS (
SELECT 
    job_id,
    job_title_short,
    salary_year_avg
FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL 
),

company_skills AS (
    SELECT
        name AS company_name
)

SELECT
    *
FROM 
    annual_job_salary
INNER JOIN company_skills GROUP BY















