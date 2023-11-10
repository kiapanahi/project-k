param (
    [string]$ProjectName = "kafka-cluster",
    [string]$Action
)

# Function to start the Kafka cluster, Schema Registry, and Kafka UI
function Start-Cluster {
    Write-Host ("Starting Zookeeper for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d zookeeper

    Write-Host ("Starting Kafka brokers for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d kafka1 kafka2 kafka3

    Write-Host ("Starting Schema Registry for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d schema-registry

    Write-Host ("Starting Kafka UI for {0}..." -f $ProjectName) -ForegroundColor Green
    docker-compose -p $ProjectName up -d kafka-ui

    Write-Host "Kafka cluster, Schema Registry, and Kafka UI started successfully." -ForegroundColor Green
}

# Function to stop the Kafka cluster, Schema Registry, and Kafka UI
function Stop-Cluster {
    Write-Host ("Stopping Kafka cluster, Schema Registry, and Kafka UI for {0}..." -f $ProjectName) -ForegroundColor Red
    docker-compose -p $ProjectName down
    Write-Host "Kafka cluster, Schema Registry, and Kafka UI stopped." -ForegroundColor Red
}

# Function to restart the Kafka cluster, Schema Registry, and Kafka UI
function Restart-Cluster {
    Write-Host ("Restarting Kafka cluster, Schema Registry, and Kafka UI for {0}..." -f $ProjectName) -ForegroundColor Red

    # Stopping the cluster
    Stop-Cluster

    # Removing persistent data volumes
    Write-Host ("Removing persistent data volumes for {0}..." -f $ProjectName) -ForegroundColor Red
    docker volume rm "${ProjectName}_kafka1", "${ProjectName}_kafka2", "${ProjectName}_kafka3", "${ProjectName}_schema-registry", "${ProjectName}_kafka-ui"
    docker volume rm "${ProjectName}_zookeeper"

    # Starting the cluster, Schema Registry, and Kafka UI
    Start-Cluster

    Write-Host "Kafka cluster, Schema Registry, and Kafka UI restarted successfully." -ForegroundColor Red
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
