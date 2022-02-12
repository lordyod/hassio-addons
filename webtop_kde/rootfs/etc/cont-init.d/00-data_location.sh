#!/usr/bin/with-contenv bashio

# Define user
PUID=$(bashio::config "PUID")
PGID=$(bashio::config "PGID")

# Check data location
LOCATION=$(bashio::config 'data_location')
if [[ "$LOCATION" = "null" || -z "$LOCATION" ]]; then
# Default location
LOCATION="/share/webtop_kde"
else
bashio::log.warning "Warning : a custom data location was selected, but the previous folder will NOT be copied. You need to do it manually"
fi

# Set data location
bashio::log.info "Setting data location to $LOCATION"
sed -i "1a export HOME=$LOCATION" /etc/services.d/web/run
sed -i "1a export FM_HOME=$LOCATION" /etc/services.d/web/run
sed -i "s|/share/webtop_kde|$LOCATION|g" /defaults/*
sed -i "s|/share/webtop_kde|$LOCATION|g" /etc/cont-init.d/*
sed -i "s|/share/webtop_kde|$LOCATION|g" /etc/services.d/*/run
usermod --home "$LOCATION" abc

# Set ownership
bashio::log.info "Setting ownership to $PUID:$PGID" 
chown "$PUID":"$PGID" "$LOCATION"

# Create folder
echo "Creating $LOCATION"
mkdir -p "$LOCATION"
