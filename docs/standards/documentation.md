# Documentation Standards

## Documentation Philosophy

Documentation should:
- Lower cognitive load for future readers
- Persist derived thoughts and conclusions
- Guide Claude Code to relevant context quickly
- Explain "why" more than "what"
- Be written for both humans and AI assistants

## File Documentation

### Module/File Headers

Every significant file should start with a description:

#### Python Example
```python
"""User authentication and authorization module.

This module handles OAuth2 authentication with GitHub and manages
user sessions. It integrates with the FastAPI security system and
provides decorators for route protection.

Key components:
- OAuth2 flow implementation
- Session management with Redis
- Role-based access control
- Token refresh logic

Related files:
- models/user.py: User data models
- config/auth.py: Authentication configuration
- tests/test_auth.py: Comprehensive test suite
"""
```

#### JavaScript/TypeScript Example
```typescript
/**
 * Payment processing module
 * 
 * Handles payment transactions with multiple providers including
 * Stripe, PayPal, and direct bank transfers. Implements retry
 * logic and webhook handling.
 * 
 * @module payments
 * @see {@link config/payments.ts} - Payment provider configuration
 * @see {@link models/transaction.ts} - Transaction data models
 */
```

### README Files

Each significant directory should have a README.md:

```markdown
# Module Name

Brief description of what this module does.

## Structure

- `submodule1/` - Description
- `submodule2/` - Description
- `config/` - Configuration files

## Usage

Basic usage examples and common patterns.

## Dependencies

Key dependencies and why they're needed.

## Testing

How to run tests for this module.
```

## Function Documentation

### Comprehensive Docstrings

Include all relevant information:

```python
def calculate_compound_interest(
    principal: Decimal,
    rate: float,
    time: int,
    frequency: int = 12
) -> Dict[str, Decimal]:
    """Calculate compound interest with flexible compounding frequency.
    
    Uses the formula: A = P(1 + r/n)^(nt)
    Where:
        A = final amount
        P = principal (initial investment)
        r = annual interest rate (as decimal)
        n = compounding frequency per year
        t = time in years
    
    Args:
        principal: Initial investment amount in base currency units
        rate: Annual interest rate (0.05 for 5%)
        time: Investment period in years
        frequency: Compounding frequency (default: 12 for monthly)
            Common values: 1 (annual), 4 (quarterly), 12 (monthly),
            365 (daily), -1 (continuous)
    
    Returns:
        Dictionary containing:
            - 'final_amount': Total after interest
            - 'interest_earned': Interest portion only
            - 'effective_rate': Actual annual rate with compounding
    
    Raises:
        ValueError: If rate is negative or frequency is 0
        DecimalException: If calculation exceeds precision limits
    
    Example:
        >>> result = calculate_compound_interest(
        ...     principal=Decimal('1000'),
        ...     rate=0.05,
        ...     time=10
        ... )
        >>> print(f"Final: ${result['final_amount']:.2f}")
        Final: $1647.01
    
    Note:
        For continuous compounding (frequency=-1), uses formula A = Pe^(rt)
        All monetary values use Decimal for precision
    """
```

### Mathematical Documentation

When implementing mathematical concepts:

```python
def kalman_filter(
    x_prev: np.ndarray,
    P_prev: np.ndarray,
    z: np.ndarray,
    F: np.ndarray,
    H: np.ndarray,
    Q: np.ndarray,
    R: np.ndarray
) -> Tuple[np.ndarray, np.ndarray]:
    """Single step of Kalman filter algorithm.
    
    Implements the predictor-corrector equations:
    
    Prediction:
        x̂ₖ|ₖ₋₁ = Fₖ x̂ₖ₋₁|ₖ₋₁
        Pₖ|ₖ₋₁ = Fₖ Pₖ₋₁|ₖ₋₁ Fₖᵀ + Qₖ
    
    Update:
        Kₖ = Pₖ|ₖ₋₁ Hₖᵀ (Hₖ Pₖ|ₖ₋₁ Hₖᵀ + Rₖ)⁻¹
        x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + Kₖ(zₖ - Hₖ x̂ₖ|ₖ₋₁)
        Pₖ|ₖ = (I - Kₖ Hₖ) Pₖ|ₖ₋₁
    
    Args:
        x_prev: Previous state estimate x̂ₖ₋₁|ₖ₋₁
        P_prev: Previous error covariance Pₖ₋₁|ₖ₋₁
        z: Current measurement zₖ
        F: State transition matrix Fₖ
        H: Observation matrix Hₖ
        Q: Process noise covariance Qₖ
        R: Measurement noise covariance Rₖ
    
    Returns:
        Tuple of (x_est, P_est):
            x_est: Updated state estimate x̂ₖ|ₖ
            P_est: Updated error covariance Pₖ|ₖ
    
    References:
        Kalman (1960): "A New Approach to Linear Filtering"
        See also: https://www.kalmanfilter.net/equations.html
    """
```

