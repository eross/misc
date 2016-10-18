FROM ubuntu
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y npm nodejs git vim
RUN npm install karma-jasmine karma-chrome-launcher jasmine-core karma --save-dev -g
RUN npm install bower -g
RUN useradd -u 1000 -U -m ericr
RUN ln -s /usr/bin/nodejs /usr/bin/node
USER ericr
ENTRYPOINT /bin/bash
