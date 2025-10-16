AUCA | Course: Database 

Author: Serdar Urustemov
Platform: Ubuntu Linux + PostgreSQL + psql terminal

==================================

All labs are stored under /Labs/ as separate SQL scripts:

Database/
└── Labs/
    ├── lab01/
    ├── lab02/
    ...
    └── lab17/
    
=====================================

How to Run Labs:
psql -U postgres -d postgres -f Labs/lab09/lab9.sql


| №      | Topic                          | Description                                                                                   |
| ------ | ------------------------------ | --------------------------------------------------------------------------------------------- |
| **1**  | Introduction to SQL            | Basic SQL commands, table creation, data insertion, and simple SELECT queries.                |
| **2**  | Data Types and Constraints     | Using PostgreSQL data types, primary/foreign keys, and constraints (NOT NULL, UNIQUE, CHECK). |
| **3**  | Basic SELECT Queries           | Retrieving and filtering data using WHERE, ORDER BY, and LIMIT.                               |
| **4**  | Filtering and Sorting          | Using logical operators, BETWEEN, LIKE, ILIKE, IN, and combining filters.                     |
| **5**  | Aggregate Functions            | COUNT, SUM, AVG, MIN, MAX with GROUP BY and HAVING.                                           |
| **6**  | Subqueries and Nested SELECT   | Embedding queries within queries for conditional data extraction.                             |
| **7**  | Views and Indexes              | Creating SQL views and optimizing queries with indexes.                                       |
| **8**  | Foreign Keys & Relationships   | Establishing one-to-one, one-to-many, and many-to-many relationships.                         |
| **9**  | Database Design Basics         | ER modeling, normalization (1NF–3NF), and logical schema creation.                            |
| **10** | Viewing Database Structure     | Using `\dt`, `\d table_name`, and pgAdmin ERD for schema inspection.                          |
| **11** | Basic Data Operations          | INSERT, UPDATE, DELETE, and bulk data import via COPY and CSV.                                |
| **12** | Querying Data                  | SELECT with WHERE, LIKE, IN, EXISTS, CASE, and CTE (WITH) clauses.                            |
| **13** | Aggregate Functions (Advanced) | GROUP BY with multiple aggregates, STRING_AGG, ARRAY_AGG, HAVING.                             |
| **14** | Joining Tables                 | INNER, LEFT, RIGHT, FULL, CROSS joins and self joins.                                         |
| **15** | Advanced Querying              | Subqueries, CTEs, recursive queries, set operations, window functions, pivot/unpivot.         |
| **16** | Transactions & ACID            | BEGIN, COMMIT, ROLLBACK, SAVEPOINT, isolation levels, and error handling.                     |
| **17** | Data Import/Export & Backup    | COPY, pg_dump, pg_restore, WAL archiving, PITR, and data migration.                           |


=====================================================

Tools Used

PostgreSQL 13+

psql (command-line client)

pgAdmin 4

Ubuntu 20.04+ / Linux environment

Visual Studio Code / nano editor
