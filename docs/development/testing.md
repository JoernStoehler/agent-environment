# Testing Guidelines

## Overview

This document outlines general testing principles and practices for all projects, regardless of language.

## Test-Driven Development (TDD)

We follow strict TDD practices:

1. **Write tests first** - Before implementing any functionality
2. **Verify tests fail** - Ensure tests actually test the intended behavior
3. **Implement code** - Write minimal code to pass tests
4. **Refactor** - Clean up code while keeping tests green
5. **Add edge cases** - Ensure robustness with comprehensive tests

## General Testing Principles

### Test Organization
- Mirror source structure in test directories
- One test file per source module
- Group related tests together
- Use descriptive test names

### Test Independence
- Each test should run independently
- No dependencies between tests
- Clean state before and after each test
- Use fixtures/mocks for external dependencies

### Coverage Goals
- Aim for ≥80% code coverage
- 100% coverage for critical paths
- Focus on meaningful tests, not just coverage numbers

## Language-Specific Guidelines

### Python
See [Python Testing Guide](../python/testing.md) for detailed pytest examples and patterns.

### JavaScript/TypeScript
- **Test Runner**: Jest, Vitest, or Mocha
- **Structure**: `describe` blocks for grouping, `test`/`it` for individual tests
- **Assertions**: Built-in expect or assert libraries

### Go
- **Test Runner**: Built-in `go test`
- **Structure**: `Test*` functions in `*_test.go` files
- **Assertions**: Standard library or testify

### Other Languages
Follow the standard testing practices for your language's ecosystem.

## Best Practices

### Test Naming
- Use descriptive names that explain what is being tested
- Include the scenario and expected outcome
- Examples:
  - `test_user_login_with_valid_credentials_succeeds`
  - `should throw error when dividing by zero`
  - `TestCalculateTotal_WithDiscount_ReturnsCorrectAmount`

### Test Structure (AAA Pattern)
1. **Arrange** - Set up test data and environment
2. **Act** - Execute the code being tested
3. **Assert** - Verify the results

### What to Test
- Happy path scenarios
- Edge cases and boundaries
- Error conditions
- Invalid inputs
- Performance-critical paths

### What NOT to Test
- Third-party libraries
- Language built-ins
- Simple getters/setters
- Generated code

## Testing Patterns

### Unit Tests
- Test individual functions/methods in isolation
- Mock external dependencies
- Fast execution (milliseconds)
- Run frequently during development

### Integration Tests
- Test interaction between components
- Use real implementations where possible
- Slower than unit tests
- Test database operations, API calls, etc.

### End-to-End Tests
- Test complete user workflows
- Run in environment close to production
- Slowest but most comprehensive
- Catch integration issues

## Continuous Integration

Tests should run automatically on:
- Every commit
- Every pull request
- Before deployment
- Nightly for comprehensive suites

### CI Requirements
- All tests must pass
- Coverage must meet thresholds
- No linting errors
- No type checking errors

## Performance Testing

For performance-critical code:
- Establish baseline metrics
- Test with realistic data volumes
- Monitor for regressions
- Document performance requirements

## Security Testing

- Test authentication and authorization
- Validate all inputs
- Test for injection vulnerabilities
- Verify encryption and data protection

## Documentation

Good tests serve as documentation:
- Clear test names explain behavior
- Test cases show usage examples
- Comments explain complex scenarios
- Keep tests readable and maintainable