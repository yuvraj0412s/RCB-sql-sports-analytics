<div align="center">
  
# IPL SQL Sports Analytics
### Data-Driven Strategies for Squad Optimization & Auction ROI

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Sports Analytics](https://img.shields.io/badge/Sports_Analytics-000000?style=for-the-badge&logo=googleanalytics&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

![IPL Dashboard](assets/dashboard.png)

</div>

---

## 📌 Business Problem

In franchise cricket, particularly the Indian Premier League (IPL), squad construction and match-day tactics often rely on intuition rather than empirical data. This leads to inefficient auction spending and suboptimal on-field strategies.

**The Objective:**
This SQL-based sports analytics project was developed to provide the Royal Challengers Bangalore (RCB) franchise with a rigorous, data-driven framework. The goal is to optimize squad composition, maximize auction Return on Investment (ROI), and refine match-day tactics (e.g., toss decisions, venue-specific strategies).

**Expected Outcome:**
Strategic, actionable recommendations that improve team balance, minimize scoring leakage, and build long-term consistency across seasons.

---

## 🗄️ Database Overview

The analysis leverages a comprehensive, multi-season IPL dataset organized in a normalized relational structure.

- **Granularity:** Ball-by-ball delivery data integrated with match outcomes.
- **Core Tables:**
  - `Ball_by_Ball`: Every delivery, runs scored, and extras.
  - `Matches`: Match outcomes, toss decisions, and venue assignments.
  - `Player`: Player metadata and batting/bowling styles.
  - `Team`: Franchise information.
  - `Season`: Year-over-year tracking.
  - `Venue`: Stadium specifics.

---

## 🛠️ Advanced SQL Skills Demonstrated

This project showcases complex database querying and performance optimization techniques:

- **Complex Joins:** Utilizing up to 5 `JOIN` operations (including `LEFT JOIN` for nullable extra runs) to construct holistic views of player performance.
- **Window Functions:** Leveraging `RANK()` and `DENSE_RANK()` for cohort analysis and leaderboard generation without distorting aggregations.
- **Advanced Aggregations:** Utilizing `SUM`, `COUNT`, `COALESCE`, and conditional `CASE` statements to engineer custom metrics like pure strike rates and bowling economy.
- **Data Filtering & Grouping:** Utilizing `GROUP BY`, `HAVING`, and sophisticated `WHERE` clauses to isolate statistically significant samples (e.g., minimum balls faced).
- **Subqueries & CTEs:** Structuring multi-step logical analyses for readability and modularity.

---

## 🔄 Analysis Workflow

1. **Schema Exploration:** Validated data structures using `INFORMATION_SCHEMA`.
2. **Data Cleaning:** Handled nulls and standardized team nomenclature.
3. **Metric Engineering:** Built queries to calculate pure strike rates and isolate scoring leakage (extras).
4. **Performance Analysis:** Ranked players, evaluated venues, and analyzed toss impacts.
5. **Business Insights:** Translated raw metrics into actionable franchise strategies.
6. **Strategic Recommendations:** Developed an auction and match-day blueprint for RCB.

---

## 📈 Key Analyses & Visualizations

### The Cost of "Extra" Runs
Analysis revealed that during RCB's initial season, extra runs accounted for 15-20% of their total score. This highlighted a severe lack of bowling discipline and a direct correlation with lost match momentum.

### Elite Finisher Value (Strike Rate)
Calculated pure strike rates (filtering out wides/no-balls). The data proved that elite batsmen (e.g., AB de Villiers at 164.27 SR) act as extreme momentum shifters in death overs, commanding premium auction valuation.

### Venue & Toss Dynamics
Cross-referenced toss decisions (bat vs. field) against match winners per venue. Demonstrated that certain stadiums heavily favor chasing teams, necessitating a strict, data-driven approach at the toss rather than relying on captain's intuition.

---

## 💡 Strategic Recommendations

Based on the quantitative findings, the following strategies were presented:

1. **Auction Optimization:** Reallocate budget to prioritize high-strike-rate finishers and dual-threat all-rounders over pure specialist top-order batsmen.
2. **Bowling KPIs:** Institute immediate training camps focused on bowling discipline. Minimizing the 15% extra-run leakage is the fastest path to improving defensive efficiency.
3. **Venue-Specific Tactics:** Equip the on-field captain with venue matrices. Eliminate "gut-feel" toss decisions in favor of historically optimal strategies (e.g., auto-fielding at chase-friendly stadiums).

---

## 🚀 Future Improvements

- **Predictive Modeling:** Integrate Python (pandas/scikit-learn) to build machine learning models predicting match outcomes based on live ball-by-ball data.
- **Real-Time Dashboards:** Connect the SQL database directly to Power BI or Tableau for live, in-match strategic dashboards for the coaching staff.
- **Player Matchup Analysis:** Develop granular batter-vs-bowler historical matchup queries to optimize over-by-over field placements.

---

## 📁 Repository Structure

```text
ipl-sql-sports-analytics/
├── README.md                 # Project overview and strategic insights
├── LICENSE                   # MIT License
├── assets/                   # Charts, dashboards, and presentation screenshots
├── sql/                      # Modular, documented SQL queries
│   ├── player-analysis.sql
│   ├── venue-analysis.sql
│   ├── toss-analysis.sql
│   ├── strike-rate.sql
│   └── queries.sql           # Full subjective queries suite
├── presentation/             # Executive presentation slides (.pptx)
└── documentation/            # Detailed markdown files on methodology and insights
```

---

*Engineered by [Yuvraj Singh]. Transforming raw sports data into competitive franchise advantages.*
