SELECT 
cst_key
FROM silver.crm_cust_info

-- quality check 
SELECT  -- customer id's
    REPLACE(cid, '-', '') AS cid
FROM bronze.erp_loc_a101 
WHERE REPLACE(cid, '-', '') 
NOT IN (SELECT 
cst_key
FROM silver.crm_cust_info)

SELECT DISTINCT
cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

SELECT DISTINCT -- check quality after cleaning
cntry AS old_cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

CREATE TABLE silver.erp_loc_a101(
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
)

-- insert after checking
INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
         WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101 

-- check silver 

SELECT DISTINCT
cntry
FROM silver.erp_loc_a101
ORDER BY cntry

SELECT * FROM silver.erp_loc_a101

DROP TABLE IF EXISTS silver.erp_loc_a101