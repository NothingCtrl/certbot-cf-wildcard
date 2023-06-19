FROM ubuntu:22.04
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y git python3 python3-pip curl nano cron sudo
WORKDIR /root
# source: https://raw.githubusercontent.com/vinyll/certbot-install/master/install.sh
COPY certbot-install_master_install.sh .
RUN /bin/bash certbot-install_master_install.sh
RUN apt-get install python3-certbot-nginx python3-certbot-dns-cloudflare -y
COPY init_script.sh .
ENTRYPOINT ["/root/init_script.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]