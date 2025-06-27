# Development Principles

## Core Principles for Claude Code Development

### 1. Low Cognitive Load While Reading Files

- Write in clear, unambiguous, specific language
- Explicitly spell out implications, consequences, assumptions, and reasoning
- Use common, standard, simple solutions that are intuitive and well-known for senior developers
- Note choices where there is no single common solution
- Document project idiosyncrasies
- Use longer-than-usual file paths and symbol names for clarity
- Write detailed docstrings to persist derived thoughts and conclusions

### 2. Associative Recall Across Long Context

Claude Code's capabilities:
- Can recall all files read in the current session verbatim
- Context window of 200,000 tokens (~100,000 words)
- Perfect recall enables verbosity when it improves clarity

Best practices:
- Use associative structures to group related information
- Spell out situations and conditions for relevance
- Make implications and consequences explicit
- Recommend further readings and related concepts
- Highlight [IMPORTANT] information
- Avoid ambiguities and vagueness

### 3. Use Common, Standard Solutions

- Leverage Claude Code's familiarity with standard patterns
- Communicate explicitly when deviating from standards
- Document version-specific API details when libraries have changed
- Place files and symbols in their expected locations
- Document complex solutions in detail, even if standard

### 4. Optimize for Ultra-Fast Exploration

Claude Code starts each session with no context. Optimize for rapid context gathering:
- Use descriptive file and folder names
- Include in-file references to related code
- Prefer moderately short, single-topic files
- Group related information together
- Use @references in CLAUDE.md for mandatory initial context
- Use markdown links for optional/situational context

### 5. Assume Domain Expertise

Claude Code has broad knowledge across domains. You can assume familiarity with:
- Professional terminology
- Common concepts from all domains
- Project management workflows (SMART goals, OKRs, ADRs, RFCs)
- Software engineering best practices

Work best by:
- Focusing on single narrow tasks
- Using sequential task series when combining multiple tasks
- Documenting workflow checklists for common meta-tasks
- Structuring work around established project management concepts

## Practical Application

### File Organization
```
project/
├── src/           # Source code with clear module names
├── tests/         # Mirror src structure
├── docs/          # Comprehensive documentation
├── scripts/       # Utility scripts with READMEs
└── CLAUDE.md      # Entry point with key references
```

### Naming Conventions
- Prefer clarity over brevity: `user_authentication_handler.py` over `auth.py`
- Use full words: `calculate_monthly_revenue()` over `calc_rev()`
- Be explicit: `is_valid_email_address()` over `validate()`

### Documentation Style
```python
def process_payment(
    amount: Decimal,
    currency: str,
    payment_method: PaymentMethod
) -> Union[PaymentResult, PaymentError]:
    """Process a payment transaction with retry logic.
    
    Implements the payment flow described in RFC-123, with
    automatic retry for transient failures. Uses exponential
    backoff with jitter as recommended by AWS.
    
    Args:
        amount: Payment amount in smallest currency unit (cents)
        currency: ISO 4217 currency code (e.g., 'USD', 'EUR')
        payment_method: Validated payment method object
        
    Returns:
        PaymentResult on success, PaymentError on failure
        
    Related:
        - src/payments/validation.py: Payment method validation
        - docs/architecture/payment-flow.md: Full flow diagram
        - tests/test_payment_retry.py: Retry behavior tests
    """
    # Implementation
```