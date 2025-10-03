# DNS Configuration Guide

## Domain: dev.tbk.example.com

### Required DNS Records

Add the following DNS records to your domain registrar or DNS provider:

```
Type    Name                Value               TTL
A       dev.tbk.example.com            [YOUR_SERVER_IP]    300
A       www.dev.tbk.example.com        [YOUR_SERVER_IP]    300
CNAME   api.dev.tbk.example.com        dev.tbk.example.com             300
CNAME   admin.dev.tbk.example.com      dev.tbk.example.com             300
```

### Optional Records

```
Type    Name                Value               TTL
AAAA    dev.tbk.example.com            [YOUR_IPv6]         300
TXT     dev.tbk.example.com            "v=spf1 -all"       300
```

### Verification

After setting up DNS records, verify them using:

```bash
# Check A record
dig A dev.tbk.example.com

# Check CNAME records
dig CNAME www.dev.tbk.example.com

# Check from external DNS
nslookup dev.tbk.example.com 8.8.8.8
```

### SSL Certificate Verification

Test SSL certificate after deployment:

```bash
# Test SSL connection
openssl s_client -connect dev.tbk.example.com:443 -servername dev.tbk.example.com

# Check certificate online
# Visit: https://www.ssllabs.com/ssltest/analyze.html?d=dev.tbk.example.com
```

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
   - Windows: `ipconfig /flushdns`
   - macOS: `sudo dscacheutil -flushcache`
   - Linux: `sudo systemctl restart systemd-resolved`
