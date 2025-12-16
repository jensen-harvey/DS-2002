# DS-2002 Data Project 1 - Architecture Overview

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     DATA SOURCES (OLTP)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  MySQL Database  │  │    CSV File      │  │  JSON File   │ │
│  │  (Relational)    │  │  (Semi-struct)   │  │ (Unstructured)│ │
│  ├──────────────────┤  ├──────────────────┤  ├──────────────┤ │
│  │ source_customer_ │  │ sales_trans      │  │ product_     │ │
│  │ db.customers     │  │ actions.csv      │  │ catalog.json │ │
│  │                  │  │                  │  │              │ │
│  │ • customer_id    │  │ • transaction_id │  │ • product_id │ │
│  │ • first_name     │  │ • date           │  │ • name       │ │
│  │ • last_name      │  │ • customer_id    │  │ • category   │ │
│  │ • email          │  │ • product_id     │  │ • price      │ │
│  │ • country        │  │ • quantity       │  │ • brand      │ │
│  │ • city           │  │ • unit_price     │  │ • supplier   │ │
│  │ • segment        │  │ • discount       │  │              │ │
│  └────────┬─────────┘  └────────┬─────────┘  └──────┬───────┘ │
│           │                     │                    │         │
└───────────┼─────────────────────┼────────────────────┼─────────┘
            │                     │                    │
            │   ┌─────────────────▼────────────────────▼─────┐
            │   │                                             │
            └───►           ETL PIPELINE (Python)            │
                │                                             │
                │  ┌──────────────────────────────────────┐  │
                │  │         EXTRACT Phase                │  │
                │  ├──────────────────────────────────────┤  │
                │  │ • Read from MySQL using SQL query    │  │
                │  │ • Parse CSV using pandas.read_csv()  │  │
                │  │ • Load JSON using json.load()        │  │
                │  └──────────────────────────────────────┘  │
                │                    │                        │
                │  ┌─────────────────▼─────────────────────┐ │
                │  │         TRANSFORM Phase               │ │
                │  ├───────────────────────────────────────┤ │
                │  │ Customer:                             │ │
                │  │   - Combine first + last name         │ │
                │  │   - Standardize country (UPPER)       │ │
                │  │   - Remove email (8→6 cols)           │ │
                │  │                                       │ │
                │  │ Product:                              │ │
                │  │   - Calculate profit margin           │ │
                │  │   - Standardize category (UPPER)      │ │
                │  │   - Remove cost_price (9→7 cols)      │ │
                │  │                                       │ │
                │  │ Sales Fact:                           │ │
                │  │   - Create date_id (YYYYMMDD)         │ │
                │  │   - Calculate discount_amount         │ │
                │  │   - Calculate total_amount            │ │
                │  │   - Modify columns (8→9)              │ │
                │  │                                       │ │
                │  │ Date Dimension:                       │ │
                │  │   - Generate full year dates          │ │
                │  │   - Extract temporal attributes       │ │
                │  └───────────────────────────────────────┘ │
                │                    │                        │
                │  ┌─────────────────▼─────────────────────┐ │
                │  │          LOAD Phase                   │ │
                │  ├───────────────────────────────────────┤ │
                │  │ • Create target database              │ │
                │  │ • Load dimension tables               │ │
                │  │ • Load fact table                     │ │
                │  │ • Validate referential integrity      │ │
                │  └───────────────────────────────────────┘ │
                │                    │                        │
                └────────────────────┼────────────────────────┘
                                     │
        ┌────────────────────────────▼────────────────────────────┐
        │            TARGET DATA MART (OLAP)                      │
        │              ecommerce_datamart                         │
        ├─────────────────────────────────────────────────────────┤
        │                                                         │
        │              STAR SCHEMA DESIGN                         │
        │                                                         │
        │                   ┌─────────────┐                       │
        │                   │  dim_date   │                       │
        │                   ├─────────────┤                       │
        │                   │*date_id (PK)│                       │
        │                   │ full_date   │                       │
        │                   │ day, month  │                       │
        │                   │ quarter,year│                       │
        │                   │ day_name    │                       │
        │                   │ is_weekend  │                       │
        │                   └──────┬──────┘                       │
        │                          │                              │
        │  ┌──────────────┐        │        ┌──────────────┐     │
        │  │ dim_customer │        │        │ dim_product  │     │
        │  ├──────────────┤        │        ├──────────────┤     │
        │  │*customer_id  │        │        │*product_id   │     │
        │  │ customer_name│        │        │ product_name │     │
        │  │ country      │        │        │ category     │     │
        │  │ city         │        │        │ subcategory  │     │
        │  │ segment      │        │        │ brand        │     │
        │  │ reg_date     │        │        │ retail_price │     │
        │  └──────┬───────┘        │        │ profit_margin│     │
        │         │                │        └──────┬───────┘     │
        │         │                │               │             │
        │         │         ┌──────▼──────┐        │             │
        │         └─────────┤ fact_sales  ├────────┘             │
        │                   ├─────────────┤                      │
        │                   │transaction_id                      │
        │                   │#date_id (FK)│                      │
        │                   │#customer_id │                      │
        │                   │#product_id  │                      │
        │                   │ quantity    │                      │
        │                   │ unit_price  │                      │
        │                   │ discount_amt│                      │
        │                   │ shipping_cost                      │
        │                   │ total_amount│                      │
        │                   └─────────────┘                      │
        │                                                         │
        └─────────────────────────────────────────────────────────┘
                                     │
        ┌────────────────────────────▼────────────────────────────┐
        │              ANALYTICAL QUERIES                         │
        ├─────────────────────────────────────────────────────────┤
        │                                                         │
        │  Query 1: Sales by Customer Segment & Month            │
        │    • JOINs: fact_sales ⟕ dim_customer ⟕ dim_date      │
        │    • Aggregates: COUNT, SUM, AVG                       │
        │    • Groups: segment, month, year                      │
        │                                                         │
        │  Query 2: Product Performance                          │
        │    • JOINs: fact_sales ⟕ dim_product                   │
        │    • Aggregates: COUNT, SUM, AVG                       │
        │    • Groups: product, category, brand                  │
        │                                                         │
        │  Query 3: Customer Behavior by Country                 │
        │    • JOINs: fact_sales ⟕ dim_customer                  │
        │    • Aggregates: COUNT, AVG, SUM                       │
        │    • Groups: country, segment                          │
        │                                                         │
        │  Query 4: Time-based Sales Trends                      │
        │    • JOINs: fact_sales ⟕ dim_date ⟕ dim_customer      │
        │    • Aggregates: COUNT, SUM, AVG                       │
        │    • Groups: quarter, month, day_type                  │
        │                                                         │
        └─────────────────────────────────────────────────────────┘
