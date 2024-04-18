# Ecommerce Dimensional Model

## Overview
This project is a follow-up from [Ecommerce Data Model and Analysis](https://github.com/elvarlax/ecommerce-data-model-analysis), where the focus was on creating a data model and conducting analysis. Now, in this next phase, we take the data model created in the previous project and transform it into a dimensional model using Snowflake and Azure. By leveraging Snowflake's cloud data warehousing capabilities and integrating with Azure services, we aim to enhance our analytics capabilities and derive deeper insights from ecommerce data.

## Dataset
The dataset used in this project comprises a subset of more than 3 million grocery orders placed by over 200,000 users on Instacart. Each user's dataset includes a variable number of orders, showcasing the sequence of products purchased in each order. Additionally, the dataset includes information about the week and time of day when the orders were placed, along with a relative measure of time between consecutive orders.

## Entity-Relationship (ER) Model
![Data Model](https://github.com/elvarlax/ecommerce-data-model-analysis/blob/main/er_model.jpg)

## Dimensional Model
![Dimensional Model](https://github.com/elvarlax/ecommerce-dimensional-model/blob/main/dimensional_model.jpg)

## Snowflake Implementation
In this phase, we take our ecommerce data analysis to the next level by harnessing the power of Snowflake's cloud data warehousing capabilities. The Snowflake implementation involves designing and deploying a dimensional model within Snowflake, comprising dimension tables for descriptive attributes and a fact table for measurable metrics. Snowflake's architecture allows for seamless integration with Azure for data ingestion and storage, enabling efficient analytics processing at scale.

## Integration with Azure
Integration with Azure services plays a crucial role in the project, facilitating data ingestion and storage processes. Data is ingested from Azure storage into Snowflake, ensuring data freshness and reliability for analytics purposes. The seamless integration between Azure and Snowflake environments enables users to leverage the strengths of both platforms for comprehensive ecommerce analytics.

## Installation and Setup
To replicate this project environment, follow these steps:

1. Clone this repository to your local machine.
2. Ensure access to a Snowflake account and Azure storage account.
3. Execute the SQL scripts in `staging.sql` to create tables and load data into Snowflake staging.
4. Execute the SQL scripts in `dimensional_model.sql` to create dimension and fact tables within Snowflake.
5. Execute the provided analytics queries in `practice_questions.sql` to perform analysis on the dataset and derive insights.

## Dependencies
- Snowflake: Cloud data warehousing platform for storing and analyzing data.
- Azure: Cloud platform for data storage and integration services.
- SQL: Query language for interacting with Snowflake and performing analytics queries.

## Practice Questions
To deepen your understanding of ecommerce analytics and dimensional modeling, the project includes a set of advanced practice questions. These questions cover a range of analytical tasks and can be used to test your proficiency in querying and analyzing data within the dimensional model. Each question is designed to extract valuable insights from the dataset and enhance your skills in working with Snowflake and performing advanced analytics.

1. **Total Products Ordered per Department**:
   - Calculate the total number of products ordered per department to understand the distribution of product orders across different departments within the ecommerce platform.

2. **Top 5 Aisles with the Highest Number of Reordered Products**:
   - Identify the top 5 aisles with the highest number of reordered products to pinpoint which product categories are most frequently repurchased by customers.

3. **Average Number of Products Added to Cart per Order by Day of the Week**:
   - Calculate the average number of products added to the cart per order for each day of the week to analyze shopping behavior patterns based on the day of the week.

4. **Top 10 Users with the Highest Number of Unique Products Ordered**:
   - Identify the top 10 users with the highest number of unique products ordered to recognize the most active users in terms of product diversity.

These practice questions provide valuable insights into various aspects of ecommerce data and offer opportunities to enhance your analytical skills through practical application.

## Conclusion
This project showcases the power of dimensional modeling and Snowflake's cloud data warehousing capabilities for ecommerce analytics. By implementing a dimensional model within Snowflake and integrating with Azure services, users can unlock deeper insights from ecommerce data to drive informed decision-making and optimize business strategies.