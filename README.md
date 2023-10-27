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

![](https://github.com/jakesamuel99/AdventureWorks_proj/blob/main/images/IODF_sales_dashboard.png)

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

## Demand Forecasting

**Objective:**

Bikes and components were the biggest drivers of revenue, so we want to focus on these two product categories for our analysis. We want to accurately forecast demand so that we can prepare for it and meet it as closely as possible to avoid missing orders or holding excess inventory.

**Method:**

Plots of bike/component order quantity vs dates show a complex pattern of large order spikes at a cyclical interval of each month. Initially, I decided to demand forecast using Holt-Winters due to this model’s inclusion of trend and seasonality that is left out in the more basic “simple exponential smoothing” forecasting model. The seasonality component is important due to the presence of the repeating, cyclical pattern of demand spikes. Additionally, there seems to be a trend of increasing demand over time. I set the model’s trend parameter to be “additive” because the demand appears to increase with time, and I set the seasonality parameter to be “multiplicative” because the demand spikes appear to be growing in magnitude over time.

**Holt-Winters’ Steps:**

1. Imported relevant libraries and used sqlalchemy and pandas to query and import orders data into python data frames (after confirming there was no missing data). One data frame for bikes, and one data frame for components.
2. Created Holt-Winters’ model using “statsmodels” library.

A visual inspection of the Holt-Winters’ model predictions indicated that it did not seem to effectively capture the cyclical demand spike pattern, even after adjusting several of the parameters. For this reason, I decided to develop another model to forecast demand. I opted to implement a random forest model due to the intricate relationships, seasonality, and interactions.

**Random Forest Steps:**

1. Modified bike and component data frames to have “lag features” and “binary” feature columns.
2. Organized data into Input Features (X) and Target Variable (y).
3. Split the data into training and testing sets.
4. Trained random forest model using “sklearn” library.
5. Created a data frame of predictions, as well as 90% confidence interval prediction bounds.
6. Plotted results and validated performance.

**Analysis:**

These charts illustrate that the random forest model much better captures the dynamic demand spikes and fluctuations than the Holt-Winters model. While it may be difficult to see in the plots, the actual demand is accurately captured, 90% of the time, in the prediction interval.

The MAE, MSE, and RMSE were all calculated to assess performance. With more time, I would create and compare other models, and optimize parameters to minimize these error metrics and choose the best-performing model and parameters to forecast demand.

**Challenges:**

- Time constraints limiting how many models can be developed, tested, and optimized.

### Safety Stock and Reorder Point for Bikes

Due to the large variability of demand between any given day each month versus the sales spikes at the beginning/end of each month, I decided to segment my safety stock and reorder point calculations. I calculated the safety stock and reorder point for any typical day during the months by excluding the dates of sales spikes from my calculations of demand average and demand variance.

I determined the safety stock and reorder points of bikes as an average instead of for each individual type of bike. To do this, I calculated the lead time average and lead time standard deviation for each type of bike. Then, I found the average of all the lead times, and the root sum of squares of all the standard deviations. I defined that I want a 95% service level and then used the “King’s Method” for calculating the safety stock.

**For standard monthly operations of bikes:**
- The average safety stock value is 97.
- The reorder point is 413.

An EOQ model can be used to determine the quantity of orders to make when hitting the reorder point. However, we would need to have information on ordering and holding costs, which we do not have, to develop the EOQ model.

In addition to standard day-to-day safety stock and reorder points outlined above, a dynamic replenishment strategy can be used specifically for the days leading up to the end of the month when the spikes occur. Due to the lead time variability of bike manufacturing, we need to define what is more important: having a high service level or minimizing holding costs. If we decide that we want to prioritize service level at the expense of increased holding costs, there are two steps we need to take. The first is to use the demand forecasting model to determine on which date and how many orders we expect there to be. The upper bounds of the forecast should be used to ensure enough inventory is ordered. The second step is to identify the probability, i.e., 99%, that we want to receive those orders on time. This probability is needed to identify a z-score. Then, the z-score, average lead time, and standard deviation lead time are all used to calculate how many days in advance we need to place the order before the spike.

## Key Business Insights and Recommendations

- Focus marketing and inventory efforts on high-revenue categories like bikes and components. These categories make up only half of orders but are 97% of all revenue.
- Plan inventory and marketing strategies around the monthly sales spikes, ensuring sufficient stock during these periods.
- Explore the reasons behind low revenue from clothing and accessories, and consider strategic adjustments. These categories make up 3% of all revenue but are half of all orders.
- Investigate and improve the production processes for mountain bikes, road bikes, frame components, and seat assemblies to reduce scrap rates. These are the most frequent and costly items scrapped.
- Identify and address bottlenecks in bike production. These are the biggest drivers of revenue but have the highest percentage of late manufacturing work orders.
- Invest in fine-tuning and optimizing demand forecasting models to minimize error metrics. This will enable the best demand predictions so that supply can be allocated accordingly.
