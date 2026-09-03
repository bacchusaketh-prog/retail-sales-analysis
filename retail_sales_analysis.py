import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

raw_file = "retail_sales_raw.csv"
clean_file = "retail_sales_cleaned.csv"

df = pd.read_csv(raw_file)

print("RAW DATA")
print(df.head())
print(df.shape)
print(df.info())
print(df.describe(include="all"))

print("\nMISSING VALUES")
print(df.isnull().sum())

print("\nDUPLICATES")
print(df.duplicated().sum())

df["Order_Date"] = pd.to_datetime(df["Order_Date"])

df["Customer_Name"] = df["Customer_Name"].fillna("Unknown")
df["City"] = df["City"].fillna("Unknown")

df = df.drop_duplicates().copy()

df = df[df["Quantity"] > 0].copy()
df = df[df["Unit_Price"] >= 0].copy()
df = df[df["Sales"] >= 0].copy()
df = df[df["Cost"] >= 0].copy()

df["Revenue_Before_Discount"] = df["Quantity"] * df["Unit_Price"]
df["Profit_Margin"] = np.where(
    df["Sales"] != 0,
    (df["Profit"] / df["Sales"]) * 100,
    0
)
df["Month"] = df["Order_Date"].dt.to_period("M").astype(str)
df["Year"] = df["Order_Date"].dt.year

df.to_csv(clean_file, index=False)

print("\nCLEAN DATA")
print(df.head())
print(df.shape)
print(df.isnull().sum())
print("Duplicates:", df.duplicated().sum())

print("\nKEY KPIs")
total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_orders = df["Order_ID"].nunique()
total_quantity = df["Quantity"].sum()
average_order_value = total_sales / total_orders
profit_margin = total_profit / total_sales * 100

print("Total Sales:", round(total_sales, 2))
print("Total Profit:", round(total_profit, 2))
print("Total Orders:", total_orders)
print("Total Quantity:", total_quantity)
print("Average Order Value:", round(average_order_value, 2))
print("Profit Margin:", round(profit_margin, 2), "%")

print("\nCATEGORY SALES")
category_sales = df.groupby("Category")["Sales"].sum().sort_values(ascending=False)
print(category_sales)

print("\nCATEGORY PROFIT")
category_profit = df.groupby("Category")["Profit"].sum().sort_values(ascending=False)
print(category_profit)

print("\nREGION SALES")
region_sales = df.groupby("Region")["Sales"].sum().sort_values(ascending=False)
print(region_sales)

print("\nREGION PROFIT")
region_profit = df.groupby("Region")["Profit"].sum().sort_values(ascending=False)
print(region_profit)

print("\nTOP 10 PRODUCTS BY SALES")
top_products = df.groupby("Product")["Sales"].sum().sort_values(ascending=False).head(10)
print(top_products)

print("\nTOP 10 PRODUCTS BY PROFIT")
top_profit_products = df.groupby("Product")["Profit"].sum().sort_values(ascending=False).head(10)
print(top_profit_products)

print("\nMONTHLY SALES")
monthly_sales = df.groupby("Month")["Sales"].sum()
print(monthly_sales)

print("\nMONTHLY PROFIT")
monthly_profit = df.groupby("Month")["Profit"].sum()
print(monthly_profit)

print("\nTOP 10 CUSTOMERS")
top_customers = df.groupby(["Customer_ID", "Customer_Name"])["Sales"].sum().sort_values(ascending=False).head(10)
print(top_customers)

print("\nDISCOUNT ANALYSIS")
discount_analysis = df.groupby("Discount").agg(
    Total_Sales=("Sales", "sum"),
    Total_Profit=("Profit", "sum"),
    Average_Profit_Margin=("Profit_Margin", "mean")
).sort_index()
print(discount_analysis)

print("\nSUB-CATEGORY PROFIT")
subcategory_profit = df.groupby("Sub_Category")["Profit"].sum().sort_values(ascending=False)
print(subcategory_profit)

print("\nCITY SALES")
city_sales = df.groupby("City")["Sales"].sum().sort_values(ascending=False)
print(city_sales)

plt.figure(figsize=(8, 5))
category_sales.plot(kind="bar")
plt.title("Sales by Category")
plt.xlabel("Category")
plt.ylabel("Sales")
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 5))
monthly_sales.plot(kind="line", marker="o")
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

plt.figure(figsize=(8, 5))
region_profit.plot(kind="bar")
plt.title("Profit by Region")
plt.xlabel("Region")
plt.ylabel("Profit")
plt.tight_layout()
plt.show()

top_products = df.groupby("Product")["Sales"].sum().sort_values(ascending=False).head(10)

plt.figure(figsize=(10, 6))
top_products.plot(kind="bar")
plt.title("Top 10 Products by Sales")
plt.xlabel("Product")
plt.ylabel("Sales")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.show()

discount_margin = df.groupby("Discount")["Profit_Margin"].mean()

plt.figure(figsize=(8, 5))
discount_margin.plot(kind="line", marker="o")
plt.title("Discount vs Average Profit Margin")
plt.xlabel("Discount")
plt.ylabel("Average Profit Margin (%)")
plt.tight_layout()
plt.show()