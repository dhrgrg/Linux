# SELinux (Security-Enhanced Linux)
With SELinux, the web server process is "confined." 
Even if an attacker compromises the web server, they are tightly restricted to the specific directories 
and system calls defined by the SELinux policy, 
preventing them from spreading the attack to the rest of the machine.

# SELinux mode:
- enforcing - The default, secure mode. SELinux actively enforces policies, blocks unauthorized actions, and logs them.
- permissive - SELinux is "on" but does not block anything. It simply logs what would have been blocked. 
  This is heavily used by administrators for troubleshooting.
- disabled - SELinux is completely turned off. It provides no security protection and generates no logs.

getenforce - command displays - Displays the current operating mode.
setenforce 0 / setenforce 1 - Temporarily switches between Permissive (0) and Enforcing (1) modes.
eg: setenforce 0 - changes from enforcing => permissive but it is changed back to enforcing once machine is rebooted.

# what if we want to make a permanent change ?
/etc/selinux/config - The main configuration file used to set the default SELinux mode on boot.
change value to SELINUX=enforcing to SELINUX=disabled

# how to get the OS system details ?
cat /etc/os-release

# Task 1 - Install the required SELinux packages.
it is centos
sudo dnf install -y policycoreutils selinux-policy selinux-policy-targeted

# task 2 - Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.
for permanent change, we will need to make change in config file at /ect/selinux/config

# task 3 -  No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.


# more info from LLM:
# SELinux Explained in Simple Words

## What is SELinux?

Think of **SELinux** as a **strict security guard** that sits between
applications and your files.

Without SELinux, Linux asks:

> "Does this user have permission?"

With SELinux, Linux asks **two questions**:

1.  Does the user have permission?
2.  Should this application be allowed to do this at all?

Only if **both** answers are **Yes** is the action allowed.

------------------------------------------------------------------------

## Simple Analogy: A Hotel

### Without SELinux

A guest has a room key.

The receptionist checks:

> "Is this your room key?"

If yes, the guest enters.

This is like traditional Linux file permissions.

``` text
Guest
   │
Room Key ✔
   │
Enter Room
```

### With SELinux

Now there is an additional security guard.

The receptionist checks the room key.

The security guard also asks:

> "Are guests allowed into this area?"

Even if the key works, the guard can deny entry.

``` text
Guest
   │
Room Key ✔
   │
Security Guard
   │
Denied ❌
```

The security guard represents **SELinux**.

------------------------------------------------------------------------

## Real Linux Example

Suppose you have a web server (Apache).

### Without SELinux

``` text
Apache
   │
Reads a file
   │
Linux Permissions = Allow
   │
Success
```

If an attacker compromises Apache, they can access anything the Apache
user is allowed to access.

### With SELinux

``` text
Apache
   │
Reads /etc/shadow
   │
Linux Permissions = Allow
   │
SELinux Policy = Deny
   │
Access Denied ❌
```

Even if Linux permissions allow access, SELinux blocks it because a web
server should not read password files.

------------------------------------------------------------------------

## Why Do We Need SELinux?

Without SELinux:

``` text
Hacker
   │
Compromises Apache
   │
Reads sensitive files
   │
Steals data
```

With SELinux:

``` text
Hacker
   │
Compromises Apache
   │
Tries to read sensitive files
   │
SELinux blocks access
```

SELinux limits what a compromised application can do, reducing the
impact of an attack.

------------------------------------------------------------------------

## One-Line Definition

> **Linux permissions decide what a user can access. SELinux decides
> what a program is allowed to do, even if the user has permission.**

------------------------------------------------------------------------

## Easy Way to Remember

Imagine your office.

-   **Linux permissions** = Your employee ID card lets you enter the
    building.
-   **SELinux** = A security guard checks whether you're allowed into
    the server room.

Even with a valid ID card, the guard can still say:

> "You are not authorized to enter."

That's exactly what SELinux does for applications.

------------------------------------------------------------------------

## SELinux Modes

  -----------------------------------------------------------------------
  Mode                         Meaning
  ---------------------------- ------------------------------------------
  **Enforcing**                Checks policies and blocks violations
                               (most secure).

  **Permissive**               Checks policies and logs violations but
                               does not block them. Useful for testing.

  **Disabled**                 SELinux is turned off. No SELinux
                               protection is applied.
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## Key Takeaway

Think of SELinux as a **second layer of security**.

-   Linux permissions answer: **"Can this user access this file?"**
-   SELinux answers: **"Should this application be allowed to perform
    this action?"**

Only when **both** checks pass is access granted.