```

## Data Flow Summary

### Phase 1: EXTRACT
- **MySQL**: Execute SELECT query → pandas DataFrame
- **CSV**: Read file → pandas DataFrame
- **JSON**: Parse file → pandas DataFrame

### Phase 2: TRANSFORM
- **Data Cleansing**: Remove nulls, standardize formats
- **Data Integration**: Combine multiple sources
- **Column Modification**: Add/remove/calculate columns
- **Business Rules**: Apply transformations per requirements

### Phase 3: LOAD
- **Create Schema**: Design star schema
- **Load Dimensions**: Insert dimension tables first
- **Load Facts**: Insert fact table with foreign keys
- **Validate**: Check referential integrity

### Phase 4: ANALYZE
- **Complex Queries**: Multi-table JOINs
- **Aggregations**: SUM, COUNT, AVG
- **Grouping**: GROUP BY multiple dimensions
- **Business Insights**: Answer analytical questions

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Data Sources** | MySQL, CSV, JSON | Simulate heterogeneous sources |
| **ETL Engine** | Python 3.x | Pipeline orchestration |
| **Data Processing** | pandas | Data manipulation |
| **Database** | MySQL 8.0 | Data warehouse |
| **Connectivity** | SQLAlchemy, PyMySQL | Database access |
| **Development** | Jupyter Notebook | Interactive development |
| **Version Control** | Git/GitHub | Code management |

## Key Metrics

- **Data Volume**: 
  - 366 dates (full year)
  - 10 customers
  - 5 products
  - 20 transactions

- **Column Transformations**:
  - Customer: 8 → 6 columns (-25%)
  - Product: 9 → 7 columns (-22%)
  - Sales: 8 → 9 columns (+12.5%)

- **Data Sources**: 3 different types (relational, semi-structured, unstructured)
- **Joins**: Up to 3-way joins in queries
- **Aggregations**: Multiple (COUNT, SUM, AVG)

## Design Principles

1. **Separation of Concerns**: Source systems independent from data mart
2. **Star Schema**: Optimized for query performance
3. **Referential Integrity**: All foreign keys validated
4. **Idempotency**: Can re-run ETL without data duplication
5. **Scalability**: Design supports larger datasets

## Future Architecture Enhancements

```
Current: Single Server
┌─────────────┐
│   Local     │
│   MySQL     │
└─────────────┘

Future: Cloud-Based Distributed
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   AWS RDS   │────▶│  AWS Lambda │────▶│  Redshift   │
│  (Sources)  │     │ (ETL Jobs)  │     │ (Data Mart) │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                    ┌──────▼──────┐
                    │   Airflow   │
                    │ (Scheduler) │
                    └─────────────┘
```

---

**Legend:**
- `*` = Primary Key
- `#` = Foreign Key
- `⟕` = JOIN operation
- `→` = Data flow direction
