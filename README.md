# Retail Sales & Profitability Analysis (Python & SQL)

An end-to-end data analysis project exploring retail transactional data to extract actionable business insights on sales, margins, discount impact, and regional profitability.

---

## 📌 Project Overview
* **Data Cleaning & ETL (Python):** Handled missing values, deduplicated records, filtered out invalid negative transactions, and engineered KPIs like `Profit_Margin` and `Revenue_Before_Discount`.
* **Exploratory Data Analysis (Matplotlib):** Visualized sales distribution across categories, monthly trends, and regional performance.
* **Advanced Querying (SQL):** Loaded the transformed dataset into relational tables to compute rankings, running totals, and month-over-month trends using CTEs and Window Functions (`RANK`, `LAG`, `PARTITION BY`).

---

## 🛠 Tech Stack
* **Languages & Libraries:** Python (Pandas, NumPy, Matplotlib), SQL (MySQL)
* **Concepts:** Data Imputation, Outlier Filtering, Feature Engineering, Aggregations, Window Functions, CTEs

---

## 📊 Key Findings & Business Insights
* **Category Performance:** Highlighting the highest margin product categories versus those heavily driven by volume.
* **Discount Impact:** Identified profit erosion patterns across steep discount brackets.
* **Monthly Trends:** Tracked seasonal sales spikes and MoM growth metrics using SQL window functions.

---

## 📁 Repository Structure
* `data/` – Raw and preprocessed CSV datasets.
* `scripts/` – Python cleaning and data preparation script.
* `sql/` – Analytical SQL queries, KPI aggregations, and window functions.
* `visualizations/` – Exported charts and summary figures.

---

## 🚀 How to Run

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/](https://github.com/)<YOUR-USERNAME>/retail-sales-analysis.git
   cd retail-sales-analysis