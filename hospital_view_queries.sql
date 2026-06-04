USE hospital_db;

CREATE VIEW vw_Department_Revenue AS
SELECT 
    d.Department_Name,
    SUM(r.Revenue_Amount) AS Total_Revenue
FROM Revenue r
JOIN Departments d
ON r.Department_ID = d.Department_ID
GROUP BY d.Department_Name;

CREATE VIEW vw_Monthly_Patient_Trend AS
SELECT 
    YEAR(Visit_Date) AS Year,
    MONTH(Visit_Date) AS Month,
    COUNT(*) AS Total_Visits
FROM Patient_Visits
GROUP BY YEAR(Visit_Date), MONTH(Visit_Date);

CREATE VIEW vw_Top_Doctors AS
SELECT
    d.Doctor_Name,
    COUNT(a.Appointment_ID) AS Total_Appointments
FROM Appointments a
JOIN Doctors d
ON a.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_Name;

CREATE VIEW vw_Revenue_Rank AS
SELECT
    d.Department_Name,
    SUM(r.Revenue_Amount) AS Revenue,
    RANK() OVER (
        ORDER BY SUM(r.Revenue_Amount) DESC
    ) AS Revenue_Rank
FROM Revenue r
JOIN Departments d
ON r.Department_ID = d.Department_ID
GROUP BY d.Department_Name;

CREATE VIEW vw_Avg_Length_of_Stay AS
SELECT
    d.Department_Name,
    AVG(v.Length_of_Stay) AS Avg_LOS
FROM Patient_Visits v
JOIN Departments d
ON v.Department_ID = d.Department_ID
WHERE v.Admission_Flag = 'Yes'
GROUP BY d.Department_Name;

CREATE VIEW vw_Patient_Demographics AS
SELECT
    Gender,
    Age_Group,
    COUNT(*) AS Total_Patients
FROM Patients
GROUP BY Gender, Age_Group;

CREATE VIEW vw_Digital_Acquisition AS
SELECT
    Channel,
    SUM(Sessions) AS Total_Sessions,
    SUM(Conversions) AS Total_Conversions,
    AVG(Bounce_Rate) AS Avg_Bounce_Rate
FROM Digital_Acquisition
GROUP BY Channel;

CREATE VIEW vw_Outcome_Analysis AS
SELECT
    Outcome,
    COUNT(*) AS Total_Cases,
    CASE
        WHEN COUNT(*) > 100 THEN 'High'
        ELSE 'Low'
    END AS Severity_Level
FROM Patient_Visits
GROUP BY Outcome;

CREATE VIEW vw_Running_Revenue AS
SELECT
    Billing_Date,
    SUM(Revenue_Amount) AS Daily_Revenue,
    SUM(SUM(Revenue_Amount))
    OVER (ORDER BY Billing_Date)
    AS Running_Revenue
FROM Revenue
GROUP BY Billing_Date;

CREATE VIEW vw_Treatment_Success AS
WITH TreatmentSuccess AS (
    SELECT
        Treatment_Name,
        COUNT(*) AS Total_Treatments
    FROM Treatments
    WHERE Success_Flag = 'Yes'
    GROUP BY Treatment_Name
)
SELECT *
FROM TreatmentSuccess;