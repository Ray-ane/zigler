import pyodbc
import pandas as pd

# 1) your DataFrame
df = pd.DataFrame({
    "col1": [1, 2, 3],
    "col2": ["A", "B", "C"],
    "col3": pd.to_datetime(["2025-05-01"]*3)
})

# 2) pull out rows as a list of tuples
#    df.values.tolist() gives you [[1,'A',Timestamp], [2,'B',...], ...]
rows = df.values.tolist()

# 3) build your parameter list: one tuple per proc‐call, with table_name first
table_name = "dbo.MyTargetTable"
params = [(table_name, *row) for row in rows]
#    e.g. [("dbo.MyTargetTable", 1, "A", Timestamp), ...]


# 4) open your connection & get a cursor
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=your_server;DATABASE=your_db;UID=your_user;PWD=your_pass;"
)
cursor = conn.cursor()

# 5) define the Exec‐string once
sql = """
EXEC dbo.InsertDynamic
  @TargetTable = ?,
  @col1        = ?,
  @col2        = ?,
  @col3        = ?;
"""

# 6) batch‐execute
cursor.fast_executemany = True
cursor.executemany(sql, params)
conn.commit()
conn.close()










CREATE OR ALTER PROCEDURE dbo.InsertDynamic
  @TargetTable SYSNAME,      -- the table you want to hit
  @Id          INT,          
  @Name        NVARCHAR(100),
  @Created     DATETIME      
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @sql NVARCHAR(MAX)
    = N'INSERT INTO '
      + QUOTENAME(@TargetTable)
      + N' ([Id],[Name],[Created])'
      + N' VALUES (@Id,@Name,@Created);';

  EXEC sp_executesql
    @sql,
    N'@Id INT,@Name NVARCHAR(100),@Created DATETIME',
    @Id      = @Id,
    @Name    = @Name,
    @Created = @Created;
END
GO

