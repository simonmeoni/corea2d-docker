############################################################
# Dockerfile to build flask-visualizer container images
# Based on Ubuntu
############################################################

################## BEGIN INSTALLATION ######################
# Set the base image to ubuntu
FROM debian

# File Author / Maintainer
MAINTAINER Simon Meoni

# Update the repository sources list

## update repository source && dependencies
ADD config.json config.json
RUN apt-get update && apt-get install -y git curl jq

## ENVIRONMENTS VARIABLES
ENV NODE_VERSION v8.2.1
ENV NVM_DIR /usr/local/nvm
ENV NODE_PATH $NVM_DIR/$NODE_VERSION/node_modules
ENV PATH $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

## NODE TASKS
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" &&  nvm install $NODE_VERSION && nvm use $NODE_VERSION

## SETUP REPOSITORY & NODE SERVER
RUN git clone --recursive https://github.com/simonmeoni/corea2d-indexer.git
RUN cd corea2d-indexer && npm install
RUN echo `jq -r .API_URL config.json` | awk 'gsub("/","\/")' > ./api-url
RUN sed -e s/\{API_URL\}/`less api-url`/g -i corea2d-indexer/coread-resource-indexer-front/config/url-config.js
RUN more corea2d-indexer/coread-resource-indexer-front/config/url-config.js
RUN cd corea2d-indexer/coread-resource-indexer-front && npm install && npm run build

ADD entrypoint.sh /entrypoint.sh

##################### INSTALLATION END #####################
EXPOSE 3000
CMD ./entrypoint.sh
