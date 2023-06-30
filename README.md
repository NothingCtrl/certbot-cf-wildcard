# certbot-cf-wildcard

Using `certbot` to request Let's Encrypt wildcard certificate for your domain, the domain name must managed by CloudFlare DNS 

### How to

* Create a file `cloudflare.ini` in `creds/` to save **CloudFlare** _"Global API keys"_ and _email_ for authentication.
* Copy `docker-compose_example.yml` to `docker-compose.yml`, edit file content as your needs
* For renewal hook, add your script to folder `renewal_hooks`, all file must end with `.sh`
    * In-case we have many web server, for remote server trigger, you can try with this project [`certbot-cf-webhook`](https://github.com/NothingCtrl/certbot-cf-webhook), summary steps:
        * Setup `certbot-cf-webhook` on your web server, default it should listen on port `9000`
        * On this app, before run docker, add a script to `renewal_hooks` folder, example file name `call_web_hook.sh`, file content:
            ```sh
            #!/bin/bash
            USER_AGENT="certbot-demo"
            WEBHOOK_TOKEN="just-me"
            WEBHOOK_URL="http://some-local-ip:9000/certbot?domain=foo.bar"
            
            # trigger web hook
            /usr/bin/curl --retry 3 --connect-timeout 10 -A $USER_AGENT -H "Authorization: $WEBHOOK_TOKEN" $WEBHOOK_URL
            ```
* Run `docker-compose up -d --build` to start container
* Access container on bind port (default: `8080`) to download certificate
* The application will auto run certificate renew for every 75 days
