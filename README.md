# Wildcard SSL with Certbot and Cloudflare

Using `certbot` to request Let's Encrypt wildcard certificate for your domain, the domain name must managed by CloudFlare DNS 

### How to

* Create a file `cloudflare.ini` in `creds/` to save CloudFlare "Global API keys" and email auth.
* Copy `docker-compose_example.yml` to `docker-compose.yml`, edit file content as your needs
* For renew hook, add your script to folder `renew_hooks`, all file must end with `.sh`
* Run `docker-compose up -d` to start container
* Access container on bind port (default: `8080`) to download certificate
* The container will auto loop the certificate request for every 75 days