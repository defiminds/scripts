#!/bin/bash

# Function to install Surge
function install_surge() {
  # Install surge via npm
  npm install --global surge

  # Display Surge version
  echo ""
  echo "Surge $(surge --version) has been installed."
}

# Function to create custom folder
function create_folder() {
  read -p "Do you have an existing project to deploy? (y/n): " choice
  echo ""
  case $choice in
    y|Y)
      read -p "Enter the path to the project folder: " project_path
      if [ ! -d "$project_path" ]; then
        echo "The project folder does not exist."
        echo ""
        create_folder
      else
        echo "Using the existing project at $project_path."
        echo ""
        run_surge "$project_path"
      fi
      ;;
    n|N)
      read -p "Enter the path to create the project folder: " project_path
      mkdir -p "$project_path"
      echo "The project folder has been created at $project_path."
      echo ""
      run_surge "$project_path"
      ;;
    *)
      echo "Invalid choice. Please enter y/n."
      echo ""
      create_folder
      ;;
  esac
}

# Function to run Surge
function run_surge() {
  project_path=$1
  cd "$project_path"
  surge
}

# Check if npm is installed
if ! [ -x "$(command -v npm)" ]; then
  echo "npm is not installed. Please install npm and try again."
  exit 1
fi

# Check if Surge is installed
if ! [ -x "$(command -v surge)" ]; then
  echo "Surge is not installed. Would you like to install it now? (y/n)"
  read choice
  echo ""
  case $choice in
    y|Y)
      install_surge
      ;;
    n|N)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter y/n."
      exit 1
      ;;
  esac
fi

cd $project_path
# Create custom folder and deploy project with Surge
create_folder
