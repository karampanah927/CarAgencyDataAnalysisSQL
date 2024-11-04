# Car Agency Data Analysis

This project is designed for preparation and analyzing car advertisement data using Microsoft SQL Server. The dataset provides various details about car advertisements, enabling insights into pricing, ad performance, stock duration, and other metrics that can support decision-making in car sales and advertising.

## Project Structure

- **Database**: Microsoft SQL Server
- **Table**: `car_ads`

### Table Schema

The `car_ads` table contains the following fields:

| Column                 | Data Type      | Description                                          |
|------------------------|----------------|------------------------------------------------------|
| `ad_id`                | nvarchar(50)   | Unique identifier for each advertisement             |
| `product_type`         | nvarchar(50)   | Type of product being advertised (e.g., car, truck)  |
| `car_brand`            | nvarchar(100)  | Brand of the car being advertised                    |
| `price`                | nvarchar(50)   | Price of the car                                     |
| `first_zip_digit`      | nvarchar(50)   | First digit of the postal code for geographic analysis|
| `first_registration_year` | nvarchar(50) | Year the car was first registered                   |
| `created_date`         | nvarchar(50)   | Date the advertisement was created                   |
| `deleted_date`         | nvarchar(50)   | Date the advertisement was removed (if applicable)   |
| `views`                | nvarchar(50)   | Number of times the ad has been viewed               |
| `clicks`               | nvarchar(50)   | Number of times the ad has been clicked              |
| `stock_days`           | nvarchar(50)   | Number of days the car was in stock                  |
| `ctr`                  | nvarchar(50)   | Click-through rate, calculated as clicks/views       |

### Getting Started

1. **Clone the Repository**: Start by cloning this repository to your local machine.
   ```bash
   git clone https://github.com/karampanah927/CarAgencyDataAnalysisSQL.git

### 2. Set Up Database
Ensure you have Microsoft SQL Server installed. Create the `car_ads` table using the schema provided earlier.

### 3. Load Data
Load the data into the `car_ads` table. You may use any ETL process, or directly import the dataset if available.

## Analysis Goals

This dataset can support a variety of analyses, including:

- **Understanding the distribution** of car brands and types.
- **Analyzing price trends** across different brands and registration years.
- **Examining ad performance** metrics based on `views`, `clicks`, `ctr`, and `stock_days`.
- **Geographical distribution analysis** based on `first_zip_digit`.

## SQL Queries

Sample SQL queries for basic analysis will be provided in this repository to aid data exploration and insights.

## Contributing

Contributions are welcome! Feel free to submit pull requests or report any issues for improvements and enhancements to this project.
