#!/bin/bash

# Production deployment script for Oksana Security website
# Usage: ./deploy.sh [domain]

DOMAIN=${1:-"oksana-security.nl"}
EMAIL="oksana.hofker@gmail.com"

echo "🚀 Starting deployment for domain: $DOMAIN"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Update domain in nginx config
echo "🔧 Updating nginx configuration for domain: $DOMAIN"
sed -i "s/oksanasecurity\.nl/$DOMAIN/g" nginx-ssl.conf
sed -i "s/oksana\.hofker@gmail\.com/$EMAIL/g" docker-compose.prod.yml

# Create certbot directories
echo "📁 Creating SSL certificate directories..."
mkdir -p certbot/conf certbot/www

# Start nginx without SSL first (for initial Let's Encrypt challenge)
echo "🌐 Starting nginx for Let's Encrypt challenge..."
cat > nginx-temp.conf << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        proxy_pass http://oksana-security:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Temporarily use HTTP-only config
cp nginx-temp.conf nginx-ssl.conf

# Build and start services
echo "🏗️ Building and starting services..."
docker-compose -f docker-compose.prod.yml up -d oksana-security nginx-proxy

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Obtain SSL certificate
echo "🔒 Obtaining SSL certificate..."
docker-compose -f docker-compose.prod.yml run --rm certbot

# Restore SSL configuration
echo "🔧 Restoring SSL nginx configuration..."
git checkout nginx-ssl.conf

# Update domain in restored config
sed -i "s/oksanasecurity\.nl/$DOMAIN/g" nginx-ssl.conf

# Restart nginx with SSL configuration
echo "🔄 Restarting nginx with SSL..."
docker-compose -f docker-compose.prod.yml restart nginx-proxy

# Clean up temporary files
rm -f nginx-temp.conf

# Set up automatic certificate renewal
echo "⚡ Setting up automatic SSL renewal..."
(crontab -l 2>/dev/null; echo "0 12 * * * cd $(pwd) && docker-compose -f docker-compose.prod.yml run --rm certbot renew && docker-compose -f docker-compose.prod.yml restart nginx-proxy") | crontab -

echo "✅ Deployment complete!"
echo "🌍 Your site should be available at: https://$DOMAIN"
echo "📊 Check status: docker-compose -f docker-compose.prod.yml ps"
echo "📜 View logs: docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🔧 SSL certificate will auto-renew via cron job"
echo "📅 Next renewal check: $(date -d '+3 months')"