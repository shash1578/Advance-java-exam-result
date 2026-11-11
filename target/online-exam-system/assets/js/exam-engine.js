/**
 * ============================================================
 * ONLINE EXAMINATION ENGINE - CLIENT CONTROLLER
 * Handles Question Navigation, AJAX Auto-save, Palette Updates,
 * Real-time Countdown Timer, and Auto-submission.
 * ============================================================
 */

class ExamEngine {
    constructor(config) {
        this.attemptId = config.attemptId;
        this.totalQuestions = config.totalQuestions;
        this.remainingSeconds = config.remainingSeconds;
        this.saveUrl = config.saveUrl;
        this.submitUrl = config.submitUrl;
        this.currentIndex = 0; // 0-based question index

        this.questions = [];
        this.timerInterval = null;

        this.init();
    }

    init() {
        this.collectQuestions();
        this.bindEvents();
        this.startTimer();
        this.showQuestion(0);
        this.updatePaletteSummary();
    }

    collectQuestions() {
        const questionCards = document.querySelectorAll('.question-item');
        questionCards.forEach((card, idx) => {
            const qId = parseInt(card.dataset.questionId);
            const selectedInput = card.querySelector('input[type="radio"]:checked');
            const isMarked = card.dataset.markedForReview === 'true';

            this.questions.push({
                index: idx,
                id: qId,
                element: card,
                selectedOption: selectedInput ? selectedInput.value : null,
                isMarkedForReview: isMarked
            });
        });
    }

