#!/bin/bash

# TBK Development Environment Stop Script
# This script stops the development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

stop_services() {
    log_info "Stopping development services..."
    
    cd "$PROJECT_ROOT"
    
    # Stop services using docker-compose
    if command -v docker-compose &> /dev/null; then
        docker-compose -f docker-compose.dev.yml down
    else
        docker compose -f docker-compose.dev.yml down
    fi
    
    # Also stop individual containers if they're still running
    docker stop tbk-dev mysql-dev redis-dev nginx-dev 2>/dev/null || true
    
    log_success "Development services stopped"
}

cleanup_containers() {
    log_info "Cleaning up development containers..."
    
    # Remove containers
    docker rm tbk-dev mysql-dev redis-dev nginx-dev 2>/dev/null || true
    
    log_success "Development containers cleaned up"
}

cleanup_volumes() {
    log_info "Cleaning up development volumes..."
    
    # Remove named volumes
    docker volume rm jenkins-service_mysql_dev_data jenkins-service_redis_dev_data 2>/dev/null || true
    
    log_success "Development volumes cleaned up"
}

cleanup_images() {
    log_info "Cleaning up development images..."
    
    # Remove development images
    docker rmi $(docker images | grep "jenkins-service.*tbk-dev\|tbk-dev" | awk '{print $3}') 2>/dev/null || true
    
    log_success "Development images cleaned up"
}

show_status() {
    log_info "Checking remaining containers..."
    
    REMAINING=$(docker ps -a --filter "name=tbk-dev\|mysql-dev\|redis-dev\|nginx-dev" --format "{{.Names}}" | wc -l)
    
    if [[ $REMAINING -eq 0 ]]; then
        log_success "All development containers have been stopped and removed"
    else
        log_warning "Some containers may still exist:"
        docker ps -a --filter "name=tbk-dev\|mysql-dev\|redis-dev\|nginx-dev" --format "table {{.Names}}\t{{.Status}}"
    fi
}

# Main execution
main() {
    log_info "Stopping TBK Development Environment"
    echo "====================================="
    
    # Parse command line arguments
    CLEANUP_VOLUMES=false
    CLEANUP_IMAGES=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --cleanup-volumes)
                CLEANUP_VOLUMES=true
                shift
                ;;
            --cleanup-images)
                CLEANUP_IMAGES=true
                shift
                ;;
            --cleanup-all)
                CLEANUP_VOLUMES=true
                CLEANUP_IMAGES=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --cleanup-volumes    Remove development data volumes"
                echo "  --cleanup-images     Remove development Docker images"
                echo "  --cleanup-all        Remove volumes and images"
                echo "  --help              Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Execute stop steps
    stop_services
    cleanup_containers
    
    if [[ "$CLEANUP_VOLUMES" == "true" ]]; then
        cleanup_volumes
    fi
    
    if [[ "$CLEANUP_IMAGES" == "true" ]]; then
        cleanup_images
    fi
    
    show_status
    
    log_success "Development environment stopped successfully!"
}

# Run main function with all arguments
main "$@"