<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Marksheet - ${student.rollNumber} - ${exam.title}</title>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f1f5f9;
            color: #0f172a;
            padding: 2rem 1rem;
        }

        .marksheet-container {
            max-width: 850px;
            margin: 0 auto;
            background: white;
            padding: 3rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            border: 2px solid #e2e8f0;
            position: relative;
        }

        .university-header {
            text-align: center;
            border-bottom: 3px double #0f172a;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .university-logo {
            font-size: 3rem;
            color: #1e3a8a;
            margin-bottom: 0.5rem;
        }

        .university-title {
            font-size: 1.6rem;
            font-weight: 800;
            letter-spacing: -0.01em;
            color: #0f172a;
            text-transform: uppercase;
            margin-bottom: 0.25rem;
        }

        .marksheet-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #2563eb;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-top: 0.5rem;
        }

        .student-info-grid {
            background-color: #f8fafc;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 2rem;
        }

        .score-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        .score-table th {
            background-color: #0f172a;
            color: white;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 0.75rem 1rem;
            border: 1px solid #0f172a;
        }

        .score-table td {
            padding: 0.85rem 1rem;
            border: 1px solid #cbd5e1;
            font-size: 0.95rem;
        }

        .signature-box {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 4rem;
            padding-top: 1rem;
        }

        .signature-line {
            width: 200px;
            border-top: 1px solid #0f172a;
            text-align: center;
            padding-top: 0.5rem;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .seal-box {
            width: 110px;
            height: 110px;
            border: 2px dashed #94a3b8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            font-size: 0.75rem;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
        }

        @media print {
            body {
                background: white !important;
                padding: 0 !important;
            }
            .marksheet-container {
                box-shadow: none !important;
                border: none !important;
                padding: 1.5rem !important;
                max-width: 100% !important;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>

<!-- Control Action Bar (Hidden on Print) -->
<div class="container text-center mb-4 no-print" style="max-width: 850px;">
    <div class="d-flex justify-content-between align-items-center bg-white p-3 rounded-3 shadow-sm border">
        <a href="${pageContext.request.contextPath}/student/results" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Back to Portal
        </a>
        <div class="fw-bold fs-5 text-dark">Official Student Grade Sheet</div>
        <button onclick="window.print()" class="btn btn-primary fw-bold px-4" style="background-color: #2563eb;">
            <i class="bi bi-printer-fill me-1"></i> Print / Save as PDF
        </button>
    </div>
</div>

<div class="marksheet-container">
    <!-- Header -->
    <div class="university-header">
        <div class="university-logo">
            <i class="bi bi-mortarboard-fill"></i>
        </div>
        <div class="university-title">National Institute of Technology &amp; Science</div>
        <div class="text-muted small">Department of Academic Affairs &bull; Examination Branch</div>
        <div class="marksheet-title">Official Statement of Marks &amp; Grades</div>
    </div>

    <!-- Student Metadata -->
    <div class="student-info-grid">
        <div class="row g-2">
            <div class="col-sm-6">
                <span class="text-muted small">Candidate Name:</span>
                <div class="fw-bold text-dark fs-6">${student.fullName}</div>
            </div>
            <div class="col-sm-6">
                <span class="text-muted small">Roll / Registration Number:</span>
                <div class="fw-bold text-dark fs-6">${student.rollNumber}</div>
            </div>
            <div class="col-sm-6">
                <span class="text-muted small">Department:</span>
                <div class="fw-bold text-dark">${student.department}</div>
            </div>
            <div class="col-sm-6">
                <span class="text-muted small">Admission Batch:</span>
                <div class="fw-bold text-dark">${student.admissionYear}</div>
            </div>
            <div class="col-sm-6">
                <span class="text-muted small">Examination:</span>
                <div class="fw-bold text-primary">${exam.title}</div>
            </div>
            <div class="col-sm-6">
                <span class="text-muted small">Subject Code &amp; Name:</span>
                <div class="fw-bold text-dark">${exam.subjectCode} - ${exam.subjectName}</div>
            </div>
        </div>
    </div>

    <!-- Score Breakdown Table -->
    <table class="score-table">
        <thead>
            <tr>
                <th>Total Questions</th>
                <th>Attempted</th>
                <th>Correct</th>
                <th>Incorrect</th>
                <th>Maximum Marks</th>
                <th>Marks Obtained</th>
                <th>Percentage</th>
                <th>Grade</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <tr class="text-center">
                <td>${result.totalQuestions}</td>
                <td>${result.correctAnswers + result.incorrectAnswers}</td>
                <td class="text-success fw-bold">${result.correctAnswers}</td>
                <td class="text-danger fw-bold">${result.incorrectAnswers}</td>
                <td class="fw-bold">${result.totalMarks}</td>
                <td class="fw-bold fs-5 text-dark">${result.obtainedMarks}</td>
                <td class="fw-bold text-primary">${result.percentage}%</td>
                <td><span class="badge bg-dark fs-6">${result.grade}</span></td>
                <td>
                    <span class="badge ${result.status == 'PASS' ? 'bg-success' : 'bg-danger'} fs-6">
                        ${result.status}
                    </span>
                </td>
            </tr>
        </tbody>
    </table>

    <!-- Grading Scale Key -->
    <div class="p-3 bg-light rounded-3 border mb-4 small text-secondary">
        <div class="fw-bold text-dark mb-1">Grading System Legend:</div>
        <div class="d-flex flex-wrap gap-3">
            <span><strong>O:</strong> Outstanding (90%+)</span>
            <span><strong>A+:</strong> Excellent (80-89%)</span>
            <span><strong>A:</strong> Very Good (70-79%)</span>
            <span><strong>B+:</strong> Good (60-69%)</span>
            <span><strong>B:</strong> Above Average (50-59%)</span>
            <span><strong>C:</strong> Pass (40-49%)</span>
            <span><strong>F:</strong> Fail (&lt;40%)</span>
        </div>
    </div>

    <!-- Signatures and Official Stamp -->
    <div class="signature-box">
        <div class="signature-line">
            Examiner / Course Faculty
        </div>

        <div class="seal-box">
            University<br>Official Seal
        </div>

        <div class="signature-line">
            Controller of Examinations
        </div>
    </div>

    <div class="text-center text-muted small mt-4 pt-3 border-top">
        Date of Issue: ${result.createdAt} &bull; Document Reference: EXAM-RES-${result.id}-${student.id}
    </div>
</div>

</body>
</html>

