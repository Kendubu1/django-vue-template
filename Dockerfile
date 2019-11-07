FROM python:3.6-alpine
RUN mkdir /django_vue
COPY . /django_vue
WORKDIR /django_vue

# ------------------------
# SSH Server support
# Alpine Reference: https://wiki.alpinelinux.org/wiki/Setting_up_a_ssh-server
# ------------------------
ENV SSH_PASSWD "root:Docker!"
RUN apk --update --no-cache  add openssh \
    openrc \
    bash \ 
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && echo "$SSH_PASSWD" | chpasswd \
    && rm -rf /tmp/* /var/cache/apk/* \
    && apk add --no-cache postgresql-libs \
    && apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev \
    && pip install pipenv \
    && pip install psycopg2

    
#INSTALL YARN
RUN apk add yarn

#installvueCLI
RUN yarn global add @vue/cli
RUN vue --version

RUN chmod 755 init_container.sh 
COPY sshd_config /etc/ssh/
RUN rc-update add sshd

EXPOSE 2222 8000
ENV PORT 8000
ENTRYPOINT ["/django_vue/init_container.sh"]
