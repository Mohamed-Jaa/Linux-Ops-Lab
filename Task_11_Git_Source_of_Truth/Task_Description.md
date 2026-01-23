# Task 11: Git Integration - Source of Truth

## 1. Context & Scenario
Following the recent "Black Box" incident, where unauthorized and random manual edits led to system instability, a strict new policy has been enforced: **Direct editing of configuration files on the production server is strictly prohibited.**

The use of text editors (like `nano` or `vim`) directly on the server is now banned for infrastructure changes. The server must reflect exactly what is stored in the code repository, ensuring no "hidden" changes exist.

## 2. Task Subject
The focus of this task is to implement a **Git-based Deployment Workflow**. This shifts the infrastructure management model from "Manual Server Administration" to "Infrastructure as Code (IaC)," where the GitHub repository acts as the **Single Source of Truth** for all configurations.

## 3. Core Objectives
* **Enforce Version Control:** Ensure every change to `docker-compose.yml` or `nginx.conf` is tracked, documented, and reversible.
* **Audit Trail:** Establish a clear history of *who* changed *what* and *when*.
* **Secure Synchronization:** Implement a mechanism to safely pull updates from GitHub to the Production Server without exposing private credentials (using Deploy Keys).
* **Disaster Recovery:** Enable instant rollback to previous stable versions by simply checking out an older commit.