    bindEvents() {
        // Option selection change
        document.querySelectorAll('.option-input').forEach(input => {
            input.addEventListener('change', (e) => {
                const qId = parseInt(e.target.name.replace('q_', ''));
                const optionVal = e.target.value;
                this.handleOptionSelect(qId, optionVal);
            });
        });

        // Previous button
        const prevBtn = document.getElementById('prevQuestionBtn');
        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                if (this.currentIndex > 0) {
                    this.showQuestion(this.currentIndex - 1);
                }
            });
        }

        // Next button
        const nextBtn = document.getElementById('nextQuestionBtn');
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                if (this.currentIndex < this.totalQuestions - 1) {
                    this.showQuestion(this.currentIndex + 1);
                }
            });
        }

        // Mark for Review button
        const reviewBtn = document.getElementById('toggleReviewBtn');
        if (reviewBtn) {
            reviewBtn.addEventListener('click', () => {
                this.toggleMarkForReview();
            });
        }

        // Clear selection button
        const clearBtn = document.getElementById('clearSelectionBtn');
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                this.clearCurrentSelection();
            });
        }

        // Palette button clicks
        document.querySelectorAll('.palette-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const targetIdx = parseInt(e.currentTarget.dataset.index);
                this.showQuestion(targetIdx);
            });
        });

        // Submit button & modal confirmation
        const finalSubmitBtn = document.getElementById('confirmFinalSubmitBtn');
        if (finalSubmitBtn) {
            finalSubmitBtn.addEventListener('click', () => {
                this.submitExam(false);
            });
        }
    }

    showQuestion(index) {
        if (index < 0 || index >= this.totalQuestions) return;

        this.currentIndex = index;

        // Hide all questions, show the current one
        this.questions.forEach((q, idx) => {
            if (idx === index) {
                q.element.style.display = 'block';
            } else {
                q.element.style.display = 'none';
            }
        });

        // Update nav buttons disabled states
        const prevBtn = document.getElementById('prevQuestionBtn');
        const nextBtn = document.getElementById('nextQuestionBtn');

        if (prevBtn) prevBtn.disabled = (index === 0);
        if (nextBtn) nextBtn.disabled = (index === this.totalQuestions - 1);

        // Update current indicator on palette
        document.querySelectorAll('.palette-btn').forEach((btn, idx) => {
            if (idx === index) {
                btn.classList.add('current');
            } else {
                btn.classList.remove('current');
            }
        });

        // Update Review button appearance
        const currQ = this.questions[index];
        const reviewBtn = document.getElementById('toggleReviewBtn');
        if (reviewBtn) {
            if (currQ.isMarkedForReview) {
                reviewBtn.classList.remove('btn-outline-warning');
                reviewBtn.classList.add('btn-warning');
                reviewBtn.innerHTML = '<i class="bi bi-bookmark-check-fill me-1"></i> Marked for Review';
            } else {
                reviewBtn.classList.remove('btn-warning');
                reviewBtn.classList.add('btn-outline-warning');
                reviewBtn.innerHTML = '<i class="bi bi-bookmark me-1"></i> Mark for Review';
            }
        }
    }

    handleOptionSelect(questionId, selectedOption) {
        const q = this.questions.find(item => item.id === questionId);
        if (!q) return;

        q.selectedOption = selectedOption;

        // Visual highlight for the option pill
        const card = q.element;
        card.querySelectorAll('.option-pill').forEach(pill => {
            pill.classList.remove('selected');
        });
        const activePill = card.querySelector(`.option-pill[data-option="${selectedOption}"]`);
        if (activePill) {
            activePill.classList.add('selected');
        }

        this.updatePaletteButton(q);
        this.updatePaletteSummary();

        // AJAX autosave to server
        this.saveToServer(q);
    }

    clearCurrentSelection() {
        const q = this.questions[this.currentIndex];
        if (!q) return;

        q.selectedOption = null;

        // Uncheck radio input
        const card = q.element;
        card.querySelectorAll('input[type="radio"]').forEach(radio => radio.checked = false);
        card.querySelectorAll('.option-pill').forEach(pill => pill.classList.remove('selected'));

        this.updatePaletteButton(q);
        this.updatePaletteSummary();

        // AJAX autosave to server with null
        this.saveToServer(q);
    }

    toggleMarkForReview() {
        const q = this.questions[this.currentIndex];
        if (!q) return;

        q.isMarkedForReview = !q.isMarkedForReview;

        const reviewBtn = document.getElementById('toggleReviewBtn');
        if (reviewBtn) {
            if (q.isMarkedForReview) {
                reviewBtn.classList.remove('btn-outline-warning');
                reviewBtn.classList.add('btn-warning');
                reviewBtn.innerHTML = '<i class="bi bi-bookmark-check-fill me-1"></i> Marked for Review';
            } else {
                reviewBtn.classList.remove('btn-warning');
                reviewBtn.classList.add('btn-outline-warning');
                reviewBtn.innerHTML = '<i class="bi bi-bookmark me-1"></i> Mark for Review';
            }
        }

        this.updatePaletteButton(q);
        this.updatePaletteSummary();

        // AJAX autosave review state to server
        this.saveToServer(q);
    }

    updatePaletteButton(q) {
        const btn = document.querySelector(`.palette-btn[data-index="${q.index}"]`);
        if (!btn) return;

        // Reset state classes
        btn.classList.remove('answered', 'review');

        if (q.selectedOption) {
            btn.classList.add('answered');
        }
        if (q.isMarkedForReview) {
            btn.classList.add('review');
        }
    }

    updatePaletteSummary() {
        let answered = 0;
        let review = 0;

        this.questions.forEach(q => {
            if (q.selectedOption) answered++;
            if (q.isMarkedForReview) review++;
        });

        const unanswered = this.totalQuestions - answered;

        const answeredEl = document.getElementById('countAnswered');
        const unansweredEl = document.getElementById('countUnanswered');
        const reviewEl = document.getElementById('countReview');

        if (answeredEl) answeredEl.textContent = answered;
        if (unansweredEl) unansweredEl.textContent = unanswered;
        if (reviewEl) reviewEl.textContent = review;

        // Update modal summary if opened
        const modalAnswered = document.getElementById('modalAnsweredCount');
        const modalUnanswered = document.getElementById('modalUnansweredCount');
        if (modalAnswered) modalAnswered.textContent = answered;
        if (modalUnanswered) modalUnanswered.textContent = unanswered;
    }

    saveToServer(q) {
        const saveStatusIndicator = document.getElementById('saveStatusIndicator');
        if (saveStatusIndicator) {
            saveStatusIndicator.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Saving...';
            saveStatusIndicator.style.color = '#3b82f6';
        }

        const formData = new URLSearchParams();
        formData.append('attemptId', this.attemptId);
        formData.append('questionId', q.id);
        formData.append('selectedOption', q.selectedOption || '');
        formData.append('isMarkedForReview', q.isMarkedForReview);

        fetch(this.saveUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (saveStatusIndicator) {
                if (data.success) {
                    saveStatusIndicator.innerHTML = '<i class="bi bi-check-circle-fill text-success me-1"></i> Saved';
                } else if (data.expired) {
                    saveStatusIndicator.innerHTML = '<i class="bi bi-clock-history text-danger me-1"></i> Time expired!';
                    this.submitExam(true);
                } else {
                    saveStatusIndicator.innerHTML = '<i class="bi bi-exclamation-triangle-fill text-warning me-1"></i> Save warning';
                }
            }
        })
        .catch(err => {
            console.error('Autosave error:', err);
            if (saveStatusIndicator) {
                saveStatusIndicator.innerHTML = '<i class="bi bi-cloud-slash text-danger me-1"></i> Network error';
            }
        });
    }

    startTimer() {
        const timerDigits = document.getElementById('timerDigits');
        const timerBox = document.getElementById('timerBox');

        const tick = () => {
            if (this.remainingSeconds <= 0) {
                clearInterval(this.timerInterval);
                if (timerDigits) timerDigits.textContent = "00:00";
                this.submitExam(true);
                return;
            }

            this.remainingSeconds--;

            const minutes = Math.floor(this.remainingSeconds / 60);
            const seconds = this.remainingSeconds % 60;

            const formattedTime = 
                (minutes < 10 ? '0' : '') + minutes + ':' +
                (seconds < 10 ? '0' : '') + seconds;

            if (timerDigits) timerDigits.textContent = formattedTime;

            // Turn timer red and pulse when under 5 minutes
            if (this.remainingSeconds <= 300) {
                if (timerBox && !timerBox.classList.contains('warning')) {
                    timerBox.classList.add('warning');
                }
            }
        };

        tick();
        this.timerInterval = setInterval(tick, 1000);
    }

    submitExam(isAutoSubmit) {
        if (this.timerInterval) clearInterval(this.timerInterval);

        const form = document.getElementById('examSubmitForm');
        if (form) {
            if (isAutoSubmit) {
                const autoInput = document.createElement('input');
                autoInput.type = 'hidden';
                autoInput.name = 'autoSubmit';
                autoInput.value = 'true';
                form.appendChild(autoInput);
            }
            form.submit();
        } else {
            window.location.href = `${this.submitUrl}?attemptId=${this.attemptId}${isAutoSubmit ? '&autoSubmit=true' : ''}`;
        }
    }
}

