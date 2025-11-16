# PowerShell script to create a Pull Request
# Usage: Set $GITHUB_TOKEN environment variable or replace the token below
# Then run: .\create_pr.ps1

$REPO_OWNER = "UsamaAhmad577"
$REPO_NAME = "flask-k8s-ci-cd-assignment"
$GITHUB_TOKEN = $env:GITHUB_TOKEN

if (-not $GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN environment variable not set."
    Write-Host "Please set it using: `$env:GITHUB_TOKEN = 'your_token_here'"
    Write-Host ""
    Write-Host "Alternatively, you can create the PR manually at:"
    Write-Host "https://github.com/$REPO_OWNER/$REPO_NAME/compare/develop...feature/initial-structure" -ForegroundColor Cyan
    exit 1
}

$headers = @{
    "Authorization" = "token $GITHUB_TOKEN"
    "Accept" = "application/vnd.github.v3+json"
}

$prUrl = "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pulls"

$prData = @{
    title = "feat: Add initial project structure with Flask app, Docker, Kubernetes, and CI/CD configs"
    body = @"
## Summary
This PR adds the initial project structure for the Flask application with CI/CD pipelines.

## Changes
- ✅ Created basic Flask "Hello, World!" application (`app.py`)
- ✅ Added Dockerfile with multi-stage build
- ✅ Added Kubernetes deployment and service manifests
- ✅ Added Jenkinsfile with declarative pipeline
- ✅ Implemented GitHub Actions CI workflow with:
  - Python 3.11 environment setup
  - Dependency installation
  - Flake8 linting (max-line-length: 90 characters)
  - Pytest unit tests
  - Docker image build

## Testing
- All flake8 linting checks pass
- Pytest unit tests pass successfully
- Docker image builds successfully

## Related Issues
- Closes #[issue_number] (if applicable)
"@
    head = "feature/initial-structure"
    base = "develop"
} | ConvertTo-Json -Depth 10

Write-Host "Creating Pull Request from feature/initial-structure to develop..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri $prUrl -Method Post -Headers $headers -Body $prData -ContentType "application/json"
    Write-Host ""
    Write-Host "✅ Pull Request created successfully!" -ForegroundColor Green
    Write-Host "PR #$($response.number): $($response.title)" -ForegroundColor Cyan
    Write-Host "URL: $($response.html_url)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "You can view and manage the PR at the URL above." -ForegroundColor Yellow
} catch {
    $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
    if ($errorDetails.message -match "already exists") {
        Write-Host "⚠️  A Pull Request already exists for this branch." -ForegroundColor Yellow
        Write-Host "View existing PRs at: https://github.com/$REPO_OWNER/$REPO_NAME/pulls" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Error creating PR: $($errorDetails.message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "You can create the PR manually at:" -ForegroundColor Yellow
        Write-Host "https://github.com/$REPO_OWNER/$REPO_NAME/compare/develop...feature/initial-structure" -ForegroundColor Cyan
    }
}

