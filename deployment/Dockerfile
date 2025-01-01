FROM node:alpine
WORKDIR /usr/src/app
COPY package*.json ./

# Install dependencies
RUN npm install --production

COPY . .

RUN npm install

EXPOSE 3000

CMD [ "npm" , "start" ]
