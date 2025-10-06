#!/bin/bash

# TBK SSL Certificate Setup Script
# SSL证书配置脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
DOMAIN="${1:-tbk.example.com}"
EMAIL="${2:-admin@example.com}"
SSL_DIR="./ssl"
CERT_TYPE="${3:-self-signed}"  # self-signed, letsencrypt, custom

# 日志函数
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

# 显示使用说明
show_usage() {
    echo "Usage: $0 [domain] [email] [cert_type]"
    echo ""
    echo "Parameters:"
    echo "  domain    - Domain name (default: tbk.example.com)"
    echo "  email     - Email for Let's Encrypt (default: admin@example.com)"
    echo "  cert_type - Certificate type: self-signed, letsencrypt, custom (default: self-signed)"
    echo ""
    echo "Examples:"
    echo "  $0                                          # Use defaults"
    echo "  $0 tbk.yourdomain.com admin@yourdomain.com letsencrypt"
    echo "  $0 localhost admin@example.com self-signed"
    echo ""
}

# 创建SSL目录
create_ssl_directory() {
    log_info "Creating SSL directory..."
    mkdir -p "$SSL_DIR"
    log_success "SSL directory created: $SSL_DIR"
}

# 生成自签名证书
generate_self_signed_cert() {
    log_info "Generating self-signed SSL certificate for $DOMAIN..."
    
    # 创建配置文件
    cat > "$SSL_DIR/openssl.conf" << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CN
ST = Beijing
L = Beijing
O = TBK
OU = IT Department
CN = $DOMAIN

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF
    
    # 生成私钥
    openssl genrsa -out "$SSL_DIR/key.pem" 2048
    
    # 生成证书签名请求
    openssl req -new -key "$SSL_DIR/key.pem" -out "$SSL_DIR/cert.csr" -config "$SSL_DIR/openssl.conf"
    
    # 生成自签名证书
    openssl x509 -req -in "$SSL_DIR/cert.csr" -signkey "$SSL_DIR/key.pem" -out "$SSL_DIR/cert.pem" -days 365 -extensions v3_req -extfile "$SSL_DIR/openssl.conf"
    
    # 设置权限
    chmod 600 "$SSL_DIR/key.pem"
    chmod 644 "$SSL_DIR/cert.pem"
    
    log_success "Self-signed certificate generated successfully"
    
    # 显示证书信息
    show_certificate_info
}

# 使用Let's Encrypt生成证书
generate_letsencrypt_cert() {
    log_info "Generating Let's Encrypt SSL certificate for $DOMAIN..."
    
    # 检查certbot
    if ! command -v certbot &> /dev/null; then
        log_error "Certbot is not installed"
        log_info "Please install certbot first:"
        log_info "  Ubuntu/Debian: sudo apt-get install certbot"
        log_info "  CentOS/RHEL: sudo yum install certbot"
        log_info "  macOS: brew install certbot"
        exit 1
    fi
    
    # 生成证书
    certbot certonly --standalone \
        --email "$EMAIL" \
        --agree-tos \
        --no-eff-email \
        -d "$DOMAIN" \
        --cert-path "$SSL_DIR/cert.pem" \
        --key-path "$SSL_DIR/key.pem"
    
    log_success "Let's Encrypt certificate generated successfully"
    
    # 创建续期脚本
    create_renewal_script
}

# 创建证书续期脚本
create_renewal_script() {
    log_info "Creating certificate renewal script..."
    
    cat > "$SSL_DIR/renew-cert.sh" << EOF
#!/bin/bash

# TBK SSL Certificate Renewal Script

set -e

log_info() {
    echo "[INFO] \$1"
}

log_success() {
    echo "[SUCCESS] \$1"
}

log_error() {
    echo "[ERROR] \$1"
}

# 续期证书
log_info "Renewing SSL certificate for $DOMAIN..."

if certbot renew --quiet; then
    log_success "Certificate renewed successfully"
    
    # 重启Nginx
    if docker-compose -f docker-compose.public.yml ps nginx-public | grep -q "Up"; then
        docker-compose -f docker-compose.public.yml restart nginx-public
        log_info "Nginx restarted"
    fi
else
    log_error "Certificate renewal failed"
    exit 1
fi
EOF
    
    chmod +x "$SSL_DIR/renew-cert.sh"
    
    log_success "Renewal script created: $SSL_DIR/renew-cert.sh"
    log_info "Add to crontab for automatic renewal:"
    log_info "  0 2 * * 0 $PWD/$SSL_DIR/renew-cert.sh"
}

