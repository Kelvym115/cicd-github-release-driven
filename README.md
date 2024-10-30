# GitHub Release-Driven CI/CD for Private Repos

## Overview

This script provides a basic automated CI/CD system that fetches releases from a private GitHub repository based on tag nomenclature. It simplifies the deployment process by automating the download, extraction, and version management of your applications. This system allows users to streamline their deployment workflows, ensuring that they can quickly and efficiently update their applications based on the latest releases.

## Features

- **Automated Version Checking**: The script checks for the latest release in the specified GitHub repository based on tag nomenclature.
- **Customizable Tag Management**: Users can easily modify the target version (e.g., alpha, beta, prod) to suit their deployment strategy.
- **Download and Extraction**: Automatically downloads the release asset as a ZIP file and extracts it to a specified directory.
- **Simple Integration**: Easily integrate into existing CI/CD pipelines by modifying the script to fit your specific needs.
- **Error Handling**: Includes checks for various stages to ensure smooth operation and handle errors effectively.

## Installation

1. **Prerequisites**: Ensure you have `curl`, `wget`, `unzip`, and `jq` installed on your system. You can install these on Debian-based systems using the following command:

   ```bash
   sudo apt update
   sudo apt install -y curl wget unzip jq
   ```
   
2. **Clone the Repository**: Clone this repository to your local machine.

   ```bash
   git clone <your-repo-url>
   cd <your-repo-directory>
   ```
3. **Configure the Script:**: Open the script and modify the following variables to fit your setup:
   - `GITHUB_REPO`: Set this to your private repository in the format `owner/repo-name`.
   - `DOWNLOAD_DIR`: Specify the directory where you want the release files to be downloaded.
   - `GITHUB_TOKEN`: Add your personal GitHub access token that has permissions to access the private repository.
   - `TARGET_VERSION`: Specify the target release nomenclature. Use `beta` for `beta-v1.0.0` tag nomenclature as example.
  
## How It Works

### Configuration
The script begins by defining the necessary configurations, including:
- The GitHub repository
- The download directory
- The target version tag (alpha, beta, prod)

### Current Version Check
It reads the current version of the application from a designated file in the download directory.

### Fetch Latest Release
Using GitHub's API, the script fetches the latest release that matches the specified target version.

### Asset Management
- If a new version is detected, the script retrieves the asset ID corresponding to the release.
- Downloads the asset as a ZIP file and extracts its contents.
- The extracted files are available in the specified download directory.

### Post-Processing
You can implement additional deployment logic in the script after the extraction step, depending on your requirements.

### Error Handling
The script includes checks for various stages, such as version existence and successful downloads, to minimize failures.

## Customization
This script is designed to be easily adaptable for various CI/CD implementations. Users can modify it according to their needs, including:

- **Changing the Version Tags**: Adjust the `TARGET_VERSION` variable to fit your release strategy (e.g., using different tag formats).
- **Adding Deployment Logic**: Insert additional commands after the extraction to deploy the new version to your production or staging environment.
- **Integrating with Other Tools**: Connect this script to your CI/CD tools (like Jenkins, GitLab CI/CD, etc.) for seamless automation.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
