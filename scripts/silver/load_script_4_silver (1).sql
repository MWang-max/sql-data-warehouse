-- quality check on bronze layer
SELECT -- check unmatching data between bronze and silver
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
         ELSE cid
    END cid,
    bdate,
    gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
           ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

SELECT DISTINCT -- check unusual birthdays (more than 100 years - not fixed, or future dates)
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > '2026-01-01'

SELECT DISTINCT -- check genders
gen
FROM bronze.erp_cust_az12

SELECT DISTINCT -- normalize gender values
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12

CREATE TABLE silver.erp_cust_az12(
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
)

INSERT INTO silver.erp_cust_az12(
    cid,
    bdate,
    gen
)
SELECT 
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
         ELSE cid
    END cid,
    
    CASE WHEN bdate > '2026-01-01' THEN NULL -- convert future birthdays to NULL (does not change very old birthdays)
         ELSE bdate
    END bdate,

    CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12

-- quality check on silver layer

SELECT DISTINCT -- check unusual birthdays (future dates)
bdate
FROM silver.erp_cust_az12
WHERE bdate > '2026-01-01'

SELECT DISTINCT -- check genders
gen
FROM silver.erp_cust_az12