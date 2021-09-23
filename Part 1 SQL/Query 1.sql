#1
SELECT 
    Content_id, Viewers
FROM
    (SELECT 
        Content_id, COUNT(DISTINCT Ads_User_Id) AS Viewers
    FROM
        Content_Metadata metadata
    LEFT JOIN Page_Impression impressions ON metadata.Content_id = impressions.Content_id
    GROUP BY metadata.Content_id) sub_table_1
ORDER BY Viewer_counts DESC
LIMIT 5;