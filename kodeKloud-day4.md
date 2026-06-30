# Your task is to grant executable permissions to the /tmp/xfusioncorp.sh script on App Server 1. Additionally, ensure that all users have the capability to execute it.
this lab was related to permissioning in linux.
i had used below command:
chmod 111 /tmp/xfusioncorp.sh 

# better to use below command 
chmod a+x /tmp/xfusioncorp.sh
a means all the users (user/owner u , group g, others o)
x means to only append the executable permission to the exe file.
# why ?
chmod 111 /tmp/xfusioncorp.sh  is altering the permision but a+r is just appending the permission with executable rights.

more info:

# chmod Symbolic Mode

The general syntax is:

```bash
chmod [who][operator][permissions] file
```

Example:

```bash
chmod u+x script.sh
```

- `u` → who
- `+` → operator
- `x` → permission

---

# 1. Who (Whose permissions?)

| Symbol | Meaning |
|--------|---------|
| `u` | User (Owner) |
| `g` | Group |
| `o` | Others |
| `a` | All (u + g + o) |

Examples:

```bash
chmod u+x file      # Add execute to owner
chmod g+w file      # Add write to group
chmod o-r file      # Remove read from others
chmod a+x file      # Add execute to everyone
chmod ug+r file     # Add read to owner and group
```

---

# 2. Operators

| Operator | Meaning |
|----------|---------|
| `+` | Add permission |
| `-` | Remove permission |
| `=` | Set exactly these permissions |

Examples:

### Add Permission

```bash
chmod u+x file
```

Before:

```text
-rw-r--r--
```

After:

```text
-rwxr--r--
```

---

### Remove Permission

```bash
chmod g-w file
```

Before:

```text
-rwxrwxr-x
```

After:

```text
-rwxr-xr-x
```

---

### Set Exact Permission

```bash
chmod o=r file
```

Others will have only:

```text
r--
```

---

# 3. Permissions

| Symbol | Meaning |
|--------|---------|
| `r` | Read |
| `w` | Write |
| `x` | Execute |
| `X` | Execute only if the file is already executable or is a directory |
| `s` | Set UID / Set GID |
| `t` | Sticky Bit |

> **Note:** Most of the time you'll only use `r`, `w`, and `x`.

---

# Common Examples

### Give execute permission to everyone

```bash
chmod a+x file
```

---

### Remove execute permission from everyone

```bash
chmod a-x file
```

---

### Give owner read and write

```bash
chmod u+rw file
```

---

### Remove write permission from group

```bash
chmod g-w file
```

---

### Others can only read

```bash
chmod o=r file
```

---

### Owner gets all permissions

```bash
chmod u=rwx file
```

---

### Group gets read and execute

```bash
chmod g=rx file
```

---

# Multiple Operations in One Command

You can combine multiple operations using commas.

```bash
chmod u+x,g-w,o=r file
```

Meaning:

- Owner → Add execute
- Group → Remove write
- Others → Only read

---

# Copy Permissions

You can copy permissions from one class to another.

### Copy owner's permissions to group

```bash
chmod g=u file
```

Example:

Before:

```text
-rwxr--r--
```

After:

```text
-rwxrwxr--
```

---

### Copy group's permissions to others

```bash
chmod o=g file
```

---

# Numeric vs Symbolic

| Numeric | Symbolic Equivalent | Meaning |
|----------|---------------------|---------|
| `755` | `u=rwx,g=rx,o=rx` | Standard executable |
| `644` | `u=rw,g=r,o=r` | Standard file |
| `700` | `u=rwx,go=` | Private executable |
| `600` | `u=rw,go=` | Private file |
| `777` | `a=rwx` | Everyone has all permissions |

---

# When to Use Which?

### Use Symbolic Mode

Use symbolic mode when you want to **modify only specific permissions** without affecting the others.

Examples:

```bash
chmod a+x file
chmod g-w file
chmod u+r file
```

---

### Use Numeric Mode

Use numeric mode when you want to **set the complete permission layout**.

Examples:

```bash
chmod 755 file
chmod 644 file
chmod 700 file
```

---

# Quick Cheat Sheet

| Task | Command |
|------|---------|
| Add execute for everyone | `chmod a+x file` |
| Remove execute for everyone | `chmod a-x file` |
| Add write for owner | `chmod u+w file` |
| Remove write from group | `chmod g-w file` |
| Others read only | `chmod o=r file` |
| Owner full access | `chmod u=rwx file` |
| Standard executable | `chmod 755 file` |
| Standard text file | `chmod 644 file` |
| Private executable | `chmod 700 file` |
| Private file | `chmod 600 file` |
