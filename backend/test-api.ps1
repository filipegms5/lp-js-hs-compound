# Script PowerShell para testar a API localmente

param(
    [string]$ApiUrl = "http://localhost:8080"
)

Write-Host " Testando API em: $ApiUrl" -ForegroundColor Cyan
Write-Host ""

# Teste 1: Health check
Write-Host " Teste 1: Health Check" -ForegroundColor Yellow
Write-Host "GET $ApiUrl/"
$response = Invoke-RestMethod -Uri "$ApiUrl/" -Method Get
$response | ConvertTo-Json
Write-Host ""

# Teste 2: Cálculo válido
Write-Host " Teste 2: Cálculo Válido" -ForegroundColor Yellow
Write-Host "POST $ApiUrl/api/compound"
$body = @{
    principal = 1000
    rate = 0.12
    timesPerYear = 12
    years = 5
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$ApiUrl/api/compound" -Method Post -Body $body -ContentType "application/json"
    $response | ConvertTo-Json
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 3: Erro - principal negativo
Write-Host " Teste 3: Erro - Principal Negativo" -ForegroundColor Yellow
$body = @{
    principal = -1000
    rate = 0.12
    timesPerYear = 12
    years = 5
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$ApiUrl/api/compound" -Method Post -Body $body -ContentType "application/json"
    $response | ConvertTo-Json
} catch {
    $_.ErrorDetails.Message | ConvertFrom-Json | ConvertTo-Json
}
Write-Host ""

# Teste 4: Composição anual
Write-Host " Teste 4: Composição Anual" -ForegroundColor Yellow
$body = @{
    principal = 5000
    rate = 0.10
    timesPerYear = 1
    years = 10
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$ApiUrl/api/compound" -Method Post -Body $body -ContentType "application/json"
    $response | ConvertTo-Json
} catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host " Testes concluídos!" -ForegroundColor Green
