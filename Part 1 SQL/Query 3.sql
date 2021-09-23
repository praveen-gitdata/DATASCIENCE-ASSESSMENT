#3A - Extracting Weekly Active Users for current week
CREATE TABLE weekly_active_users_current_week AS SELECT DISTINCT Ads_User_Id FROM
    (SELECT 
        reg_users.User_Id,
            Ads_User_Id,
            SUM(Dwell_Time) AS Total_Dwell_Time
    FROM
        Registered_Users reg_users
    LEFT JOIN OAuth_Id_Service auth_interface ON reg_users.OAuth_Id = auth_interface.OAuth_Id
    LEFT JOIN Ad_Service_Interaction_Data Ad_data ON auth_interface.Ads_User_Id = Ad_data.Ads_User_Id
    WHERE
        auth_interface.timestamp BETWEEN ’09 - 20 - 2021’ AND ’09 - 23 - 2021’
    GROUP BY reg_users.User_Id , Ads_User_Id) WAU
WHERE
    Total_Dwell_Time > 60;

#3B - Retreiving contents of this week's active users for each content type.
CREATE TABLE top_contents_current_week AS SELECT Content_Type,
    Content_Id,
    COUNT(DISTINCT Ads_User_Id) AS viewers FROM
    weekly_active_users_current_week wau
        LEFT JOIN
    Page_Impression impressions ON wau.Ads_User_Id = impressions.Ads_User_Id
        LEFT JOIN
    Content_Metadata content_data ON impressions.Content_Id = Content_Metadata.Content_Id
GROUP BY Content_Type , Content_Id;

#3C - Top 5 pieces of content from each content type consumed this week by only active users.
Select Content_Type, Content_Id,ROW_NUMBER() 
	OVER(PARTITION BY Content_Type, Content_Id ORDER BY viewers desc)
	AS Top_Contents_Num
	from
	top_contents_current_week
where Top_Contents_Num<=5;
