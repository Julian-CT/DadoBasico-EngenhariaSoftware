# Usar a imagem oficial do Node.js
FROM node:18-alpine

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o package.json e package-lock.json
COPY package*.json ./

# Instalar as dependências
RUN npm ci

# Copiar o restante do código
COPY . .

# Construir a aplicação
RUN npm run build

# Expor a porta da aplicação
EXPOSE 3000

# Definir a variável de ambiente para produção
ENV NODE_ENV production

# Comando para iniciar a aplicação
CMD ["npm", "start"]
