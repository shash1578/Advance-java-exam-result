/**
 * ============================================================
 * ONLINE EXAMINATION SYSTEM - APPLICATION JAVASCRIPT
 * Table filters, search, modal triggers, and toast notifications
 * ============================================================
 */

document.addEventListener('DOMContentLoaded', () => {

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 5000);
    });

    // Real-time table search filter
    const searchInputs = document.querySelectorAll('[data-table-search]');
    searchInputs.forEach(input => {
        const tableSelector = input.getAttribute('data-table-search');
        const targetTable = document.querySelector(tableSelector);

        if (targetTable) {
            input.addEventListener('keyup', (e) => {
                const term = e.target.value.toLowerCase();
                const rows = targetTable.querySelectorAll('tbody tr');

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    if (text.includes(term)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        }
    });

    // Password match validation in forms
    const pwdForms = document.querySelectorAll('.validate-password-match');
    pwdForms.forEach(form => {
        form.addEventListener('submit', (e) => {
            const pwd = form.querySelector('input[name="password"], input[name="newPassword"]');
            const confirm = form.querySelector('input[name="confirmPassword"]');
            if (pwd && confirm && pwd.value !== confirm.value) {
                e.preventDefault();
                alert('Passwords do not match. Please re-enter.');
            }
        });
    });

});

