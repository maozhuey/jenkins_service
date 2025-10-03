#!/bin/bash

# TBK Development Environment Deployment Script
# This script automates the deployment of the development environment

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
DEV_PORT=${DEV_PORT:-3001}
MYSQL_PORT=${MYSQL_PORT:-3307}
REDIS_PORT=${REDIS_PORT:-6380}

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

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if Docker is installed and running
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    # Check if docker-compose is available
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

cleanup_existing() {
    log_info "Cleaning up existing development containers..."
    
    # Stop and remove existing containers
    docker stop tbk-dev mysql-dev redis-dev nginx-dev 2>/dev/null || true
    docker rm tbk-dev mysql-dev redis-dev nginx-dev 2>/dev/null || true
    
    # Remove development images if requested
    if [[ "$1" == "--clean-images" ]]; then
        log_info "Removing development Docker images..."
        docker rmi $(docker images | grep "tbk-dev" | awk '{print $3}') 2>/dev/null || true
    fi
    
    log_success "Cleanup completed"
}

setup_environment() {
    log_info "Setting up development environment..."
    
    cd "$PROJECT_ROOT"
    
    # Create .env.dev if it doesn't exist
    if [[ ! -f ".env.dev" ]]; then
        log_info "Creating .env.dev file..."
        cat > .env.dev << EOF
# Development Environment Configuration
NODE_ENV=development
DEV_PORT=${DEV_PORT}
MYSQL_PORT=${MYSQL_PORT}
REDIS_PORT=${REDIS_PORT}

# Database Configuration
DB_HOST=mysql-dev
DB_USER=tbk_user
DB_PASSWORD=han0419/
DB_NAME=tbk_dev
DB_PORT=3306

# Application Configuration
PORT=3000
CORS_ORIGIN=http://localhost:8080
LOG_LEVEL=debug

# MySQL Configuration
MYSQL_ROOT_PASSWORD=han0419/
EOF
        log_success ".env.dev file created"
    fi
    
    # Create logs directory
    mkdir -p logs
    
    log_success "Environment setup completed"
}

build_and_deploy() {
    log_info "Building and deploying development environment..."
    
    cd "$PROJECT_ROOT"
    
    # Build and start services
    if command -v docker-compose &> /dev/null; then
        docker-compose -f docker-compose.dev.yml --env-file .env.dev up -d --build
    else
        docker compose -f docker-compose.dev.yml --env-file .env.dev up -d --build
    fi
    
    log_success "Development environment deployed"
}

wait_for_services() {
    log_info "Waiting for services to be ready..."
    
    # Wait for MySQL
    log_info "Waiting for MySQL to be ready..."
    timeout 60 bash -c 'until docker exec mysql-dev mysqladmin ping -h localhost --silent; do sleep 2; done'
    
    # Wait for Redis
    log_info "Waiting for Redis to be ready..."
    timeout 30 bash -c 'until docker exec redis-dev redis-cli ping | grep -q PONG; do sleep 2; done'
    
    # Wait for TBK application
    log_info "Waiting for TBK application to be ready..."
    timeout 60 bash -c "until curl -f http://localhost:${DEV_PORT}/health 2>/dev/null || curl -f http://localhost:${DEV_PORT}/ 2>/dev/null; do sleep 3; done"
    
    log_success "All services are ready"
}

run_health_checks() {
    log_info "Running health checks..."
    
    # Check TBK application
    if curl -f "http://localhost:${DEV_PORT}/health" &>/dev/null || curl -f "http://localhost:${DEV_PORT}/" &>/dev/null; then
        log_success "TBK application is healthy"
    else
        log_error "TBK application health check failed"
        return 1
    fi
    
    # Check MySQL
    if docker exec mysql-dev mysqladmin ping -h localhost --silent; then
        log_success "MySQL is healthy"
    else
        log_error "MySQL health check failed"
        return 1
    fi
    
    # Check Redis
    if docker exec redis-dev redis-cli ping | grep -q PONG; then
        log_success "Redis is healthy"
    else
        log_error "Redis health check failed"
        return 1
    fi
    
    log_success "All health checks passed"
}

show_status() {
    log_info "Development Environment Status:"
    echo "================================"
    echo "🌐 TBK Application: http://localhost:${DEV_PORT}"
    echo "🗄️  MySQL Database: localhost:${MYSQL_PORT}"
    echo "🔴 Redis Cache: localhost:${REDIS_PORT}"
    echo ""
    echo "📊 Container Status:"
    docker ps --filter "name=tbk-dev\|mysql-dev\|redis-dev" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    echo "📝 Logs:"
    echo "  - Application: docker logs tbk-dev"
    echo "  - Database: docker logs mysql-dev"
    echo "  - Redis: docker logs redis-dev"
}

# Main execution
main() {
    log_info "Starting TBK Development Environment Deployment"
    echo "================================================"
    
    # Parse command line arguments
    CLEAN_IMAGES=false
    SKIP_HEALTH_CHECK=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --clean-images)
                CLEAN_IMAGES=true
                shift
                ;;
            --skip-health-check)
                SKIP_HEALTH_CHECK=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --clean-images       Remove existing Docker images before deployment"
                echo "  --skip-health-check  Skip health checks after deployment"
                echo "  --help              Show this help message"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Execute deployment steps
    check_prerequisites
    
    if [[ "$CLEAN_IMAGES" == "true" ]]; then
        cleanup_existing --clean-images
    else
        cleanup_existing
    fi
    
    setup_environment
    build_and_deploy
    wait_for_services
    
    if [[ "$SKIP_HEALTH_CHECK" != "true" ]]; then
        run_health_checks
    fi
    
    show_status
    
    log_success "Development environment deployment completed successfully!"
    log_info "You can now access your application at http://localhost:${DEV_PORT}"
}

# Run main function with all arguments
main "$@"