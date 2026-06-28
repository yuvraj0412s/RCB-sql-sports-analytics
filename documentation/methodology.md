# Methodology

## Data Foundation & Validation
- **Schema Exploration**: Utilized `INFORMATION_SCHEMA` to validate the structural integrity of the `Ball_by_Ball`, `Matches`, `Season`, and `Team` tables before initiating analytical queries.
- **Data Quality Checks**: Handled null values (e.g., using `COALESCE` for extra runs) to ensure accurate aggregations across all seasons.

## Analytical Approach
- **Granular Aggregation**: Analyzed ball-by-ball delivery data to reconstruct match innings, calculating precise run contributions including extras.
- **Window Functions**: Implemented advanced window functions (e.g., `RANK()`, `DENSE_RANK()`) to identify top performers conditionally by season or venue without distorting the underlying dataset.
- **Complex Joins**: Engineered queries joining up to 5 relational tables to correlate individual player performance with match outcomes and venue specifics.

## Performance Metrics Engineered
- **Strike Rate Calculation**: Developed a robust formula `(SUM(Runs)/SUM(Balls)) * 100` filtering out "wide" and "no-ball" deliveries to isolate pure batting efficiency.
- **Impact Scoring**: Evaluated all-rounders by cross-referencing batting strike rates with bowling economy and total wickets taken.
- **Toss Impact Analysis**: Correlated toss decisions (bat vs. field) with win percentages across different venues to deduce optimal match-day strategies.
