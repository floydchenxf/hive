DROP TABLE part;

-- data setup
CREATE TABLE part( 
    p_partkey INT,
    p_name STRING,
    p_mfgr STRING,
    p_brand STRING,
    p_type STRING,
    p_size INT,
    p_container STRING,
    p_retailprice DOUBLE,
    p_comment STRING
);

LOAD DATA LOCAL INPATH '../data/files/part_tiny.txt' overwrite into table part;

-- 1. testQueryLevelPartitionColsNotInSelect
select p_size,
sum(p_retailprice) as s1 over (rows between unbounded preceding and current row)
from part 
distribute by p_mfgr sort by p_name ;

-- 2. testWindowPartitionColsNotInSelect
select p_size,
sum(p_retailprice) as s1 over (distribute by p_mfgr sort by p_name rows between unbounded preceding and current row)
from part;

-- 3. testHavingColNotInSelect
select p_mfgr,
sum(p_retailprice) as s1 over (distribute by p_mfgr sort by p_name rows between unbounded preceding and current row)
from part 
having p_size > 5;
