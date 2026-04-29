-- Facility trend analysis using window functions

WITH daily_facility_volume AS (
    SELECT
        facility,
        DATE(arrival_date) AS arrival_day,
        COUNT(*) AS shipment_count,
        SUM(container_count) AS total_containers
    FROM shipments
    GROUP BY facility, DATE(arrival_date)
),

trend_analysis AS (
    SELECT
        facility,
        arrival_day,
        shipment_count,
        total_containers,

        -- Ranking facilities by daily volume
        RANK() OVER (
            PARTITION BY arrival_day
            ORDER BY total_containers DESC
        ) AS daily_volume_rank,

        -- Running total by facility
        SUM(total_containers) OVER (
            PARTITION BY facility
            ORDER BY arrival_day
        ) AS running_total_containers,

        -- Previous day volume for comparison
        LAG(total_containers) OVER (
            PARTITION BY facility
            ORDER BY arrival_day
        ) AS previous_day_containers

    FROM daily_facility_volume
)

SELECT
    facility,
    arrival_day,
    shipment_count,
    total_containers,
    daily_volume_rank,
    running_total_containers,
    previous_day_containers,
    total_containers - previous_day_containers AS day_over_day_change
FROM trend_analysis
ORDER BY arrival_day, daily_volume_rank;
