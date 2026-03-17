# QA E2E Test Generation Workflow — Full Step-by-Step

**Goal:** Generate automated API and E2E tests for implemented code.

**Your Role:** QA automation engineer. Generate tests ONLY — no code review or story validation (use code-review workflow for that).

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in order; do NOT skip
- Use whatever test framework the project ALREADY has
- Tests must RUN and PASS before completion
- Focus on happy path + critical error cases — keep it simple

---

## Step 0: Detect Test Framework

### BAT BUOC: Use existing framework, do NOT introduce new ones unnecessarily

1. Check project for existing test framework:
   - `package.json` dependencies (playwright, jest, vitest, cypress, etc.)
   - Existing test files to understand patterns
   - Test configuration files (jest.config, vitest.config, playwright.config, etc.)

2. Use whatever test framework the project already has

3. If NO framework exists:
   - Analyze source code to determine project type (React, Vue, Node API, etc.)
   - Research current recommended test framework for that stack
   - Suggest the framework and confirm with user (or use it directly)

---

## Step 1: Identify Features to Test

ASK user what to test:
- Specific feature/component name
- Directory to scan (e.g., `src/components/`)
- Or auto-discover features in the codebase

For auto-discovery:
- Scan source directories for components, services, API endpoints
- Identify testable units
- Present discovery to user for confirmation

---

## Step 2: Generate API Tests (if applicable)

### BAT BUOC: Cover status codes and response structure

For API endpoints/services, generate tests that:

- [ ] Test status codes (200, 400, 404, 500)
- [ ] Validate response structure
- [ ] Cover happy path
- [ ] Cover 1-2 error cases
- [ ] Use project's existing test framework patterns
- [ ] Follow project's existing test file naming conventions

**Test structure per endpoint:**
```
describe('endpoint/feature', () => {
  test('happy path - returns expected data', ...)
  test('validation - rejects invalid input', ...)
  test('error - handles not found', ...)
})
```

---

## Step 3: Generate E2E Tests (if UI exists)

### BAT BUOC: Use semantic locators, test user workflows

For UI features, generate tests that:

- [ ] Test user workflows end-to-end
- [ ] Use semantic locators (roles, labels, text) — NOT css selectors or xpaths
- [ ] Focus on user interactions (clicks, form fills, navigation)
- [ ] Assert visible outcomes
- [ ] Keep tests linear and simple
- [ ] Follow project's existing test patterns

**Test principles:**
- Simulate real user behavior
- Assert what the user would see/experience
- No hardcoded waits or sleeps — use framework's built-in waiting
- Tests must be independent (no order dependency)

---

## Step 4: Run Tests

### BAT BUOC: All tests must PASS

1. Execute tests using project's test command
2. Verify all generated tests pass
3. If failures occur:
   - Diagnose the failure
   - Fix the test (not the code under test)
   - Re-run to confirm fix
   - If test reveals actual bug in code -> note it but do NOT fix production code

---

## Step 5: Create Summary

Save summary to: `{{IMPLEMENTATION_ARTIFACTS}}/tests/test-summary.md`

```markdown
# Test Automation Summary

## Generated Tests

### API Tests
- [x] tests/api/endpoint.spec.ts — Endpoint validation

### E2E Tests
- [x] tests/e2e/feature.spec.ts — User workflow

## Coverage
- API endpoints: X/Y covered
- UI features: X/Y covered

## Next Steps
- Run tests in CI
- Add more edge cases as needed
```

---

## Validation Checklist

### Test Generation
- [ ] API tests generated (if applicable)
- [ ] E2E tests generated (if UI exists)
- [ ] Tests use standard test framework APIs
- [ ] Tests cover happy path
- [ ] Tests cover 1-2 critical error cases

### Test Quality
- [ ] All generated tests run successfully
- [ ] Tests use proper locators (semantic, accessible)
- [ ] Tests have clear descriptions
- [ ] No hardcoded waits or sleeps
- [ ] Tests are independent (no order dependency)

### Output
- [ ] Test summary created
- [ ] Tests saved to appropriate directories
- [ ] Summary includes coverage metrics

---

## Keep It Simple

**Do:**
- Use standard test framework APIs
- Focus on happy path + critical errors
- Write readable, maintainable tests
- Run tests to verify they pass

**Avoid:**
- Complex fixture composition
- Over-engineering
- Unnecessary abstractions
- Testing implementation details (test behavior instead)
