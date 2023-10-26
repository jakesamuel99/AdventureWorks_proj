# Microsoft’s Adventure Works Cycles - Inventory Optimization and Demand Forecasting

### Problem Statement

Adventure Works Cycles, a sample bicycle manufacturer and seller, sought to enhance its operational efficiency, optimize inventory management, and improve revenue generation through data-driven insights. The objective was to extract valuable insights and make informed recommendations to address key challenges and opportunities within the organization. This comprehensive analysis leveraged various data science skills and tools, including data visualization, demand forecasting, machine learning, feature engineering, and relational databases, while utilizing Python, Tableau, and Postgres SQL for data manipulation and visualization. The project was executed using the AdventureWorks 2014 Database provided by Microsoft, which encompasses diverse schemas such as Manufacturing, Sales, Purchasing, Product Management, Contact Management, and Human Resources.

### Skills Demonstrated

- Data Visualization
- Demand Forecasting
- Machine Learning (Random Forest)
- Feature Engineering
- Relational Databases

### Tools Used

- Python (Pandas, NumPy, Matplotlib, Statsmodels)
- Tableau
- Postgres SQL

### Data

- **AdventureWorks 2014 Database**, by Microsoft.

The AdventureWorks database contains data from a sample bicycle manufacturer and seller (Adventure Works Cycles). The main schema includes Manufacturing, Sales, Purchasing, Product Management, Contact Management, and Human Resources.

This database was designed for MS SQL Server, but I imported it into Postgres using LINK.

## Sales Analysis Dashboard

**Methods:**

I executed several complex queries in Postgres to join columns from tables containing sales information, product information, and region information. The goal was to capture all relevant information while keeping the data size minimal. There were gaps in the sales data for certain product categories on specific dates due to there being no sales for that product category on those respective dates (fair assumption). As part of a query, I used a cross join to ensure that every day had a sales quantity for each of the respective categories. For example, if there were no sales of clothing on a particular day, then a new row was added with Category = clothing, Quantity = 0. This was critical for producing an accurate chart of sales quantity vs date. The resulting SQL output data size was small, so I exported the output to a CSV, which I then imported into Tableau to create the visualizations.

**Analysis/Insights:**

According to the bar chart, we can see that the North American market is the largest. From the pie charts, we can see that bikes are the biggest drivers of revenue, followed by components. Just these two categories together account for 97% of all revenue, which only accounts for about half of all products sold. Likewise, sales of clothing and accessories accounted for 50% of sales but only made up 3% of the company’s revenue.

We can also see a very strong, and important pattern - that there are large sales spikes at either the very end or very beginning of each month, and little to no sales on the other days.

**Challenges:**

- Importing the data non-native to Postgres (compatibility issues).
- Creating the complex cross-join query to add new rows for categories with 0 sales on days during the date range.

## Production Analysis Dashboard

**Methods:**

Similar method as used in creating the Sales Analysis dashboard. I created some new features "on_time" (Boolean, TRUE if end date <= due date) and "days_late" (production end date – due date), which are important for understanding production operations. Many items produced did not have an associated category, so in my query, I separated those items into newly created subcategories based on each item’s name. Additionally, many scrapped items, such as "ball bearings" and "hub caps," did not have any cost data. Therefore, I had to approximate the values of these scrapped items using online price data and looking at input material costs for these products on the "billofmaterials" table of the AdventureWorks dataset. I used conservative numbers when approximating the values of these scrapped items. I exported the query outputs to CSVs, which I then imported into Tableau to create the visualizations.

**Analysis:**

The pie charts show us that frame components are scrapped the most, followed by seat assemblies, steering components, frame tubes, and hub components. Few products from the other categories are scrapped. We can also interpret from the KPI that there is a large percentage (~31% or 22,790 orders) of orders that are completed after their due dates. Mountain bikes, seat assemblies, and road bikes are the top 3 scrapped products contributing to financial losses.

**Challenges:**

- Approximating the values of scrapped items for which I did not have cost data.
