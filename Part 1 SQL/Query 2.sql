#2
SELECT 
    COUNT(DISTINCT User_Id) AS Weekly_Active_Users
FROM
    (SELECT 
        reg_users.User_Id, SUM(Dwell_Time) AS Total_Dwell_Time
    FROM
        Registered_Users reg_users
    LEFT JOIN OAuth_Id_Service auth_interface ON reg_users.OAuth_Id = auth_interface.OAuth_Id
    LEFT JOIN Ad_Service_Interaction_Data Ad_data ON auth_interface.Ads_User_Id = Ad_data.Ads_User_Id
    WHERE
        auth_interface.timestamp BETWEEN ’09 - 13 - 2021’ AND ’09 - 19 - 2021’
    GROUP BY reg_users.User_Id) WAU
WHERE
    Total_Dwell_Time > 60