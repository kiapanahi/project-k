param (
    [string]$ProjectName = "kafka-cluster",
    [string]$Action
)

# Function to start the Kafka cluster
function Start-Cluster {
    Write-Host ("Starting Zookeeper for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d zookeeper

    Write-Host ("Starting Kafka brokers for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d kafka1 kafka2 kafka3

    Write-Host ("Starting Kafka UI for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d kafka-ui

    Write-Host "Kafka cluster started successfully." -ForegroundColor Green
}

# Function to stop the Kafka cluster
function Stop-Cluster {
    Write-Host ("Stopping Kafka cluster for {0}..." -f $ProjectName) -ForegroundColor Red
    docker-compose -p $ProjectName down
    Write-Host "Kafka cluster stopped." -ForegroundColor Red
}

# Function to restart the Kafka cluster
function Restart-Cluster {
    Write-Host ("Restarting Kafka cluster for {0}..." -f $ProjectName) -ForegroundColor Red

    # Stopping the cluster
    Stop-Cluster

    # Removing persistent data volumes
    Write-Host ("Removing persistent data volumes for {0}..." -f $ProjectName) -ForegroundColor Red
    docker volume rm "${ProjectName}_kafka1", "${ProjectName}_kafka2", "${ProjectName}_kafka3"
    docker volume rm "${ProjectName}_zookeeper"
    docker volume rm "${ProjectName}_kafka-ui"

    # Starting the cluster
    Start-Cluster

    Write-Host "Kafka cluster restarted successfully." -ForegroundColor Red
}

# Parse the command-line arguments
switch ($Action) {
    "start" { Start-Cluster }
    "stop" { Stop-Cluster }
    "restart" { Restart-Cluster }
    default {
        Write-Host ("Usage: .\manage-cluster.ps1 -ProjectName <project-name> -Action {start|stop|restart}") -ForegroundColor Red
        exit 1
    }
}
