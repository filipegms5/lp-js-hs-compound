# Calculadora de Juros Compostos

**Atividade de Recuperação - Linguagens de Programação 2025**

Sistema completo para cálculo de juros compostos com frontend em JavaScript e backend em Haskell, comunicando-se via API REST JSON.

## Índice

- [Descrição](#descrição)
- [Arquitetura](#arquitetura)
- [Tecnologias](#tecnologias)
- [Fórmula](#fórmula)
- [Endpoints da API](#endpoints-da-api)
- [Instalação Local](#instalação-local)
- [Deploy em Produção](#deploy-em-produção)
- [Exemplos de Uso](#exemplos-de-uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Links de Produção](#links-de-produção)

## Descrição

Este projeto implementa uma calculadora de juros compostos completa, dividida em duas partes:

- **Frontend:** Interface web responsiva em HTML, CSS e JavaScript puro
- **Backend:** API RESTful em Haskell usando Scotty, com validação de dados e suporte a CORS

A aplicação calcula o montante final de um investimento com base na fórmula de juros compostos, considerando:
- Valor principal (investimento inicial)
- Taxa de juros anual
- Frequência de composição (anual, semestral, trimestral, mensal ou diária)
- Período em anos

## Arquitetura

### Fluxo de Dados

1. Usuário preenche o formulário no frontend
2. JavaScript valida os dados localmente
3. Dados são enviados via POST para `/api/compound` em formato JSON
4. Backend Haskell valida os dados novamente
5. Cálculo é realizado usando a fórmula de juros compostos
6. Resultado é retornado em JSON
7. Frontend exibe o resultado formatado em BRL

## Tecnologias

### Backend
- **Haskell** - Linguagem funcional
- **Stack** - Gerenciador de build e dependências
- **Scotty** - Framework web leve
- **Aeson** - Manipulação de JSON
- **WAI-CORS** - Suporte a CORS

### Frontend
- **HTML5** - Estrutura semântica
- **CSS3** - Estilos modernos com variáveis CSS
- **JavaScript ES6+** - Lógica e comunicação via Fetch API
- **Intl API** - Formatação de moeda e números (pt-BR)

### Deploy
- **Docker** - Containerização do backend
- **Render/Railway** - Hospedagem do backend
- **Vercel/Netlify** - Hospedagem do frontend

## Fórmula

O cálculo de juros compostos utiliza a fórmula:

```
A = P × (1 + r/n)^(n×t)
```

**Onde:**
- **A** = Montante final
- **P** = Principal (valor inicial)
- **r** = Taxa de juros anual (em decimal, ex: 0.12 para 12%)
- **n** = Número de vezes que os juros são compostos por ano
- **t** = Tempo em anos

**Exemplo:**
- P = R$ 1.000,00
- r = 12% ao ano (0.12)
- n = 12 (mensal)
- t = 5 anos

**Cálculo:**
```
A = 1000 × (1 + 0.12/12)^(12×5)
A = 1000 × (1.01)^60
A = R$ 1.816,70
```

**Juros ganhos:** R$ 816,70

## Endpoints da API

### `GET /`

Health check da API.

**Response (200):**
```json
{
  "status": "ok",
  "service": "Compound Interest API",
  "version": "1.0.0"
}
```

### `POST /api/compound`

Calcula juros compostos.

**Request Body:**
```json
{
  "principal": 1000,
  "rate": 0.12,
  "timesPerYear": 12,
  "years": 5
}
```

**Campos:**
- `principal` (number, required): Valor inicial > 0
- `rate` (number, required): Taxa anual em decimal ≥ 0 (ex: 0.12 = 12%)
- `timesPerYear` (integer, required): Frequência de composição ≥ 1
- `years` (number, required): Período em anos > 0

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

**Response (400) - Erro de Validação:**
```json
{
  "error": "ValidationError",
  "message": "O valor principal deve ser maior que zero"
}
```

**Validações:**
- Principal > 0
- Rate >= 0
- TimesPerYear >= 1 (inteiro)
- Years > 0
- Todos os campos presentes
- Todos os valores numéricos válidos

## Instalação Local

### Pré-requisitos

- **Backend:** Stack (Haskell) - [Instalação](https://docs.haskellstack.org/en/stable/README/)
- **Frontend:** Navegador web moderno
- **Opcional:** Docker

### Backend

```bash
# Navegar para o diretório do backend
cd backend

# Instalar dependências e compilar
stack setup
stack build

# Executar
stack run

# Ou especificar porta
PORT=8080 stack run
```

O backend estará disponível em `http://localhost:8080`

### Frontend

```bash
# Navegar para o diretório do frontend
cd frontend

# Servir com qualquer servidor HTTP estático
# Opção 1: Python
python -m http.server 3000

# Opção 2: Node.js http-server
npx http-server -p 3000

# Opção 3: Live Server (VS Code extension)
# Clique com botão direito em index.html > "Open with Live Server"
```

O frontend estará disponível em `http://localhost:3000`

### Testar a API

```bash
# Health check
curl http://localhost:8080/

# Calcular juros compostos
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }'
```

## Deploy em Produção

Consulte o arquivo **[DEPLOY.md](DEPLOY.md)** para instruções detalhadas passo a passo.

### Resumo Rápido

#### Backend (Render)

1. Criar conta em [render.com](https://render.com)
2. New > Web Service > Connect repository
3. Configurar:
   - Environment: Docker
   - Dockerfile Path: `backend/Dockerfile`
   - Port: 8080
4. Deploy

#### Frontend (Vercel)

1. Instalar Vercel CLI: `npm i -g vercel`
2. Executar: `cd frontend && vercel`
3. Seguir prompts
4. Atualizar `app.js` com URL do backend

### Configurar CORS

No backend, a configuração de CORS já está habilitada para aceitar todas as origens. Para produção, você pode restringir para apenas o domínio do frontend editando [backend/app/Main.hs](backend/app/Main.hs:35).

## Exemplos de Uso

### Exemplo 1: Investimento Mensal

**Entrada:**
- Principal: R$ 5.000,00
- Taxa: 10% ao ano (0.10)
- Composição: Mensal (12x)
- Período: 3 anos

**Saída:**
- Montante: R$ 6.749,85
- Juros: R$ 1.749,85

### Exemplo 2: Investimento Trimestral

**Entrada:**
- Principal: R$ 10.000,00
- Taxa: 8% ao ano (0.08)
- Composição: Trimestral (4x)
- Período: 10 anos

**Saída:**
- Montante: R$ 22.080,40
- Juros: R$ 12.080,40

### Exemplo 3: Investimento Anual

**Entrada:**
- Principal: R$ 2.000,00
- Taxa: 15% ao ano (0.15)
- Composição: Anual (1x)
- Período: 5 anos

**Saída:**
- Montante: R$ 4.022,71
- Juros: R$ 2.022,71

## Estrutura do Projeto

```
lp-recuperacao-js-hs-compound/
 frontend/
    index.html          # Página principal
    style.css           # Estilos
    app.js              # Lógica JavaScript
    vercel.json         # Config Vercel
    netlify.toml        # Config Netlify
    README.md           # Doc frontend
 backend/
    app/
       Main.hs         # Código principal
    package.yaml        # Dependências
    stack.yaml          # Config Stack
    Setup.hs            # Setup Haskell
    Dockerfile          # Container Docker
    .dockerignore       # Exclusões Docker
    render.yaml         # Config Render
    README.md           # Doc backend
 .gitignore              # Arquivos ignorados
 LICENSE                 # Licença MIT
 README.md               # Esta documentação
 DEPLOY.md               # Guia de deploy
 RECUP_LP_2025.md        # Identificação da atividade
```

## Links de Produção

> **Nota:** Preencha estes links após fazer o deploy

### Frontend (Aplicação)
**URL:** [Preencher após deploy]

### Backend (API)
**URL:** [Preencher após deploy]

### Repositório GitHub
**URL:** [Preencher após publicar]

**Tag/Release:** `v1.0-RECUP-LP-2025`

## Checklist de Entrega

- [x] Backend Haskell implementado com validação
- [x] Frontend JavaScript funcional
- [x] Comunicação via JSON
- [x] CORS configurado
- [x] Formatação em BRL (pt-BR)
- [x] Tratamento de erros
- [x] Dockerfile criado
- [ ] Backend deployado em produção
- [ ] Frontend deployado em produção
- [ ] README.md completo
- [ ] DEPLOY.md com passo a passo
- [ ] RECUP_LP_2025.md preenchido
- [ ] Tag v1.0-RECUP-LP-2025 criada
- [ ] Repositório público no GitHub
- [ ] Links testados e funcionando

## Informações Acadêmicas

**Disciplina:** Linguagens de Programação
**Instituição:** Cotemig
**Ano:** 2025
**Tipo:** Atividade de Recuperação
**Prazo:** 16/11/2025 às 23:59 (BRT)

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Desenvolvido como atividade acadêmica - 2025**
