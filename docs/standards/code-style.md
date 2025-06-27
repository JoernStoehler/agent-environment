# Code Style Guidelines

## General Principles

### Consistency
- Follow existing patterns in the codebase
- Use automated formatters to ensure consistency
- Agree on standards within the team

### Readability
- Code is read more often than written
- Prefer clarity over cleverness
- Use descriptive names over comments

### Simplicity
- **YAGNI**: Only implement what's needed now
- **KISS**: Keep solutions simple and straightforward
- **DRY**: Avoid duplication, but not at the cost of clarity

## Type Checking and Linting

### Type Safety
- Use static typing where available
- Enable strict type checking modes
- Document types for public APIs

### Linting
- Use language-appropriate linters
- Focus on bug prevention over style
- Automate linting in CI/CD

## Code Architecture

### Pure Functions
- Prefer pure functions with no side effects
- Make dependencies explicit
- Return errors/results rather than throwing when possible

### Immutability
- Prefer immutable data structures
- Avoid modifying arguments
- Use functional programming patterns where appropriate

### Error Handling
- Be explicit about error cases
- Use type-safe error handling (Result types, etc.)
- Document all exceptions/errors in public APIs

## Language-Specific Standards

### Python
See [Python Code Style Guide](../python/code-style.md) for detailed Python standards.

### JavaScript/TypeScript
- Use ESLint with a minimal ruleset
- Prefer TypeScript for type safety
- Follow standard naming conventions (camelCase)

### Go
- Follow standard Go conventions
- Use `go fmt` and `golangci-lint`
- Keep interfaces small

### Other Languages
Follow the standard style guide for your language:
- Java: Google Java Style Guide
- C++: Google C++ Style Guide
- Ruby: Ruby Style Guide
- Rust: Rust Style Guide

## File Organization

### Directory Structure
- Group by feature/domain, not by file type
- Keep related files close together
- Use clear, descriptive names

### File Naming
- Use language-appropriate conventions
- Be consistent within the project
- Prefer descriptive names over abbreviations

## Documentation

### Code Comments
- Explain "why" not "what"
- Document complex algorithms
- Keep comments up-to-date with code
- Remove commented-out code

### API Documentation
- Document all public interfaces
- Include examples for complex APIs
- Specify parameter types and return values
- Document error conditions

## Version Control

### Commit Messages
Follow conventional commits:
```
type(scope): subject

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code restructuring
- `test`: Test changes
- `chore`: Build/tooling changes

### Pull Requests
- Keep PRs focused and small
- Write clear descriptions
- Include tests for changes
- Respond to feedback promptly

## Security Best Practices

### Never Commit
- API keys or tokens
- Passwords or credentials
- Private keys or certificates
- Personal information

### Input Validation
- Validate all external input
- Use parameterized queries
- Sanitize user data
- Implement proper authentication

## Performance Considerations

### Optimization
- Profile before optimizing
- Document performance-critical code
- Prefer readable code over micro-optimizations
- Consider algorithmic complexity

### Resource Management
- Clean up resources properly
- Use connection pooling
- Implement proper caching
- Monitor memory usage

## Team Practices

### Code Reviews
- Review for correctness first
- Check for security issues
- Ensure tests are adequate
- Be constructive in feedback

### Pair Programming
- Share knowledge across team
- Catch issues early
- Improve code quality
- Build team cohesion

### Continuous Improvement
- Regularly review and update standards
- Learn from post-mortems
- Adopt new best practices
- Remove outdated patterns