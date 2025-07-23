SELECT 
    job_title_short
FROM
    job_postings_fact ;WITH country_salary AS 
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
    FROM job_postings_factWITH engineer_jobs AS (
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM    
    job_postings_fact
WHERE 
    job_title_short LIKE '%Engineer%' 
    AND salary_year_avg IS NOT NULL 
    AND EXTRACT(MONTH FROM job_posted_date) = 12 
)

SELECT * FROM engineer_jobs