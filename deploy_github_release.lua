#!/usr/bin/env lua

-- Script Author: Kelvym Campos
-- GitHub: https://github.com/Kelvym115
-- Date: 30/10/2024
-- License: MIT License

-- Configuration
local GITHUB_REPO = "owner/repo-name"              -- repository in the format "owner/repo"
local DOWNLOAD_DIR = "/path/to/download/dir"       -- generic path where the version will be downloaded
local GITHUB_TOKEN = "YOUR_GITHUB_TOKEN"           -- add your personal GitHub access token
local GITHUB_API = "https://api.github.com"
local TARGET_VERSION = "beta"                       -- Define the target version

-- Helper functions
local function http_request(url, token)
    local http = require("socket.http")
    http.TIMEOUT = 10
    local response, status = http.request{
        url = url,
        headers = {
            Authorization = "token " .. token,
            ["Accept"] = "application/vnd.github.v3.raw"
        }
    }
    return response, status
end

local function get_latest_version()
    local url = string.format("%s/repos/%s/releases", GITHUB_API, GITHUB_REPO)
    local response, status = http_request(url, GITHUB_TOKEN)

    if status ~= 200 then
        error("Failed to fetch releases: " .. tostring(status))
    end

    for line in response:gmatch("[^\r\n]+") do
        if line:find(TARGET_VERSION .. "-v[%d]+%.[%d]+%.[%d]+") then
            return line:match('"tag_name": "(.*)"')
        end
    end
    return nil
end

local function download_asset(asset_id)
    local url = string.format("%s/repos/%s/releases/assets/%s", GITHUB_API, GITHUB_REPO, asset_id)
    local response, status = http_request(url, GITHUB_TOKEN)

    if status ~= 200 then
        error("Failed to download asset: " .. tostring(status))
    end

    local file = io.open(string.format("%s/%s.zip", DOWNLOAD_DIR, LATEST_VERSION), "wb")
    file:write(response)
    file:close()
end

local function extract_zip(zip_file, output_dir)
    local lzip = require("lzip")
    lzip.extract(zip_file, output_dir)
end

-- Main logic
local CURRENT_VERSION_FILE = DOWNLOAD_DIR .. "/current_version.txt"
local current_version = io.open(CURRENT_VERSION_FILE):read("*a"):gsub("%s+", "") or ""

-- Get the latest version available on GitHub
local LATEST_VERSION = get_latest_version()

-- Check if a new version was found
if not LATEST_VERSION then
    print("No new version found for " .. TARGET_VERSION .. ".")
    os.exit(1)
end

-- Check if the latest version is different from the current version
if LATEST_VERSION ~= current_version then
    print("New version found: " .. LATEST_VERSION)

    -- Download the asset (You would need to fetch the asset ID similar to the original)
    local asset_id = "YOUR_ASSET_ID_HERE"  -- You should implement logic to fetch this from the release metadata
    download_asset(asset_id)
    print("Download of version " .. LATEST_VERSION .. " completed.")

    -- Extract the ZIP file
    extract_zip(string.format("%s/%s.zip", DOWNLOAD_DIR, LATEST_VERSION), DOWNLOAD_DIR)
    print("Extraction of the new version completed.")

    -- Update the current version record
    local version_file = io.open(CURRENT_VERSION_FILE, "w")
    version_file:write(LATEST_VERSION)
    version_file:close()

    -- Add here your deploy logic...
else
    print("No new version found.")
end
