# 🧹 Automated Directory Cleanup Script (Fish Shell)

An automated file management and directory cleanup tool written in **Fish shell**. This script identifies and manages inactive or stale files based on user-defined parameters such as inactivity period, directory recursion, explicit exclusions, and sorting order. It includes built-in safeguards like interactive confirmations and a "dry-run" mode to prevent accidental data loss.

---

## 🎓 Context
This project was developed as an academic assignment for the **Operating Systems** course at the **Aristotle University of Thessaloniki (AUTh) / Αριστοτέλειο Πανεπιστήμιο Θεσσαλονίκης** in 2023.

---

## 🚀 Features

* **Inactivity Tracking:** Calculates file age based on the last access timestamp (`stat -c %X`) and isolates files exceeding the specified inactive threshold.
* **Recursive & Non-Recursive Scanning:** Supports deep directory tree traversal (`find $dir/**`) or shallow scanning limited to the immediate directory root (`-maxdepth 1`).
* **Robust File Exclusion:** Parses a space-separated list of filenames or directories to safeguard them from being swept during the cleanup.
* **Size-Based Sorting:** Outputs a detailed view of targeted files sorted by size in either ascending or descending order.
* **Safety Mechanisms:** * **Dry-Run Mode:** Previews what actions would be taken without executing any permanent file deletions.
  * **Interactive Confirmation:** Optional prompts requiring explicit user approval (`y/n`) prior to purging data.

---

## 🛠️ Architecture & Parameters

The script defines a core `cleanup` function that accepts 7 sequential arguments:

```fish
cleanup <target_directory> <days_inactive> <recursive> <dry_run> <excluded_files_dirs> <sort_type> <confirmation>
