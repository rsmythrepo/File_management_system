# Automated File Sorting 

### Problem Statement 
In many organizations, data is often ingested in various file formats. This disorganized collection of files can lead to inefficiencies in data management, retrieval, and analysis. For example, a research department may receive daily reports from multiple sources into their data lake (AWS S3 bucket), resulting in a cluttered directory that makes it difficult to locate specific files. This scenario can lead to wasted time and resources, negatively impacting productivity.

### Objectives

Learning Objective: Bash Scripting, File Management, Scheduling and Automation, Regular Expressions and Pattern Matching, Directory Structure and Permissions, Logging and Monitoring, Understanding Environment Variables, Debugging and Optimization. 

Project Objective: To develop a Bash script that automates the sorting of ingested files into designated folders based on their file types. The script will analyze a specified directory, identify the different file types present, and move each file into its corresponding folder (e.g., CSV files into a "CSV" folder, JSON files into a "JSON" folder, etc.). Additionally, the script will provide an overview of the entire directory, including the total number of files sorted, the number of files of each type, and the size of each folder.

Key Features of the Script:
- File Type Identification: The script will determine the file type of each ingested file using file extensions.
- Directory Management: It will create folders for each file type if they do not already exist. 
- File Sorting: The script will move files into their respective folders based on identified types.
- Directory Overview: At the end of execution, the script will display a summary of the entire directory, including

 ### Execution:
Once set up ./file_sorter -setup has been completed, the script can be run from any directory by the current user.

Automation & Scheduling: 
Crontab can be used to schedule and automate running the script.

- sudo yum update
- sudo yum install cronie
- sudo systemctl start crond
- sudo systemctl enable crond
- crontab -e
- sudo systemctl status crond
