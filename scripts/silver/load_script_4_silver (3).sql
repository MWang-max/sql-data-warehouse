SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2

-- check quality

SELECT -- check unwanted spaces in strings
*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)

SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)

SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance)

SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2

-- no transformations - insert directly, no checks needed afterwards

CREATE TABLE silver.erp_px_cat_g1v2(
    id NVARCHAR(50), 
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
)

INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
SELECT
*
FROM bronze.erp_px_cat_g1v2

SELECT 
*
FROM silver.erp_px_cat_g1v2

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2