-- Calculate processing time and SLA status

SELECT 
    shipment_id,
    facility,
    arrival_date,
    processed_date,
    
    -- Processing time in hours
    TIMESTAMPDIFF(HOUR, arrival_date, processed_date) AS processing_time_hours,

    -- SLA logic (12-hour threshold for expedited)
    CASE 
        WHEN processing_type = 'expedited' 
             AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 12 
        THEN 'Within SLA'
        
        WHEN processing_type = 'standard' 
             AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 48 
        THEN 'Within SLA'

        WHEN processed_date IS NULL THEN 'Pending'
        
        ELSE 'SLA Breach'
    END AS sla_status

FROM shipments;


-- KPI 1: Backlog by facility
SELECT 
    facility,
    COUNT(*) AS pending_shipments,
    SUM(container_count) AS pending_containers
FROM shipments
WHERE processed_date IS NULL
GROUP BY facility;


-- KPI 2: Processing split
SELECT 
    processing_type,
    COUNT(*) AS shipment_count,
    SUM(container_count) AS total_containers
FROM shipments
GROUP BY processing_type;


-- KPI 3: Weekly throughput by facility
SELECT
    facility,
    DATE(arrival_date) AS arrival_day,
    COUNT(*) AS shipment_count,
    SUM(container_count) AS total_containers
FROM shipments
WHERE processed_date IS NOT NULL
GROUP BY facility, DATE(arrival_date)
ORDER BY arrival_day, facility;


-- KPI 4: Facility SLA performance
SELECT
    facility,
    COUNT(*) AS total_shipments,
    SUM(CASE 
            WHEN processing_type = 'expedited'
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 12
            THEN 1
            WHEN processing_type = 'standard'
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 48
            THEN 1
            ELSE 0
        END) AS shipments_within_sla,
    ROUND(
        100.0 * SUM(CASE 
            WHEN processing_type = 'expedited'
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 12
            THEN 1
            WHEN processing_type = 'standard'
                 AND TIMESTAMPDIFF(HOUR, arrival_date, processed_date) <= 48
            THEN 1
            ELSE 0
        END) / COUNT(*), 
        2
    ) AS sla_compliance_percent
FROM shipments
WHERE processed_date IS NOT NULL
GROUP BY facility;

-- KPI 5: Item backlog by facility and category
SELECT
    facility,
    item_category,
    COUNT(*) AS backlog_items
FROM inventory_items
WHERE item_status = 'Backlog'
GROUP BY facility, item_category
ORDER BY facility, item_category;


-- KPI 6: Shipment-to-item processing summary
SELECT
    s.shipment_id,
    s.facility,
    s.processing_type,
    s.container_count,
    COUNT(i.item_id) AS item_count,
    SUM(CASE WHEN i.item_status = 'Processed' THEN 1 ELSE 0 END) AS processed_items,
    SUM(CASE WHEN i.item_status = 'Backlog' THEN 1 ELSE 0 END) AS backlog_items
FROM shipments s
LEFT JOIN inventory_items i
    ON s.shipment_id = i.shipment_id
GROUP BY
    s.shipment_id,
    s.facility,
    s.processing_type,
    s.container_count
ORDER BY s.shipment_id;
