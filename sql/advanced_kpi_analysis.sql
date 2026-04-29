-- Step 1: Calculate processing times

WITH shipment_processing AS (
    SELECT
        shipment_id,
        facility,
        processing_type,
        container_count,
        arrival_date,
        processed_date,

        TIMESTAMPDIFF(HOUR, arrival_date, processed_date) AS processing_hours,

        CASE
            WHEN processed_date IS NULL THEN 'Pending'
            WHEN processing_type = 'expedited' 
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 12
            THEN 'Within SLA'
            WHEN processing_type = 'standard' 
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 48
            THEN 'Within SLA'
            ELSE 'SLA Breach'
        END AS sla_status

    FROM shipments
),

-- Step 2: Facility-level aggregation

facility_performance AS (
    SELECT
        facility,
        COUNT(*) AS total_shipments,
        SUM(container_count) AS total_volume,

        SUM(CASE WHEN sla_status = 'Within SLA' THEN 1 ELSE 0 END) AS sla_met,
        SUM(CASE WHEN sla_status = 'SLA Breach' THEN 1 ELSE 0 END) AS sla_breach,
        SUM(CASE WHEN sla_status = 'Pending' THEN 1 ELSE 0 END) AS pending_count

    FROM shipment_processing
    GROUP BY facility
)

-- Step 3: Final output with SLA %

SELECT
    facility,
    total_shipments,
    total_volume,
    sla_met,
    sla_breach,
    pending_count,

    ROUND(100.0 * sla_met / total_shipments, 2) AS sla_compliance_percent

FROM facility_performance
ORDER BY sla_compliance_percent DESC;