# 使用自定义证书
setup_custom_cert() {
    log_info "Setting up custom SSL certificate..."
    
    echo "Please provide your certificate files:"
    echo "1. Certificate file (cert.pem)"
    echo "2. Private key file (key.pem)"
    echo "3. Certificate chain file (optional: chain.pem)"
    echo ""
    
    read -p "Enter path to certificate file: " cert_file
    read -p "Enter path to private key file: " key_file
    read -p "Enter path to certificate chain file (optional): " chain_file
    
    # 验证文件存在
    if [[ ! -f "$cert_file" ]]; then
        log_error "Certificate file not found: $cert_file"
        exit 1
    fi
    
    if [[ ! -f "$key_file" ]]; then
        log_error "Private key file not found: $key_file"
        exit 1
    fi
    
    # 复制文件
    cp "$cert_file" "$SSL_DIR/cert.pem"
    cp "$key_file" "$SSL_DIR/key.pem"
    
    if [[ -n "$chain_file" && -f "$chain_file" ]]; then
        cp "$chain_file" "$SSL_DIR/chain.pem"
        # 合并证书和链
        cat "$SSL_DIR/cert.pem" "$SSL_DIR/chain.pem" > "$SSL_DIR/fullchain.pem"
    fi
    
    # 设置权限
    chmod 600 "$SSL_DIR/key.pem"
    chmod 644 "$SSL_DIR/cert.pem"
    
    log_success "Custom certificate setup completed"
    
    # 验证证书
    verify_certificate
}

# 验证证书
verify_certificate() {
    log_info "Verifying SSL certificate..."
    
    if [[ -f "$SSL_DIR/cert.pem" && -f "$SSL_DIR/key.pem" ]]; then
        # 检查证书和私钥是否匹配
        cert_hash=$(openssl x509 -noout -modulus -in "$SSL_DIR/cert.pem" | openssl md5)
        key_hash=$(openssl rsa -noout -modulus -in "$SSL_DIR/key.pem" | openssl md5)
        
        if [[ "$cert_hash" == "$key_hash" ]]; then
            log_success "Certificate and private key match"
        else
            log_error "Certificate and private key do not match"
            exit 1
        fi
        
        # 显示证书信息
        show_certificate_info
    else
        log_error "Certificate files not found"
        exit 1
    fi
}

# 显示证书信息
show_certificate_info() {
    log_info "Certificate Information:"
    echo "========================"
    
    # 证书详情
    openssl x509 -in "$SSL_DIR/cert.pem" -text -noout | grep -E "(Subject:|Issuer:|Not Before:|Not After:|DNS:|IP Address:)" || true
    
    echo ""
    log_info "Certificate files:"
    echo "  Certificate: $SSL_DIR/cert.pem"
    echo "  Private Key: $SSL_DIR/key.pem"
    
    if [[ -f "$SSL_DIR/chain.pem" ]]; then
        echo "  Chain: $SSL_DIR/chain.pem"
    fi
    
    if [[ -f "$SSL_DIR/fullchain.pem" ]]; then
        echo "  Full Chain: $SSL_DIR/fullchain.pem"
    fi
}

# 创建域名配置文件
create_domain_config() {
    log_info "Creating domain configuration..."
    
    cat > "$SSL_DIR/domain.conf" << EOF
# TBK Domain Configuration

# Primary domain
DOMAIN=$DOMAIN
EMAIL=$EMAIL
CERT_TYPE=$CERT_TYPE

# SSL Configuration
SSL_CERT_PATH=$SSL_DIR/cert.pem
SSL_KEY_PATH=$SSL_DIR/key.pem
SSL_CHAIN_PATH=$SSL_DIR/chain.pem
SSL_FULLCHAIN_PATH=$SSL_DIR/fullchain.pem

# Nginx Configuration
NGINX_CONF_TEMPLATE=nginx/production.conf
NGINX_CONF_OUTPUT=nginx/production.conf

# DNS Configuration (for reference)
# Add these DNS records to your domain:
# A    $DOMAIN    [YOUR_SERVER_IP]
# AAAA $DOMAIN    [YOUR_SERVER_IPv6] (optional)
# CNAME www.$DOMAIN $DOMAIN

# Firewall Ports
# 80/tcp   - HTTP
# 443/tcp  - HTTPS
# 8080/tcp - HTTP Proxy
# 8443/tcp - HTTPS Proxy
EOF
    
    log_success "Domain configuration saved to $SSL_DIR/domain.conf"
}

