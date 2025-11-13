#!/bin/bash
# Script para testar a API localmente

API_URL="${1:-http://localhost:8080}"

echo " Testando API em: $API_URL"
echo ""

# Teste 1: Health check
echo " Teste 1: Health Check"
echo "GET $API_URL/"
curl -s "$API_URL/" | jq .
echo ""
echo ""

# Teste 2: Cálculo válido
echo " Teste 2: Cálculo Válido"
echo "POST $API_URL/api/compound"
curl -s -X POST "$API_URL/api/compound" \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }' | jq .
echo ""
echo ""

# Teste 3: Erro - principal negativo
echo " Teste 3: Erro - Principal Negativo"
curl -s -X POST "$API_URL/api/compound" \
  -H "Content-Type: application/json" \
  -d '{
    "principal": -1000,
    "rate": 0.12,
    "timesPerYear": 12,
    "years": 5
  }' | jq .
echo ""
echo ""

# Teste 4: Erro - taxa negativa
echo " Teste 4: Erro - Taxa Negativa"
curl -s -X POST "$API_URL/api/compound" \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 1000,
    "rate": -0.12,
    "timesPerYear": 12,
    "years": 5
  }' | jq .
echo ""
echo ""

# Teste 5: Composição anual
echo " Teste 5: Composição Anual"
curl -s -X POST "$API_URL/api/compound" \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 5000,
    "rate": 0.10,
    "timesPerYear": 1,
    "years": 10
  }' | jq .
echo ""
echo ""

# Teste 6: Composição diária
echo " Teste 6: Composição Diária"
curl -s -X POST "$API_URL/api/compound" \
  -H "Content-Type: application/json" \
  -d '{
    "principal": 2000,
    "rate": 0.08,
    "timesPerYear": 365,
    "years": 3
  }' | jq .
echo ""
echo ""

echo " Testes concluídos!"
