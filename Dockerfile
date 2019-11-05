FROM python:3.7-alpine
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
    && rm -rf /tmp/* /var/cache/apk/*

# PIP Install
RUN sudo apt install python-pip -y \ 
    pip --version

# PIPENV
RUN sudo apt install linuxbrew-wrapper -y
RUN brew install pipenv 
RUN brew upgrade pipenv
RUN sudo -H pip install -U pipenv

#INSTALL YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt update && sudo apt install yarn
RUN yarn --version

#installvueCLI

RUN chmod 755 init_container.sh 
COPY sshd_config /etc/ssh/
RUN rc-update add sshd

EXPOSE 2222 8000
ENV PORT 8000
ENTRYPOINT ["/django_vue/init_container.sh"]
