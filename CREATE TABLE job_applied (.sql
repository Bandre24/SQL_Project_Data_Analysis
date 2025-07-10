CREATE TABLE job_applied (
    job_ind INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT * FROM job_applied;

INSERT INTO job_applied (
    job_ind, 
    application_sent_date, 
    custom_resume, 
    resume_file_name, 
    cover_letter_sent, 
    cover_letter_file_name, 
    status) 
VALUES (
    1, 
    '2024-02-01', 
    true, 
    'resume_01.pdf', 
    true, 
    'cover_letter_1.pdf', 
    'submitted'
),
(
    2, 
    '2024-02-01', 
    false, 
    'resume_02.pdf', 
    true, 
    'cover_letter_2.pdf', 
    'submitted'
),
(
    3, 
    '2024-02-02', 
    true, 
    'resume_03.pdf', 
    false, 
    NULL, 
    'interviewed'
),
(
    4, 
    '2024-02-03', 
    true, 
    'resume_04.pdf', 
    true, 
    'cover_letter_4.pdf', 
    'offer_received'
),
(
    5, 
    '2024-02-04', 
    false, 
    'resume_05.pdf', 
    false, 
    NULL, 
    'rejected'
);

SELECT * FROM job_applied;

ALTER TABLE job_applied
ADD contact VARCHAR(50);

SELECT * FROM job_applied;

UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_ind = 1;

UPDATE job_applied
SET contact = 'Richard Hendricks'
WHERE job_ind = 2;

UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_ind = 3;

UPDATE job_applied
SET contact = 'Gilfoyle'
WHERE job_ind = 4;

UPDATE job_applied
SET contact = 'Jared Dunn'
WHERE job_ind = 5;      

ALTER TABLE job_applied
RENAME job_ind TO job_id;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

SELECT * FROM job_applied;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;

SELECT * FROM job_applied;

SELECT 
    application_sent_date
FROM 
    job_applied ;