# Dockerfile para backend Haskell

# Estágio 1: Build
FROM haskell:9.4 AS builder

WORKDIR /app

# Copiar arquivos de configuração primeiro (melhor cache)
COPY stack.yaml package.yaml ./
COPY Setup.hs ./

# Instalar dependências
RUN stack setup
RUN stack build --only-dependencies

# Copiar código fonte
COPY app ./app

# Build da aplicação
RUN stack build --copy-bins

# Estágio 2: Runtime
FROM ubuntu:22.04

# Instalar dependências de runtime
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    libgmp10 \
    netbase \
    && rm -rf /var/lib/apt/lists/*

# Copiar binário compilado
COPY --from=builder /root/.local/bin/compound-interest-api-exe /usr/local/bin/compound-interest-api

# Criar usuário não-root
RUN useradd -m -u 1000 appuser
USER appuser

# Expor porta
EXPOSE 8080

# Definir variável de ambiente padrão
ENV PORT=8080

# Executar aplicação
CMD ["compound-interest-api"]
