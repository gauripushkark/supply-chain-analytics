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
