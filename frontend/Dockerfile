FROM node:20-alpine

WORKDIR /usr/src/app

# まず package.json / lock をコピーして依存関係インストール
COPY /package*.json ./
RUN npm install

# そのあとソースを全部コピー
COPY /. .

EXPOSE 4200

CMD ["npm", "run", "start", "--", "--host", "0.0.0.0"]
