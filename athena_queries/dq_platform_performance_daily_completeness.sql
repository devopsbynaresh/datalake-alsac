CREATE OR REPLACE VIEW dq_platform_performance_daily_completeness AS 
SELECT
  "date"
, "Field"
, "Source"
, "sum"("Complete_ind") "complete_count"
, "sum"("Incomplete_ind") "Incomplete_count"
FROM
  (
   SELECT
     "date"
   , 'source' "Field"
   , "source"
   , (CASE WHEN (("source" IS NULL) OR ("source" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("source" IS NULL) OR ("source" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'date' "Field"
   , "source"
   , (CASE WHEN (("date" IS NULL) OR ("date" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("date" IS NULL) OR ("date" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'advertiser' "Field"
   , "source"
   , (CASE WHEN (("advertiser" IS NULL) OR ("advertiser" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("advertiser" IS NULL) OR ("advertiser" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'site_dcm' "Field"
   , "source"
   , (CASE WHEN (("site_dcm" IS NULL) OR ("site_dcm" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("site_dcm" IS NULL) OR ("site_dcm" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'campaign' "Field"
   , "source"
   , (CASE WHEN (("campaign" IS NULL) OR ("campaign" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("campaign" IS NULL) OR ("campaign" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'placement' "Field"
   , "source"
   , (CASE WHEN (("placement" IS NULL) OR ("placement" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("placement" IS NULL) OR ("placement" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'placement_id' "Field"
   , "source"
   , (CASE WHEN ("placement_id" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("placement_id" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'platform_type' "Field"
   , "source"
   , (CASE WHEN (("platform_type" IS NULL) OR ("platform_type" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("platform_type" IS NULL) OR ("platform_type" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'activity' "Field"
   , "source"
   , (CASE WHEN (("activity" IS NULL) OR ("activity" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("activity" IS NULL) OR ("activity" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'impressions' "Field"
   , "source"
   , (CASE WHEN ("impressions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("impressions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'clicks' "Field"
   , "source"
   , (CASE WHEN ("clicks" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("clicks" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'click_rate' "Field"
   , "source"
   , (CASE WHEN ("click_rate" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("click_rate" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'total_conversions' "Field"
   , "source"
   , (CASE WHEN ("total_conversions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("total_conversions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'video_completions' "Field"
   , "source"
   , (CASE WHEN ("video_completions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("video_completions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'view_through_conversions' "Field"
   , "source"
   , (CASE WHEN ("view_through_conversions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("view_through_conversions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'click_through_conversions' "Field"
   , "source"
   , (CASE WHEN ("click_through_conversions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("click_through_conversions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'video_first_quartile_completions' "Field"
   , "source"
   , (CASE WHEN ("video_first_quartile_completions" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("video_first_quartile_completions" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'video_midpoints' "Field"
   , "source"
   , (CASE WHEN ("video_midpoints" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("video_midpoints" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'video_plays' "Field"
   , "source"
   , (CASE WHEN ("video_plays" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("video_plays" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'click_through_revenue' "Field"
   , "source"
   , (CASE WHEN ("click_through_revenue" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("click_through_revenue" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'view_through_revenue' "Field"
   , "source"
   , (CASE WHEN ("view_through_revenue" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("view_through_revenue" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'total_revenue' "Field"
   , "source"
   , (CASE WHEN ("total_revenue" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("total_revenue" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'click_through_conversions_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("click_through_conversions_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("click_through_conversions_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'click_through_revenue_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("click_through_revenue_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("click_through_revenue_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'total_conversions_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("total_conversions_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("total_conversions_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'total_revenue_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("total_revenue_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("total_revenue_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'view_through_conversions_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("view_through_conversions_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("view_through_conversions_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'view_through_revenue_+_cross_environment' "Field"
   , "source"
   , (CASE WHEN ("view_through_revenue_+_cross_environment" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("view_through_revenue_+_cross_environment" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'spend' "Field"
   , "source"
   , (CASE WHEN ("spend" IS NULL) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN ("spend" IS NULL) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
UNION ALL    SELECT
     "date"
   , 'platform' "Field"
   , "source"
   , (CASE WHEN (("platform" IS NULL) OR ("platform" = '')) THEN 0 ELSE 1 END) "Complete_ind"
   , (CASE WHEN (("platform" IS NULL) OR ("platform" = '')) THEN 1 ELSE 0 END) "Incomplete_ind"
   FROM
     performance_marketing_digital_media.platform_performance_daily_union
)  dq
GROUP BY "date", "Field", "Source"