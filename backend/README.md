# Backend - Compound Interest API

API em Haskell para cálculo de juros compostos usando Scotty e Aeson.

## Tecnologias

- **Haskell** com Stack
- **Scotty** - Framework web
- **Aeson** - Manipulação de JSON
- **WAI-CORS** - Suporte a CORS

## Fórmula

```
A = P × (1 + r/n)^(n×t)
```

Onde:
- **A** = Montante final
- **P** = Principal (valor inicial)
- **r** = Taxa de juros anual (decimal)
- **n** = Número de vezes que os juros são compostos por ano
- **t** = Tempo em anos

## Instalação

```bash
cd backend
stack setup
stack build
```

## Executar Localmente

```bash
stack run
```

O servidor inicia na porta `8080` (ou a porta definida na variável de ambiente `PORT`).

## Endpoints

### POST /api/compound

Calcula juros compostos.

**Request:**
```json
{
  "principal": 1000,
  "rate": 0.12,
  "timesPerYear": 12,
  "years": 5
}
```

**Response (200):**
```json
{
  "amount": 1816.6967,
  "interest": 816.6967,
  "inputs": {
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }
}
```

**Response (400) - Erro:**
```json
{
  "error": "ValidationError",
  "message": "O valor principal deve ser maior que zero"
}
```

### GET /

Health check da API.

**Response:**
```json
{
  "status": "ok",
  "service": "Compound Interest API",
  "version": "1.0.0"
}
```

## Deploy

Veja o arquivo [DEPLOY.md](../DEPLOY.md) na raiz do projeto para instruções detalhadas de deploy.
