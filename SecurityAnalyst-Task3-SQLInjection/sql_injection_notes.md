# SQL Injection – Technical Notes

## 1. Objective

The objective of this task was to understand and demonstrate SQL Injection
(SQLi) using Damn Vulnerable Web Application (DVWA) in a controlled,
local laboratory environment.

The experiments focused on identifying vulnerable input handling,
observing unauthorized data retrieval, and comparing insecure SQL
queries with safer database access techniques.

## 2. Lab Environment

- Operating system: Fedora Linux
- Target application: Damn Vulnerable Web Application (DVWA)
- Container platform: Podman Compose
- Database: MariaDB
- Local address: http://127.0.0.1:4280
- Vulnerable module: SQL Injection
- Initial security level: Low
- Defensive comparison: Impossible

The application was accessible only through the local loopback interface.
All testing was performed in this authorized laboratory environment.

## 3. What Is SQL Injection?

SQL Injection is a web application vulnerability that occurs when
untrusted user input is incorporated into SQL statements without
appropriate parameterization.

An attacker may manipulate the intended SQL query to retrieve
unauthorized information, bypass application logic, or potentially
modify database contents, depending on the application's privileges.

## 4. Normal Application Behavior

Input:

    1

Result:

    First name: admin
    Surname: admin

The application returned the record associated with the requested
user ID.

## 5. SQL Injection – Boolean-Based Payloads

### Payload 1

    ' OR '1'='1

### Payload 2

    1' OR '1'='1

Both payloads caused DVWA at the Low security level to return
multiple user records instead of only the requested record.

The condition '1'='1' is always true. When injected into the
vulnerable SQL statement, it changes the query's filtering logic.

Observed result: five user records were returned.

## 6. SQL Injection – UNION-Based Data Extraction

Payload:

    1' UNION SELECT user, password FROM users#

The UNION operator combined the original query's result with
data retrieved from the users table.

The output exposed database usernames and password hashes.
These were password hashes, not plaintext passwords.

This demonstrated how SQL Injection can disclose information
that the application did not intend to display.

## 7. Database Information Disclosure

Payload:

    1' UNION SELECT database(), version()#

The test identified the database name and database server version.

Observed values:

- Database name: dvwa
- Database version: 10.11.19-MariaDB-ubu2204

This demonstrated that SQL Injection can also expose information
about the underlying database environment.

## 8. Root Cause

The vulnerable DVWA Low security implementation constructs
a SQL query by inserting user-controlled input directly into
the SQL statement.

Example of the vulnerable query:

    SELECT first_name, last_name FROM users WHERE user_id = '$id';

Because the input is treated as part of the SQL statement,
special characters and SQL expressions can change its meaning.

## 9. Defensive Comparison – Impossible Security Level

The DVWA Impossible security implementation includes
additional protections, including:

- Validation of numeric input
- Parameterized queries / prepared statements
- Bound query parameters
- Additional request validation

The SQL Injection test did not return the unauthorized user
records when tested at the Impossible security level.

Prepared statements separate SQL instructions from user-supplied
values, preventing the input from being interpreted as SQL code.

## 10. Recommended Prevention Measures

1. Use prepared statements and parameterized queries.
2. Validate input according to expected data types and formats.
3. Apply the principle of least privilege to database accounts.
4. Avoid exposing database errors and sensitive information.
5. Store passwords using appropriate password-hashing algorithms.
6. Perform regular security testing and code reviews.

Input validation is useful, but it is not a substitute for
parameterized queries.

## 11. Conclusion

The DVWA laboratory demonstrated how unsafe SQL query construction
can lead to unauthorized retrieval of user information and password
hashes.

The comparison between Low and Impossible security levels showed
the importance of input validation and parameterized database queries.

All tests were performed locally for educational purposes.