# 创建DNS配置指南
create_dns_guide() {
    log_info "Creating DNS configuration guide..."
    
    cat > "$SSL_DIR/DNS_SETUP.md" << EOF
# DNS Configuration Guide

## Domain: $DOMAIN

### Required DNS Records

Add the following DNS records to your domain registrar or DNS provider:

\`\`\`
Type    Name                Value               TTL
A       $DOMAIN            [YOUR_SERVER_IP]    300
A       www.$DOMAIN        [YOUR_SERVER_IP]    300
CNAME   api.$DOMAIN        $DOMAIN             300
CNAME   admin.$DOMAIN      $DOMAIN             300
\`\`\`

### Optional Records

\`\`\`
Type    Name                Value               TTL
AAAA    $DOMAIN            [YOUR_IPv6]         300
TXT     $DOMAIN            "v=spf1 -all"       300
\`\`\`

### Verification

After setting up DNS records, verify them using:

\`\`\`bash
# Check A record
dig A $DOMAIN

# Check CNAME records
dig CNAME www.$DOMAIN

# Check from external DNS
nslookup $DOMAIN 8.8.8.8
\`\`\`

### SSL Certificate Verification

Test SSL certificate after deployment:

\`\`\`bash
# Test SSL connection
openssl s_client -connect $DOMAIN:443 -servername $DOMAIN

# Check certificate online
# Visit: https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN
\`\`\`

### Common DNS Providers

- **Aliyun DNS**: https://dns.console.aliyun.com/
- **Cloudflare**: https://dash.cloudflare.com/
- **DNSPod**: https://console.dnspod.cn/
- **GoDaddy**: https://dcc.godaddy.com/manage/dns
- **Namecheap**: https://ap.www.namecheap.com/domains/domaincontrolpanel/

### Troubleshooting

1. **DNS propagation**: Changes may take 24-48 hours to propagate globally
2. **TTL values**: Lower TTL (300s) for faster updates during setup
3. **Cache clearing**: Clear local DNS cache if needed
   - Windows: \`ipconfig /flushdns\`
   - macOS: \`sudo dscacheutil -flushcache\`
   - Linux: \`sudo systemctl restart systemd-resolved\`
EOF
    
    log_success "DNS setup guide created: $SSL_DIR/DNS_SETUP.md"
}

# 主函数
main() {
    echo ""
    log_info "TBK SSL Certificate Setup"
    echo "=================================================="
    echo ""
    
    # 显示配置信息
    log_info "Configuration:"
    echo "  Domain: $DOMAIN"
    echo "  Email: $EMAIL"
    echo "  Certificate Type: $CERT_TYPE"
    echo ""
    
    # 创建SSL目录
    create_ssl_directory
    
    # 根据证书类型执行相应操作
    case "$CERT_TYPE" in
        "self-signed")
            generate_self_signed_cert
            ;;
        "letsencrypt")
            generate_letsencrypt_cert
            ;;
        "custom")
            setup_custom_cert
            ;;
        *)
            log_error "Invalid certificate type: $CERT_TYPE"
            show_usage
            exit 1
            ;;
    esac
    
    # 创建配置文件
    create_domain_config
    create_dns_guide
    
    echo ""
    log_success "SSL certificate setup completed!"
    echo ""
    log_info "Next steps:"
    echo "1. Configure your DNS records (see $SSL_DIR/DNS_SETUP.md)"
    echo "2. Update Nginx configuration with your domain"
    echo "3. Deploy the application with SSL enabled"
    echo "4. Test the SSL certificate"
    echo ""
    
    if [[ "$CERT_TYPE" == "letsencrypt" ]]; then
        log_info "For Let's Encrypt certificates:"
        echo "- Set up automatic renewal with crontab"
        echo "- Monitor certificate expiration"
    fi
}

# 检查参数
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# 运行主函数
main "$@"