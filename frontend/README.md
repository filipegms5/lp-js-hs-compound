# Frontend - Calculadora de Juros Compostos

Interface web em HTML, CSS e JavaScript puro para cálculo de juros compostos.

## Tecnologias

- HTML5
- CSS3 (com variáveis CSS e Grid/Flexbox)
- JavaScript ES6+ (Fetch API)

## Funcionalidades

- Formulário interativo com validação
- Comunicação com API backend via JSON
- Formatação de valores em BRL (pt-BR)
- Design responsivo
- Tratamento de erros amigável
- Cálculo em tempo real

## Estrutura de Arquivos

```
frontend/
 index.html    # Estrutura da página
 style.css     # Estilos e design
 app.js        # Lógica e comunicação com API
 README.md     # Documentação
```

## Configuração

### Desenvolvimento Local

1. Abra o arquivo `app.js`
2. A aplicação detecta automaticamente se está rodando localmente
3. Para localhost, usa `http://localhost:8080`

### Produção

1. Edite o arquivo `app.js`
2. Altere a linha:
   ```javascript
   const API_URL = 'https://SEU-BACKEND.onrender.com';
   ```
3. Substitua pela URL real do seu backend deployado

## Deploy

### Vercel

```bash
cd frontend
vercel
```

### Netlify

1. Arraste a pasta `frontend` para o Netlify Drop
2. Ou use o CLI:
   ```bash
   cd frontend
   netlify deploy --prod
   ```

### GitHub Pages

1. Commit os arquivos do frontend
2. Vá em Settings > Pages
3. Selecione a branch e a pasta `/frontend`

## Validações

A aplicação valida:
-  Valor principal > 0
-  Taxa de juros ≥ 0
-  Frequência de composição ≥ 1
-  Período em anos > 0
-  Todos os valores são numéricos

## Exemplo de Uso

1. **Valor Principal:** R$ 1.000,00
2. **Taxa de Juros Anual:** 12% (digite 12)
3. **Frequência:** Mensal (12x)
4. **Período:** 5 anos

**Resultado:** R$ 1.816,70 (R$ 816,70 de juros)

## Internacionalização

- Valores monetários formatados em BRL (R$)
- Separadores decimais pt-BR (vírgula)
- Porcentagens com 2 casas decimais
