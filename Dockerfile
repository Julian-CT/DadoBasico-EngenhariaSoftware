# Etapa 1: Build da aplicação
FROM node:18-alpine AS builder

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY package.json package-lock.json ./

# Instalar dependências
RUN npm ci

# Copiar o restante do código
COPY . .

# Gerar Prisma Client
RUN npx prisma generate

# Build da aplicação Next.js
RUN npm run build

# Remover dev dependencies para reduzir o tamanho da imagem
RUN npm prune --production

# Etapa 2: Executar a aplicação
FROM node:18-alpine

# Definir diretório de trabalho
WORKDIR /app

# Copiar apenas as dependências e o build da etapa anterior
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/prisma ./prisma
# COPY --from=builder /app/public ./public

# Definir a variável de ambiente para produção
ENV NODE_ENV=production

# Expor a porta da aplicação
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["npm", "start"]