## Code Comments

### When to Comment
- Complex algorithms or non-obvious logic
- Workarounds for library bugs
- Performance-critical sections
- External references and links
- TODO/FIXME items with context

### Comment Style
```python
# Calculate the checksum using CRC32
# See RFC 3309 for algorithm details
checksum = calculate_crc32(data)

# TODO(username): Optimize this loop for large datasets
# Current complexity: O(n²), target: O(n log n)
for item in items:
    process_item(item)

# HACK: Library bug workaround
# Remove when issue #123 is fixed in v2.0
# https://github.com/lib/issues/123
value = str(obj).replace('bug', 'fix')
```

## API Documentation

### Endpoint Documentation

```python
@app.post("/api/v1/users", response_model=UserResponse)
async def create_user(
    user: UserCreate,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin)
) -> UserResponse:
    """Create a new user account.
    
    Creates a user with the specified details and sends a
    verification email. Requires admin privileges.
    
    **Required permissions**: `users:write`, `admin`
    
    **Request body**:
    - `email`: Valid email address (unique)
    - `username`: Alphanumeric username (3-20 chars)
    - `password`: Strong password (min 8 chars)
    - `role`: User role (default: 'user')
    
    **Response**:
    - `id`: Generated user ID
    - `email`: User's email
    - `username`: User's username
    - `role`: Assigned role
    - `created_at`: Timestamp
    - `is_verified`: Email verification status
    
    **Errors**:
    - `400`: Invalid input data
    - `401`: Not authenticated
    - `403`: Insufficient permissions
    - `409`: Email/username already exists
    
    **Example**:
    ```bash
    curl -X POST /api/v1/users \\
      -H "Authorization: Bearer $TOKEN" \\
      -d '{"email": "user@example.com", "username": "newuser", "password": "SecurePass123!"}'
    ```
    """
```

## Project Documentation

### Main README.md

Structure your main README with:

1. **Project Title and Description**
2. **Quick Start**
3. **Installation**
4. **Usage Examples**
5. **Development Setup**
6. **Testing**
7. **Contributing**
8. **License**

### Architecture Documentation

Create `docs/architecture.md` for:
- System overview
- Component relationships
- Data flow diagrams
- Technology choices and rationale
- Scaling considerations

### CLAUDE.md

Essential file for Claude Code with:
- Quick reference commands
- Project-specific patterns
- Common tasks and workflows
- Important file locations
- Key architectural decisions

## Cross-References

### Internal References
```markdown
For implementation details, see @src/core/processor.py
Configuration options are in @config/settings.py
Related design decision: @docs/adr/001-caching-strategy.md
```

### External References
```markdown
We implement the [Circuit Breaker pattern](https://martinfowler.com/bliki/CircuitBreaker.html)
to handle service failures gracefully. The implementation follows
Fowler's recommendations with these modifications:
- Shortened timeout from 60s to 10s for faster recovery
- Added exponential backoff for retries
```

## Best Practices

1. **Write for your future self** - Include context you'll forget
2. **Document the why** - Code shows what, docs explain why
3. **Keep docs close to code** - Update both together
4. **Use examples** - Show, don't just tell
5. **Link liberally** - Connect related concepts
6. **Version documentation** - Note API/behavior changes