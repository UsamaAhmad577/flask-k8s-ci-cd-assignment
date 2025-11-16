# PowerShell script to create GitHub issues
# Usage: Set $GITHUB_TOKEN environment variable or replace the token below
# Then run: .\create_issues.ps1

$REPO_OWNER = "UsamaAhmad577"
$REPO_NAME = "flask-k8s-ci-cd-assignment"
$GITHUB_TOKEN = $env:GITHUB_TOKEN

if (-not $GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN environment variable not set."
    Write-Host "Please set it using: `$env:GITHUB_TOKEN = 'your_token_here'"
    exit 1
}

$headers = @{
    "Authorization" = "token $GITHUB_TOKEN"
    "Accept" = "application/vnd.github.v3+json"
}

$baseUrl = "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues"

# Issue 1: Docker build optimization
$issue1 = @{
    title = "Optimize Docker multi-stage build for better caching"
    body = @"
**Type:** Bug Fix / Improvement

**Description:**
The current Dockerfile could benefit from better layer caching optimization. The COPY commands should be ordered to maximize cache hits during builds.

**Acceptance Criteria:**
- Reorder Dockerfile commands to copy requirements.txt before copying application code
- This will allow better caching when only application code changes
"@
    labels = @("bug", "enhancement")
} | ConvertTo-Json

Write-Host "Creating Issue 1: Docker build optimization..."
try {
    $response1 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $issue1 -ContentType "application/json"
    Write-Host "Created issue #$($response1.number): $($response1.title)" -ForegroundColor Green
} catch {
    Write-Host "Error creating issue 1: $_" -ForegroundColor Red
}

# Issue 2: Health check endpoint
$issue2 = @{
    title = "Add dedicated health check endpoint for Kubernetes probes"
    body = @"
**Type:** Enhancement / Testing

**Description:**
Currently, the Kubernetes liveness and readiness probes use the root endpoint (/). It would be better to have a dedicated /health endpoint that provides more detailed health information.

**Acceptance Criteria:**
- Create a new /health route in app.py
- Return JSON response with application status
- Update Kubernetes deployment.yaml to use /health endpoint for probes
"@
    labels = @("enhancement", "testing")
} | ConvertTo-Json

Write-Host "Creating Issue 2: Health check endpoint..."
try {
    $response2 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $issue2 -ContentType "application/json"
    Write-Host "Created issue #$($response2.number): $($response2.title)" -ForegroundColor Green
} catch {
    Write-Host "Error creating issue 2: $_" -ForegroundColor Red
}

# Issue 3: Docker image scanning
$issue3 = @{
    title = "Integrate Docker image vulnerability scanning in GitHub Actions"
    body = @"
**Type:** Workflow / Security

**Description:**
Add security scanning for Docker images in the CI pipeline to detect vulnerabilities before deployment.

**Acceptance Criteria:**
- Add a security scanning step to .github/workflows/ci.yml
- Use a tool like Trivy or Snyk to scan the built Docker image
- Fail the build if critical vulnerabilities are found
"@
    labels = @("workflow", "security")
} | ConvertTo-Json

Write-Host "Creating Issue 3: Docker image scanning..."
try {
    $response3 = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $issue3 -ContentType "application/json"
    Write-Host "Created issue #$($response3.number): $($response3.title)" -ForegroundColor Green
} catch {
    Write-Host "Error creating issue 3: $_" -ForegroundColor Red
}

Write-Host "`nDone! Created issues on GitHub." -ForegroundColor Green

