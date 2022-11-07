Medium level
1. Show unique birth years from patients and order them by ascending.
select
  distinct(year(birth_date)) as birth_year
from patients
order by birth_year asc;

2. Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
with cte as (
    select
      distinct(first_name) as name,
      count (*) as records
    from patients
    group by name
    having records = 1)
select name
from cte;

3. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select
  patient_id,
  first_name
from patients
where
  first_name like "s%s"
  and len(first_name) >= 6;

4. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
select
  a.patient_id,
  a.first_name,
  a.last_name
from patients a
  inner join admissions b on a.patient_id = b.patient_id
where b.diagnosis = 'Dementia';

5. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name
from patients
order by
  len(first_name),
  first_name;

6. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select
  count(case when gender = "M" then gender end) as male_count,
  count(case when gender = "F" then gender end) as female_count
from patients;

7. Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
select
  first_name,
  last_name,
  allergies
from patients
where
  allergies in('Penicillin', 'Morphine')
order by
  allergies,
  first_name,
  last_name;

8. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select
  patient_id,
  diagnosis
from admissions
group by
  patient_id,
  diagnosis
having count(*) > 1;

9. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select
  city,
  count(*)
from patients
group by city
order by
  count (*) desc,
  city asc;

10. Show first name, last name and role of every person that is either patient or physician. The roles are either "Patient" or "Physician"
select
  first_name,
  last_name,
  "Patient" as role
from patients
union all
select
  first_name,
  last_name,
  "Physician" as role
from physicians;


11. Show all allergies ordered by popularity. Remove NULL values from query.
select
  allergies,
  count(*) as records
from patients
group by allergies
having allergies not null
order by records desc;

12.Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select
  first_name,
  last_name,
  birth_date
from patients
where
  year(birth_date) between 1970 and 1979
order by birth_date;


13. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order. EX: SMITH,jane
select
  concat(upper(last_name), ",", lower(first_name))
from patients
order by first_name desc;

14. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select
  province_names.province_id,
  sum(patients.height) as h
from province_names
  left join patients on province_names.province_id = patients.province_id
group by province_names.province_id
having h >= 7000;

15. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight) - min(weight)
from patients
where last_name = "Maroni";

16. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select
  day(admission_date) as date,
  count (*)
from admissions
group by date
order by count(*) desc;

17. Show all columns for patient_id 542's most recent admission_date.
select *
from admissions
where patient_id = 542
order by admission_date desc
limit 1;

18. Show patient_id, attending_physician_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_physician_id is either 1, 5, or 19.
2. attending_physician_id contains a 2 and the length of patient_id is 3 characters.
select
  patient_id,
  attending_physician_id,
  diagnosis
from admissions
where
  ((patient_id % 2) <> 0 and attending_physician_id in (1, 5, 19))
  or 
  (len(patient_id) = 3 and (attending_physician_id like "%2"
      or attending_physician_id like "2%"));

19. Show first_name, last_name, and the total number of admissions attended for each physician. Every admission has been attended by a physician.
select
  physicians.first_name,
  physicians.last_name,
  count(admissions.patient_id)
from physicians
  inner join admissions on physicians.physician_id = admissions.attending_physician_id
group by
  physicians.first_name,
  physicians.last_name;
  
20. For each physicain, display their id, full name, and the first and last admission date they attended.
select
  physician_id,
  concat(physicians.first_name," ",physicians.last_name) as fullname,
  max(admissions.admission_date) as last_date,
  min(admissions.admission_date) as first_date
from admissions
  inner join physicians on admissions.attending_physician_id = physicians.physician_id
group by fullname;

21. Display the total amount of patients for each province. Order by descending.
select
  province_names.province_name,
  count(patient_id) as records
from province_names
  inner join patients on province_names.province_id = patients.province_id
group by province_names.province_name
order by records desc;

22. For every admission, display the patient's full name, their admission diagnosis, and their physician's full name who diagnosed their problem.
select
  admissions.diagnosis,
  concat (patients.first_name," ",patients.last_name) as patient_name,
  concat (physicians.first_name," ",physicians.last_name  ) as physician_name
from (admissions inner join patients on 
admissions.patient_id = patients.patient_id)
  inner join physicians on admissions.attending_physician_id = physicians.physician_id;


































































































