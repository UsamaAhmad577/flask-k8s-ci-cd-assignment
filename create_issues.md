# GitHub Issues to Create

Please create at least 2 issues on GitHub for this repository:

## Issue 1: Bug Fix - Fix Docker image build optimization
**Title:** Optimize Docker multi-stage build for better caching
**Type:** Bug Fix / Improvement
**Description:**
The current Dockerfile could benefit from better layer caching optimization. The COPY commands should be ordered to maximize cache hits during builds.

**Acceptance Criteria:**
- Reorder Dockerfile commands to copy requirements.txt before copying application code
- This will allow better caching when only application code changes

## Issue 2: Enhancement - Add health check endpoint
**Title:** Add dedicated health check endpoint for Kubernetes probes
**Type:** Enhancement / Testing
**Description:**
Currently, the Kubernetes liveness and readiness probes use the root endpoint (/). It would be better to have a dedicated /health endpoint that provides more detailed health information.

**Acceptance Criteria:**
- Create a new /health route in app.py
- Return JSON response with application status
- Update Kubernetes deployment.yaml to use /health endpoint for probes

## Issue 3: Workflow - Add Docker image scanning to CI pipeline
**Title:** Integrate Docker image vulnerability scanning in GitHub Actions
**Type:** Workflow / Security
**Description:**
Add security scanning for Docker images in the CI pipeline to detect vulnerabilities before deployment.

**Acceptance Criteria:**
- Add a security scanning step to .github/workflows/ci.yml
- Use a tool like Trivy or Snyk to scan the built Docker image
- Fail the build if critical vulnerabilities are found

## Issue 4: Testing - Add integration tests for Flask endpoints
**Title:** Expand test coverage with Flask application integration tests
**Type:** Testing
**Description:**
Currently, we only have unit tests for utility functions. We should add integration tests that test the actual Flask endpoints using pytest and Flask's test client.

**Acceptance Criteria:**
- Create test_flask_app.py in tests/ directory
- Test the root endpoint (/) returns correct response
- Use Flask's test client for testing
- Update CI pipeline to run integration tests

