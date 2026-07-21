SET GLOBAL local_infile = true

TRUNCATE TABLE silver.crm_cust_info

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_crm/cust_info.csv' 
    INTO TABLE silver.crm_cust_info 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;  

SELECT * FROM silver.crm_cust_info

TRUNCATE TABLE silver.crm_prd_info

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_crm/prd_info.csv' 
    INTO TABLE silver.crm_prd_info 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

SELECT * FROM silver.crm_prd_info

TRUNCATE TABLE silver.crm_sales_details

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_crm/sales_details.csv' 
    INTO TABLE silver.crm_sales_details
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

SELECT * FROM silver.crm_sales_details

TRUNCATE TABLE silver.erp_cust_az12

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' 
    INTO TABLE silver.erp_cust_az12
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

SELECT * FROM silver.erp_cust_az12

TRUNCATE TABLE silver.erp_loc_a101

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
    INTO TABLE silver.erp_loc_a101
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

SELECT * FROM silver.erp_loc_a101

TRUNCATE TABLE silver.erp_px_cat_g1v2

LOAD DATA LOCAL INFILE '/Users/miltonwang/Downloads/Udemy SQL /sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
    INTO TABLE silver.erp_px_cat_g1v2
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

SELECT * FROM silver.erp_px_cat_g1v2
