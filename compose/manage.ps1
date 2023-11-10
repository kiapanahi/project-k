param(
    [string]$action,
    [string]$projectName = "kafka-cluster"
)

# Function to display script usage
function Display-Usage {
    Write-Output "Usage: manage.ps1 -action [start|stop|restart] -projectName [kafka-cluster]"
}

# Check if the correct number of arguments is provided
if (-not $action) {
    Display-Usage
    exit 1
}

# Function to start the services
function Start-Services {
    Write-Host -ForegroundColor Green "Starting services..."
    docker-compose -p $projectName up -d
    Write-Host -ForegroundColor Green "Services started successfully."
}

# Function to stop the services
function Stop-Services {
    Write-Host -ForegroundColor Yellow "Stopping services..."
    docker-compose -p $projectName stop
    Write-Host -ForegroundColor Yellow "Services stopped successfully."
}

# Function to restart the services
function Restart-Services {
    Stop-Services

    # Remove project-related volumes and networks
    Write-Host -ForegroundColor Yellow "Removing project-related volumes and networks..."
    docker-compose -p $projectName down -v --remove-orphans

    Start-Services
}

# Perform action based on the specified parameter
switch ($action) {
    "start" {
        Start-Services
    }
    "stop" {
        Stop-Services
    }
    "restart" {
        Restart-Services
    }
    default {
        Display-Usage
        exit 1
    }
}

exit 0
