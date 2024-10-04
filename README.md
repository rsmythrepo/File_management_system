# File_management_system 

Short Project Introduction: Automated File Sorting Script
In many organizations, data is often ingested in various file formats. This disorganized collection of files can lead to inefficiencies in data management, retrieval, and analysis. For example, a research department may receive daily reports from multiple sources into their data lake (AWS S3 bucket), resulting in a cluttered directory that makes it difficult to locate specific files. This scenario can lead to wasted time and resources, negatively impacting productivity.

Objective
The objective of this project is to develop a Bash script (or that automates the sorting of ingested files into designated folders based on their file types. The script will analyze a specified directory, identify the different file types present, and move each file into its corresponding folder (e.g., CSV files into a "CSV" folder, JSON files into a "JSON" folder, etc.). Additionally, the script will provide an overview of the entire directory, including the total number of files sorted, the number of files of each type, and the size of each folder.

Key Features of the Script:
- File Type Identification: The script will determine the file type of each ingested file using file extensions.
- Directory Management: It will create folders for each file type if they do not already exist.
- File Sorting: The script will move files into their respective folders based on identified types.
- Directory Overview: At the end of execution, the script will display a summary of the entire directory, including

Execution:
The script can be run in the directory that needs to be sorted ./file_sorter.sh 
