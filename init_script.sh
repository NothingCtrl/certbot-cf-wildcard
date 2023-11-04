#!/bin/bash
CLOUDFLARE_CRED=/root/creds/cloudflare.ini

certbotRequest() {
    echo "=== BEGIN CERTBOT SSL REQUEST SCRIPT ==="
    CMD="certbot certonly --dns-cloudflare --dns-cloudflare-credentials $CLOUDFLARE_CRED -d $DOMAIN,*.$DOMAIN --preferred-challenges dns-01 --agree-tos --register-unsafely-without-email --force-renew --dns-cloudflare-propagation-seconds 30"
   
    if [ "$ZIMBRA" != "" ]; then
        CMD="$CMD --preferred-chain \"ISRG Root X1\""
    fi
    
    if [ "$DRY_RUN" != "" ]; then
        CMD="$CMD --dry-run"
    fi
    
    echo "-------------------------------------"
    echo "Command execute: $CMD"
    echo "-------------------------------------"
    
    eval "$CMD"
    
    # remove default cron task create by certbot
    if [[ -f "/etc/cron.d/certbot" ]]; then 
        rm /etc/cron.d/certbot
    fi
    
    echo "=== END CERTBOT SSL REQUEST SCRIPT ==="
}

if [[ -f "$CLOUDFLARE_CRED" ]]; then
    echo "- Start web server at port: $WEB_PORT..."
    nohup python3 -m http.server -d /etc/letsencrypt/live/"$DOMAIN" "$WEB_PORT" &
    chmod 600 $CLOUDFLARE_CRED
    certbotRequest
    remain_seconds=$((70*3600*24))
    while true
    do
        sleep 30
        remain_seconds=$((remain_seconds-30))
        echo "- Remain time to refresh certificates: $remain_seconds (seconds)"
        if [ "$remain_seconds" -eq "0" ]; then
            certbotRequest
            remain_seconds=$((75*3600*24))
        fi        
    done
else
    echo "Error, cannot request SSL. Please save Cloudflare API credentials to file $CLOUDFLARE_CRED..."
fi