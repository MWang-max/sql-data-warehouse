/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database 'DataWarehouse'. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold' if they do not already exist.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it already exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
DROP DATABASE IF EXISTS DataWarehouse

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA IF NOT EXISTS bronze;
GO

CREATE SCHEMA IF NOT EXISTS silver;
GO

CREATE SCHEMA IF NOT EXISTS gold;
GO