def to_py_datetime(ts):
    return ts.to_pydatetime() if pd.notnull(ts) else None

for col in date_cols:
    df[col] = df[col].apply(to_py_datetime