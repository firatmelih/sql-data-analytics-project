# SQL Data Analytics Project
A comprehensive collection of SQL scripts for data exploration, analytics, and reporting. These scripts cover various analyses such as database exploration, measures and metrics, time-based trends, cumulative analytics, segmentation, and more.
This repository contains SQL queries designed to help data analysts and BI professionals quickly explore, segment, and analyze data within a relational database. Each script focuses on a specific analytical theme and demonstrates best practices for SQL queries.

---

![Analytics Steps](docs/analytics_steps.png)


## Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Datasets used for the project (facts and dimensions)
│
├── docs/                               
│   ├── analytics_steps.png             # Project Roadmap Sketch
│
├── scripts/                            # SQL scripts for EDA and Advanced Analytics
│   ├── 0_init_database.sql             # Scripts for creating tables from datasets
│   ├── 1_database_exploration.sql      # Scripts for exploring the structure of the database
│   ├── 2_dimension_exploration.sql     # Scripts for exploring the structure of dimension tables
│   ├── 3_date_range_exploration.sql    # Scripts for determining the temporal boundaries of key data points and understanding the range of historical data
│   ├── 4_measures_exploration.sql      # Scripts for calculating aggregated metrics identifying overall trends or spot anomalies.
│   ├── 5_magnitude_analysis.sql        # Scripts for quantifying data and group results by specific dimensions and understanding data distribution across categories
│   ├── 6_ranking_analysis.sql          # Scripts for ranking items based on performance or other metrics and identifying top performers etc.
│   ├── 7_change_over_time_analysis.sql # Scripts for tracking trends, growth, and changes etc.
│   ├── 8_cumulative_analysis.sql       # Scripts for cumulative analysing
│   ├── 9_performance_analysis.sql      # Scripts for performance analysing
│   ├── 10_data_segmentation.sql        # Scripts for segmentating the data
│   ├── 11_part_to_whole_analysis.sql   # Scripts for evaluating differences between categories
│   ├── 12_report_customers.sql         # Scripts for consolidating key customer metrics and behaviors
│   ├── 13_report_products.sql          # Scripts for consolidating key product metrics and behaviors
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
```

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## About Me

Hi there! I'm **Melih Firat**. I’m Software Engineer and passionate indie dev that makes cool mobile apps.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/firatmelih)
[![Website](https://img.shields.io/badge/Website-000000?style=for-the-badge&logo=google-chrome&logoColor=white)](https://melihfiratapps.github.io)
