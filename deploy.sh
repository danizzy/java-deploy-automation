#!/bin/bash
# ===========================================
# Automated Java Build & Deploy Script
# Environment-aware version
# ===========================================

ENV=${1:-dev}  # Default environment = dev

## --- Load Config ---
if [ ! -f "configs/$ENV.env" ]; then
    echo "Config file configs/$ENV.env not found!"
        exit 1
fi
source "configs/$ENV.env"

#        # --- Helper Function for Logging ---
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') [$ENV] $1" | tee -a "$LOG_FILE"
}

# --- Start Deployment ---
log "=== Starting deployment for $APP_NAME in $ENV environment ==="

cd "$APP_DIR" || { log "App directory not found!"; exit 1; }

log "Cleaning old build..."
mvn clean >> "$LOG_FILE" 2>&1

#log "Building with Maven..."
mvn package -DskipTests >> "$LOG_FILE" 2>&1

WAR_FILE="target/$APP_NAME.war"
if [ ! -f "$WAR_FILE" ]; then
	log "WAR file not found at $WAR_FILE"
        exit 1
fi

log "Stopping Tomcat..."
$TOMCAT_DIR/bin/shutdown.sh >> "$LOG_FILE" 2>&1 || true
sleep 5

log "Deploying WAR to Tomcat..."
rm -f "$TOMCAT_DIR/webapps/$APP_NAME.war"
rm -rf "$TOMCAT_DIR/webapps/$APP_NAME"
cp "$WAR_FILE" "$TOMCAT_DIR/webapps/" || { log "Failed to copy WAR file"; exit 1; }

log "Starting Tomcat..."
$TOMCAT_DIR/bin/startup.sh >> "$LOG_FILE" 2>&1

log "Deployment finished! Access app at http://<server-ip>:8080/$APP_NAME"

