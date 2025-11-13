# Exemplos de Requisições

Este arquivo contém exemplos de requisições para testar a API.

## Health Check

### Request
```bash
curl http://localhost:8080/
```

### Response
```json
{
  "status": "ok",
  "service": "Compound Interest API",
  "version": "1.0.0"
}
```

---

## Exemplo 1: Investimento Mensal Básico

### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }'
```

### Response
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

### Explicação
- **Principal:** R$ 1.000,00
- **Taxa:** 12% ao ano (0.12)
- **Composição:** Mensal (12x ao ano)
- **Período:** 5 anos
- **Resultado:** R$ 1.816,70 (R$ 816,70 de juros)

---

## Exemplo 2: Investimento com Composição Anual

### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 5000,
    "rate": 0.10,
    "timesPerYear": 1,
    "years": 10
  }'
```

### Response
```json
{
  "amount": 12968.71,
  "interest": 7968.71,
  "inputs": {
    "principal": 5000,
    "rate": 0.10,
    "timesPerYear": 1,
    "years": 10
  }
}
```

### Explicação
- **Principal:** R$ 5.000,00
- **Taxa:** 10% ao ano (0.10)
- **Composição:** Anual (1x ao ano)
- **Período:** 10 anos
- **Resultado:** R$ 12.968,71 (R$ 7.968,71 de juros)

---

## Exemplo 3: Composição Trimestral

### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 10000,
    "rate": 0.08,
    "timesPerYear": 4,
    "years": 10
  }'
```

### Response
```json
{
  "amount": 22080.40,
  "interest": 12080.40,
  "inputs": {
    "principal": 10000,
    "rate": 0.08,
    "timesPerYear": 4,
    "years": 10
  }
}
```

### Explicação
- **Principal:** R$ 10.000,00
- **Taxa:** 8% ao ano (0.08)
- **Composição:** Trimestral (4x ao ano)
- **Período:** 10 anos
- **Resultado:** R$ 22.080,40 (R$ 12.080,40 de juros)

---

## Exemplo 4: Composição Diária

### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 2000,
    "rate": 0.08,
    "timesPerYear": 365,
    "years": 3
  }'
```

### Response
```json
{
  "amount": 2542.50,
  "interest": 542.50,
  "inputs": {
    "principal": 2000,
    "rate": 0.08,
    "timesPerYear": 365,
    "years": 3
  }
}
```

### Explicação
- **Principal:** R$ 2.000,00
- **Taxa:** 8% ao ano (0.08)
- **Composição:** Diária (365x ao ano)
- **Período:** 3 anos
- **Resultado:** R$ 2.542,50 (R$ 542,50 de juros)

---

## Exemplo 5: Período Fracionário

### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 3000,
    "rate": 0.15,
    "timesPerYear": 12,
    "years": 2.5
  }'
```

### Response
```json
{
  "amount": 4418.88,
  "interest": 1418.88,
  "inputs": {
    "principal": 3000,
    "rate": 0.15,
    "timesPerYear": 12,
    "years": 2.5
  }
}
```

### Explicação
- **Principal:** R$ 3.000,00
- **Taxa:** 15% ao ano (0.15)
- **Composição:** Mensal (12x ao ano)
- **Período:** 2,5 anos (30 meses)
- **Resultado:** R$ 4.418,88 (R$ 1.418,88 de juros)

---

## Exemplos de Erro

### Erro 1: Principal Negativo

#### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": -1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }'
```

#### Response (400)
```json
{
  "error": "ValidationError",
  "message": "O valor principal deve ser maior que zero"
}
```

---

### Erro 2: Taxa Negativa

#### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": -0.12,
    "timesPerYear": 12,
    "years": 5
  }'
```

#### Response (400)
```json
{
  "error": "ValidationError",
  "message": "A taxa de juros não pode ser negativa"
}
```

---

### Erro 3: Frequência Inválida

#### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 0,
    "years": 5
  }'
```

#### Response (400)
```json
{
  "error": "ValidationError",
  "message": "A frequência de composição deve ser pelo menos 1"
}
```

---

### Erro 4: Período Zero

#### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 0
  }'
```

#### Response (400)
```json
{
  "error": "ValidationError",
  "message": "O período em anos deve ser maior que zero"
}
```

---

### Erro 5: JSON Malformado

#### Request
```bash
curl -X POST http://localhost:8080/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": "abc",
    "rate": 0.12
  }'
```

#### Response (400)
```json
{
  "error": "BadRequest",
  "message": "Error in $: parsing Main.CompoundRequest failed..."
}
```

---

## Testando em Produção

Substitua `http://localhost:8080` pela URL do seu backend em produção:

```bash
# Exemplo com Render
curl -X POST https://compound-interest-api-xxxx.onrender.com/api/compound \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }'
```

---

## Usando PowerShell (Windows)

```powershell
$body = @{
    principal = 1000
    rate = 0.12
    timesPerYear = 12
    years = 5
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/compound" `
  -Method Post `
  -Body $body `
  -ContentType "application/json"
```

---

## Usando JavaScript (Browser Console)

```javascript
fetch('http://localhost:8080/api/compound', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    principal: 1000,
    rate: 0.12,
    timesPerYear: 12,
    years: 5
  })
})
.then(res => res.json())
.then(data => console.log(data))
.catch(err => console.error(err));
```

---

## Comparação de Frequências

Para o mesmo principal (R$ 1.000), taxa (12%) e período (5 anos):

| Frequência | Valor por Ano | Montante Final | Juros Ganhos |
|-----------|---------------|----------------|--------------|
| Anual (1x) | 1 | R$ 1.762,34 | R$ 762,34 |
| Semestral (2x) | 2 | R$ 1.790,85 | R$ 790,85 |
| Trimestral (4x) | 4 | R$ 1.806,11 | R$ 806,11 |
| Mensal (12x) | 12 | R$ 1.816,70 | R$ 816,70 |
| Diária (365x) | 365 | R$ 1.822,03 | R$ 822,03 |

**Conclusão:** Quanto maior a frequência de composição, maior o retorno!
