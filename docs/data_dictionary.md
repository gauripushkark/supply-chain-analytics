# Data Dictionary

## shipments.csv

| Column | Description |
|---|---|
| shipment_id | Unique shipment identifier |
| facility | Facility where the shipment was received |
| arrival_date | Date and time when shipment arrived |
| processed_date | Date and time when shipment processing was completed |
| processing_type | Shipment processing category: expedited, standard, or pending |
| container_count | Number of containers associated with the shipment |

## inventory_items.csv

| Column | Description |
|---|---|
| item_id | Unique inventory item identifier |
| shipment_id | Shipment identifier linked to the item |
| facility | Facility where the item was received |
| item_category | Product/category classification |
| item_status | Current processing status of the item |
| received_date | Date and time when the item was received |
| processed_date | Date and time when the item was processed |
