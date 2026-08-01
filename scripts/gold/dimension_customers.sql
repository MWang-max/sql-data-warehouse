-- check for duplicates
SELECT cst_id, COUNT(*) FROM ( 
SELECT
    cst_id,
    cst_key
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date,
    ca.bdate,
    ca.gen,
    la.cntry
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid
)t
GROUP BY cst_id
HAVING COUNT(*) > 1

-- data integration on gender columns (master source: crm - correct if there is a mismatch)
SELECT DISTINCT 
    ci.cst_gndr,
    ca.gen,

    CASE WHEN cst_gndr != 'n/a' THEN cst_gndr
    ELSE COALESCE(ca.gen, 'n/a')
    END

FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid

CREATE VIEW gold.dim_customers AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
        cst_id AS customer_id,
        cst_key AS customer_number,
        cst_firstname AS first_name,
        cst_lastname AS last_name,
        la.cntry AS country,
        cst_marital_status AS marital_status,

        CASE WHEN cst_gndr != 'n/a' THEN cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
        END AS gender,
        
        ca.bdate AS birthdate,
        cst_create_date AS create_date
    FROM silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid

-- quality check

SELECT DISTINCT 
gender
FROM gold.dim_customers

SELECT
*
FROM gold.dim_customers

DROP VIEW IF EXISTS gold.dim_customers
