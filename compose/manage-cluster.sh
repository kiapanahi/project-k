#!/bin/bash

# Script to manage a Kafka cluster with Confluent Schema Registry and Kafka UI

# Check if the project name argument is provided, default to "kafka-cluster"
PROJECT_NAME=${1:-"kafka-cluster"}

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to start the Kafka cluster, Schema Registry, and Kafka UI
start_cluster() {
    echo -e "${GREEN}Starting Zookeeper for $PROJECT_NAME...${NC}"
    docker-compose -p $PROJECT_NAME up -d zookeeper

    echo -e "${GREEN}Starting Kafka brokers for $PROJECT_NAME...${NC}"
    docker-compose -p $PROJECT_NAME up -d kafka1 kafka2 kafka3

    echo -e "${GREEN}Starting Schema Registry for $PROJECT_NAME...${NC}"
    docker-compose -p $PROJECT_NAME up -d schema-registry

    echo -e "${GREEN}Starting Kafka UI for $PROJECT_NAME...${NC}"
    docker-compose -p $PROJECT_NAME up -d kafka-ui

    echo -e "${GREEN}Kafka cluster, Schema Registry, and Kafka UI started successfully.${NC}"
}

# Function to stop the Kafka cluster, Schema Registry, and Kafka UI
stop_cluster() {
    echo -e "${RED}Stopping Kafka cluster, Schema Registry, and Kafka UI for $PROJECT_NAME...${NC}"
    docker-compose -p $PROJECT_NAME down
    echo -e "${RED}Kafka cluster, Schema Registry, and Kafka UI stopped.${NC}"
}

# Function to restart the Kafka cluster, Schema Registry, and Kafka UI
restart_cluster() {
    echo -e "${RED}Restarting Kafka cluster, Schema Registry, and Kafka UI for $PROJECT_NAME...${NC}"

    # Stopping the cluster
    stop_cluster

    # Removing persistent data volumes
    echo -e "${RED}Removing persistent data volumes for $PROJECT_NAME...${NC}"
    docker volume rm ${PROJECT_NAME}_kafka1 ${PROJECT_NAME}_kafka2 ${PROJECT_NAME}_kafka3 ${PROJECT_NAME}_schema-registry ${PROJECT_NAME}_kafka-ui
    docker volume rm ${PROJECT_NAME}_zookeeper

    # Starting the cluster, Schema Registry, and Kafka UI
    start_cluster

    echo -e "${RED}Kafka cluster, Schema Registry, and Kafka UI restarted successfully.${NC}"
}

# Parse the command-line arguments
case "$2" in
    "start")
        start_cluster
        ;;
    "stop")
        stop_cluster
        ;;
    "restart")
        restart_cluster
        ;;
    *)
        echo -e "${RED}Usage: $0 <project-name> {start|stop|restart}${NC}"
        exit 1
        ;;
esac
