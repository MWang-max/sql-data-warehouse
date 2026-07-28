-- quality check on bronze layer
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT cst_id FROM silver.crm_cust_info)

SELECT -- check for mismatched dates
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT DISTINCT -- check for bad data
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL 
OR sls_quantity IS NULL 
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

/*
transform rules for bad data: 
- negative/zero/null sales values: multiply quantity * price 
- zero/null price: divide sales/quantity
- negative price: convert to positive
*/

SELECT DISTINCT -- replace bad data
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,

    CASE WHEN (sls_sales IS NULL 
    OR sls_sales <= 0
    OR sls_sales != sls_quantity * ABS(sls_price))
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    CASE WHEN (sls_price IS NULL 
    OR sls_price <= 0)
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details

CREATE TABLE silver.crm_sales_details_temp(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
)

INSERT INTO silver.crm_sales_details_temp(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_order_dt AS CHAR) AS DATE)
    END AS sls_order_dt,

    CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_ship_dt AS CHAR) AS DATE)
    END AS sls_ship_dt,

    CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
         ELSE CAST(CAST(sls_due_dt AS CHAR) AS DATE)
    END AS sls_due_dt,

    CASE WHEN (sls_sales IS NULL 
    OR sls_sales <= 0
    OR sls_sales != sls_quantity * ABS(sls_price))
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    CASE WHEN (sls_price IS NULL 
    OR sls_price <= 0)
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details

-- quality check on new table
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details_temp
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details_temp
WHERE sls_prd_key NOT IN (SELECT cst_id FROM silver.crm_cust_info)

SELECT -- check for mismatched dates
*
FROM silver.crm_sales_details_temp
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT DISTINCT -- check for bad data (still an issue here)
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details_temp
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL 
OR sls_quantity IS NULL 
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT -- fix
    CASE WHEN (sls_sales IS NULL 
    OR sls_sales <= 0
    OR sls_sales != sls_quantity * ABS(sls_price))
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales
FROM silver.crm_sales_details_temp

-- new table from fix
CREATE TABLE silver.crm_sales_details(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
)

INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,

    CASE WHEN (sls_sales IS NULL 
    OR sls_sales <= 0
    OR sls_sales != sls_quantity * ABS(sls_price))
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    CASE WHEN (sls_price IS NULL 
    OR sls_price <= 0)
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM silver.crm_sales_details_temp

-- 3rd quality check
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT cst_id FROM silver.crm_cust_info)

SELECT -- check for mismatched dates
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

SELECT DISTINCT -- check for bad data (still an issue here)
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL 
OR sls_quantity IS NULL 
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

SELECT * FROM silver.crm_sales_details

DROP TABLE IF EXISTS silver.crm_sales_details

DROP TABLE IF EXISTS silver.crm_sales_details_temp