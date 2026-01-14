# Task 007: Securing SSH Access (Key-Based Authentication)
**Date:** 2026-01-14 
**Type:** Security Hardening
**Status:** Implemented ✅

## 1. The Context 
Following the security breach discovered in **BlackBox Challenge #01**, where an unauthorized user accessed the server via a password-based SSH attack, I decided to disable password authentication and move to a more secure method.

## 2. The Goal
* Eliminate the risk of "Brute Force" attacks.
* Implement **Asymmetric Encryption** for server access.
* Ensure that only my local machine (holding the Private Key) can access the `webadmin` account.

## 3. Implementation Steps 
1. Generate an RSA Key Pair (Public & Private).
2. Transfer the Public Key to the server.
3. Configure SSH Daemon (`sshd_config`) to reject passwords.
4. Test and Verify the connection.
