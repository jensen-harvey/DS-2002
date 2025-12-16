# Quick Start Guide - DS-2002 Data Project 1

## Getting Started in 5 Minutes

### Step 1: Install Prerequisites (2 minutes)

```bash
# Install Python packages
pip install pandas pymysql sqlalchemy jupyter

# Verify MySQL is installed and running
mysql --version
```

### Step 2: Setup MySQL Database (1 minute)

Option A - Using MySQL Command Line:
```bash
mysql -u root -p < setup_database.sql
```

Option B - MySQL will be setup automatically by the notebook

### Step 3: Configure Database Credentials (30 seconds)

Edit the notebook (Cell #3) and update:
```python
DB_USER = 'your_mysql_username'      # Change this
DB_PASSWORD = 'your_mysql_password'  # Change this
DB_HOST = 'localhost'                # Usually localhost
```

### Step 4: Run the Notebook (1 minute)

```bash
jupyter notebook DS2002_Project1_ETL_Pipeline.ipynb
```

In Jupyter:
1. Click "Cell" → "Run All" (or press Shift+Enter on each cell)
2. Wait for all cells to execute (~30 seconds)
3. Review results and queries

### Step 5: Verify Success (30 seconds)

You should see:
- ✓ "Database connection established successfully!"
- ✓ "Customer source data created successfully!"
- ✓ "All dimension tables loaded successfully!"
- ✓ "All referential integrity checks passed!"

## What Gets Created

### Databases:
- `ecommerce_datamart` - Your analytical database
- `source_customer_db` - Source system (simulated)

### Tables in ecommerce_datamart:
- `dim_date` - 366 date records
- `dim_customer` - 10 customer records
- `dim_product` - 5 product records
- `fact_sales` - 20 sales transactions

### Files Created:
- `sales_transactions.csv` - Sample sales data
- `product_catalog.json` - Sample product catalog

## Troubleshooting

**"Access denied for user"**
- Check MySQL username and password
- Grant privileges: `GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';`

**"Can't connect to MySQL server"**
- Start MySQL: `sudo systemctl start mysql` (Linux)
- Or: `brew services start mysql` (Mac)

**"Module not found"**
- Reinstall packages: `pip install -r requirements.txt`

## Key Features to Demo

1. **Multiple Data Sources:**
   - MySQL database extraction (customers)
   - CSV file extraction (sales)
   - JSON file extraction (products)

2. **Data Transformations:**
   - Column reduction (8→6, 9→7)
   - Calculated fields (discounts, totals)
   - Data cleansing (uppercase, combined names)

3. **Analytical Queries:**
   - Sales by customer segment
   - Product performance
   - Geographic analysis
   - Time-based trends

## Next Steps

After successful run:
1. Review the 4 analytical query results
2. Check the data quality validation
3. Explore the summary statistics
4. Read through the documentation section
5. Push to GitHub!

## GitHub Submission

```bash
# Initialize repository
git init
git add .
git commit -m "Initial commit: DS-2002 Data Project 1"

# Create GitHub repo and push
git remote add origin https://github.com/yourusername/ds2002-project1.git
git branch -M main
git push -u origin main
```

## Project Structure

```
your-repo/
├── DS2002_Project1_ETL_Pipeline.ipynb  ← Main notebook
├── README.md                           ← Full documentation
├── requirements.txt                    ← Dependencies
├── setup_database.sql                  ← DB setup
├── PROJECT_CHECKLIST.md                ← Requirements verification
├── QUICK_START.md                      ← This file
└── .gitignore                          ← Security
```

## Success Criteria

Your project is complete when:
- ✅ All notebook cells run without errors
- ✅ All 4 queries return results
- ✅ Referential integrity checks pass
- ✅ Documentation is comprehensive
- ✅ Code is pushed to GitHub

**Estimated Total Time: 5-10 minutes**

Good luck! 🚀
