# Task 3 – SQL Injection (DVWA)

## Objective

The objective of this task was to understand and demonstrate SQL Injection (SQLi) in a controlled, local laboratory environment using Damn Vulnerable Web Application (DVWA).

The task included testing vulnerable SQL queries, observing unauthorized information disclosure, and comparing insecure and secure database query implementations.

## Lab Environment

- **Operating System:** Fedora Linux
- **Application:** Damn Vulnerable Web Application (DVWA)
- **Container Platform:** Podman Compose
- **Database:** MariaDB
- **Local URL:** `http://127.0.0.1:4280`
- **DVWA Security Levels:** Low and Impossible

All experiments were performed locally in an authorized educational environment.

## SQL Injection Testing

### 1. Normal Query

Input: `1`

The application returned the expected admin user record.

### 2. Boolean-Based SQL Injection

The following payloads were tested at the Low security level:

```sql
' OR '1'='1
```

```sql
1' OR '1'='1
```

Both payloads returned five user records, demonstrating that user-controlled input could manipulate the SQL query.

### 3. UNION-Based Data Extraction

```sql
1' UNION SELECT user, password FROM users#
```

This payload exposed usernames and password hashes from the DVWA database.

### 4. Database Information Disclosure

```sql
1' UNION SELECT database(), version()#
```

Observed results:

- **Database:** `dvwa`
- **Database Version:** `10.11.19-MariaDB-ubu2204`

## Vulnerability Analysis

The DVWA Low security implementation directly incorporates user input into an SQL statement:

```sql
SELECT first_name, last_name FROM users WHERE user_id = '$id';
```

This allows malicious input to alter the intended SQL query.

At the Impossible security level, DVWA uses additional validation and prepared statements with bound parameters. The same SQL Injection approach did not return unauthorized user records.

## Prevention Measures

- Use prepared statements and parameterized queries.
- Validate user input.
- Apply least-privilege database permissions.
- Avoid exposing sensitive database information.
- Use appropriate password-hashing algorithms.
- Perform regular security testing and code reviews.

## Screenshots

| Screenshot | Description |
|---|---|
| [01-dvwa-home.png](screenshots/01-dvwa-home.png) | DVWA running locally |
| [02-low-security.png](screenshots/02-low-security.png) | Security level set to Low |
| [03-normal-query.png](screenshots/03-normal-query.png) | Normal query using ID 1 |
| [04-first-sql-injection.png](screenshots/04-first-sql-injection.png) | First Boolean-based SQL Injection |
| [05-second-sql-injection.png](screenshots/05-second-sql-injection.png) | Second Boolean-based SQL Injection |
| [06-union-password-hashes.png](screenshots/06-union-password-hashes.png) | UNION-based extraction of usernames and password hashes |
| [07-database-information.png](screenshots/07-database-information.png) | Database name and MariaDB version disclosure |
| [08-vulnerable-low-source-code.png](screenshots/08-vulnerable-low-source-code.png) | Vulnerable PHP source code |
| [09-secure-impossible-source-code.png](screenshots/09-secure-impossible-source-code.png) | Defensive PHP source code |
| [10-impossible-injection-test.png](screenshots/10-impossible-injection-test.png) | SQL Injection test at Impossible security level |

## Technical Notes

Detailed explanations of the payloads, observed results, root cause, and prevention methods are available in [sql_injection_notes.md](sql_injection_notes.md).

## Conclusion

This task demonstrated how SQL Injection can expose unauthorized database information when user input is incorporated directly into SQL queries.

The comparison between Low and Impossible security levels highlighted the importance of prepared statements, parameterized queries, and input validation.

**Disclaimer:** All testing was performed in a local, intentionally vulnerable laboratory environment for educational purposes.
