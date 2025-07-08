let attempts = 0;
let maxAttempts = 3;
let isSubmitting = false;

// Initialize the password prompt
function init() {
    const passwordInput = document.getElementById('password-input');
    const submitBtn = document.getElementById('submit-btn');
    
    // Focus on password input
    passwordInput.focus();
    
    // Handle Enter key press
    passwordInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && !isSubmitting) {
            submitPassword();
        }
    });
    
    // Handle Escape key press
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            cancelConnection();
        }
    });
    
    // Prevent form submission on Enter
    passwordInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
        }
    });
}

// Submit password to server
function submitPassword() {
    if (isSubmitting) return;
    
    const passwordInput = document.getElementById('password-input');
    const submitBtn = document.getElementById('submit-btn');
    const errorMessage = document.getElementById('error-message');
    const password = passwordInput.value.trim();
    
    if (!password) {
        showError('Please enter a password');
        return;
    }
    
    // Set loading state
    isSubmitting = true;
    submitBtn.disabled = true;
    submitBtn.textContent = 'Connecting...';
    submitBtn.classList.add('loading');
    
    // Clear previous errors
    hideError();
    
    // Send password to FiveM client
    fetch(`https://${GetParentResourceName()}/submitPassword`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            password: password
        })
    }).catch(err => {
        console.error('Error submitting password:', err);
        resetSubmitButton();
        showError('Connection error. Please try again.');
    });
}

// Cancel connection
function cancelConnection() {
    fetch(`https://${GetParentResourceName()}/cancelConnection`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
    }).catch(err => {
        console.error('Error canceling connection:', err);
    });
}

// Show error message
function showError(message) {
    const errorElement = document.getElementById('error-message');
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');
}

// Hide error message
function hideError() {
    const errorElement = document.getElementById('error-message');
    errorElement.classList.add('hidden');
}

// Reset submit button state
function resetSubmitButton() {
    const submitBtn = document.getElementById('submit-btn');
    isSubmitting = false;
    submitBtn.disabled = false;
    submitBtn.textContent = 'Connect';
    submitBtn.classList.remove('loading');
}

// Update attempts counter
function updateAttempts(current, max) {
    attempts = current;
    maxAttempts = max;
    
    const attemptsElement = document.getElementById('attempts-counter');
    if (current > 0) {
        attemptsElement.textContent = `Attempt ${current}/${max}`;
        attemptsElement.classList.remove('hidden');
    } else {
        attemptsElement.classList.add('hidden');
    }
}

// Handle messages from FiveM client
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'showPasswordPrompt':
            document.getElementById('auth-container').classList.remove('hidden');
            document.getElementById('password-input').focus();
            break;
            
        case 'hidePasswordPrompt':
            document.getElementById('auth-container').classList.add('hidden');
            break;
            
        case 'passwordIncorrect':
            resetSubmitButton();
            showError(data.message || 'Incorrect password. Please try again.');
            updateAttempts(data.attempts || 0, data.maxAttempts || 3);
            document.getElementById('password-input').value = '';
            document.getElementById('password-input').focus();
            break;
            
        case 'passwordCorrect':
            document.getElementById('auth-container').classList.add('hidden');
            break;
            
        case 'connectionTimeout':
            showError('Connection timeout. Please reconnect.');
            setTimeout(() => {
                cancelConnection();
            }, 3000);
            break;
            
        case 'maxAttemptsReached':
            showError('Maximum attempts exceeded. Connection will be terminated.');
            setTimeout(() => {
                cancelConnection();
            }, 3000);
            break;
    }
});

// Initialize when page loads
document.addEventListener('DOMContentLoaded', init);

// Utility function to get parent resource name
function GetParentResourceName() {
    return window.location.hostname;
}