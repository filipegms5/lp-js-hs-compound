// Configuração da API
// IMPORTANTE: Altere esta URL para a URL do seu backend deployado
const API_URL = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
    ? 'http://localhost:8080'
    : 'https://SEU-BACKEND.onrender.com'; // Altere para a URL do seu backend

// Elementos do DOM
const form = document.getElementById('compoundForm');
const calculateBtn = document.getElementById('calculateBtn');
const resultSection = document.getElementById('resultSection');
const errorSection = document.getElementById('errorSection');

// Função para formatar valores em moeda BRL
function formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(value);
}

// Função para formatar porcentagem
function formatPercentage(value) {
    return new Intl.NumberFormat('pt-BR', {
        style: 'percent',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(value);
}

// Função para validar inputs no cliente
function validateInputs(data) {
    const errors = [];

    if (isNaN(data.principal) || data.principal <= 0) {
        errors.push('O valor principal deve ser um número maior que zero');
    }

    if (isNaN(data.rate) || data.rate < 0) {
        errors.push('A taxa de juros não pode ser negativa');
    }

    if (isNaN(data.timesPerYear) || data.timesPerYear < 1 || !Number.isInteger(data.timesPerYear)) {
        errors.push('A frequência de composição deve ser um número inteiro maior ou igual a 1');
    }

    if (isNaN(data.years) || data.years <= 0) {
        errors.push('O período deve ser um número maior que zero');
    }

    return errors;
}

// Função para exibir erro
function showError(message) {
    errorSection.classList.remove('hidden');
    resultSection.classList.add('hidden');
    document.getElementById('errorMessage').textContent = message;

    // Scroll suave até o erro
    errorSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

// Função para exibir resultado
function showResult(response) {
    errorSection.classList.add('hidden');
    resultSection.classList.remove('hidden');

    const { amount, interest, inputs } = response;

    // Atualizar valores
    document.getElementById('finalAmount').textContent = formatCurrency(amount);
    document.getElementById('interestEarned').textContent = formatCurrency(interest);
    document.getElementById('principalValue').textContent = formatCurrency(inputs.principal);

    // Calcular porcentagem de retorno
    const returnRate = (interest / inputs.principal);
    document.getElementById('returnPercentage').textContent = formatPercentage(returnRate);

    // Atualizar detalhes da fórmula
    const frequencyNames = {
        1: 'anual',
        2: 'semestral',
        4: 'trimestral',
        12: 'mensal',
        365: 'diária'
    };

    const frequencyName = frequencyNames[inputs.timesPerYear] || `${inputs.timesPerYear}x ao ano`;

    document.getElementById('formulaDetails').innerHTML = `
        <p><strong>Onde:</strong></p>
        <ul style="list-style: none; padding-left: 0;">
            <li>• <strong>A</strong> = ${formatCurrency(amount)} (montante final)</li>
            <li>• <strong>P</strong> = ${formatCurrency(inputs.principal)} (principal)</li>
            <li>• <strong>r</strong> = ${(inputs.rate * 100).toFixed(2)}% = ${inputs.rate} (taxa anual)</li>
            <li>• <strong>n</strong> = ${inputs.timesPerYear} (composição ${frequencyName})</li>
            <li>• <strong>t</strong> = ${inputs.years} ano(s)</li>
        </ul>
    `;

    // Scroll suave até o resultado
    resultSection.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

// Função para calcular juros compostos via API
async function calculateCompoundInterest(data) {
    try {
        calculateBtn.disabled = true;
        calculateBtn.classList.add('loading');
        calculateBtn.textContent = 'Calculando...';

        const response = await fetch(`${API_URL}/api/compound`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        });

        const result = await response.json();

        if (!response.ok) {
            throw new Error(result.message || 'Erro ao calcular juros compostos');
        }

        showResult(result);

    } catch (error) {
        console.error('Erro:', error);

        let errorMessage = 'Erro ao conectar com o servidor. ';

        if (error.message.includes('Failed to fetch')) {
            errorMessage += 'Verifique se o backend está rodando e se a URL da API está correta.';
        } else {
            errorMessage += error.message;
        }

        showError(errorMessage);

    } finally {
        calculateBtn.disabled = false;
        calculateBtn.classList.remove('loading');
        calculateBtn.textContent = 'Calcular Juros Compostos';
    }
}

// Event listener para o formulário
form.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Coletar dados do formulário
    const formData = {
        principal: parseFloat(document.getElementById('principal').value),
        rate: parseFloat(document.getElementById('rate').value) / 100, // Converter % para decimal
        timesPerYear: parseInt(document.getElementById('timesPerYear').value),
        years: parseFloat(document.getElementById('years').value)
    };

    // Validar inputs no cliente
    const validationErrors = validateInputs(formData);

    if (validationErrors.length > 0) {
        showError(validationErrors.join('. '));
        return;
    }

    // Enviar para a API
    await calculateCompoundInterest(formData);
});

// Adicionar validação em tempo real
const inputs = form.querySelectorAll('input, select');
inputs.forEach(input => {
    input.addEventListener('input', () => {
        errorSection.classList.add('hidden');
    });
});

// Log para debug
console.log('API URL configurada:', API_URL);
console.log('Aplicação frontend carregada com sucesso!');
