# Supply Chain Analytics Project

End-to-end supply chain analytics solution built using SQL, Python, and Power BI to monitor inventory flow, SLA performance, backlog, and operational efficiency.

---

## 📌 Business Problem

Supply chain operations often face challenges related to processing delays, backlog accumulation, and inefficient resource utilization across facilities.

This project simulates a real-world supply chain environment to track:
- Shipment processing timelines
- SLA compliance
- Backlog volume
- Facility performance
- Throughput trends

---

## 🎯 Objectives

- Identify SLA breaches across facilities
- Monitor backlog and operational bottlenecks
- Compare facility-level performance
- Analyze processing efficiency
- Enable data-driven decision making

---

## 📊 KPIs Tracked

- SLA Compliance %
- Backlog Volume
- Processing Split (Expedited / Standard / Pending)
- Throughput (Daily/Facility Level)
- Facility Performance Comparison

---

## 🧱 Project Structure

data/
raw/ → Raw input datasets
cleaned/ → Processed datasets

sql/ → KPI queries and transformations
notebooks/ → Python analysis
dashboard/ → Visualization files
docs/ → Business problem and KPI definitions

---

## 🛠️ Tools & Technologies

- SQL (Data modeling, KPI logic)
- Python (Data processing, analysis)
- Power BI (Dashboard visualization)
- GitHub (Version control & project structure)

---

## 📈 Sample Analysis

The SQL layer includes:
- SLA compliance calculations using time-based logic
- Backlog identification using NULL processing dates
- Throughput tracking by facility and date
- Facility-level performance benchmarking

---

## 🚀 Future Enhancements

- Add inventory and component-level datasets
- Build interactive Power BI dashboard
- Implement anomaly detection using Python
- Add forecasting for shipment volumes

---

## 📌 Key Takeaway

This project demonstrates the ability to translate business problems into structured data models, KPIs, and analytical solutions—mirroring real-world supply chain analytics workflows.
