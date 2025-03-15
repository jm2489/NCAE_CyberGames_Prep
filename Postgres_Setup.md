# Postgres Permission Setup
## 1. Login as Postgres User

```bash
sudo -iu postgres psql
```

- Create a new User
```bash
CREATE USER `user` WITH PASSWORD 'password';
```

- Get list of database
```bash
\l
```

- Quit
```bash
\q
```

## 2. Show the default SCHEMA
```bash
SHOW search_path;
```

```bash
 search_path 
--------------
 "$user", public
(1 row)
```

In this case public would be the schema for user

## 3. Grant access to DB
```bash
GRANT CONNECT ON DATABASE db TO bill_kaplan;
GRANT USAGE ON SCHEMA public TO bill_kaplan;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bill_kaplan;
```

## 4. Grant access to User Table
```bash
GRANT ALL PRIVILEGES ON TABLE users TO bill_kaplan;
```
