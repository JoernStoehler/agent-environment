# Python Code Style Guide

## Overview

This guide covers Python-specific coding standards and best practices for projects using modern Python tooling.

## Tooling

### Linting and Formatting
- **ruff** - Fast Python linter and formatter (replaces flake8, black, isort)
- **pyright** - Type checker (or mypy as alternative)

### Configuration
Add to `pyproject.toml`:
```toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # pyflakes
    "I",    # isort
    "N",    # pep8-naming
    "UP",   # pyupgrade
    "B",    # flake8-bugbear
    "SIM",  # flake8-simplify
    "TCH",  # flake8-type-checking
]
ignore = [
    "E501",  # line too long (handled by formatter)
]

[tool.pyright]
pythonVersion = "3.11"
typeCheckingMode = "standard"
reportPrivateImportUsage = false
```

## Import Organization

### Import Order
```python
# Standard library imports
import os
import sys
from datetime import datetime
from pathlib import Path

# Third-party imports
import numpy as np
import pandas as pd
from pydantic import BaseModel, Field

# Local application imports
from myapp.core import process_data
from myapp.models import User, Document
from myapp.utils.helpers import format_date
```

### Import Style
```python
# Good: Clear and specific
from myapp.authentication import authenticate_user, UserToken
from typing import List, Dict, Optional

# Avoid: Wildcard imports
from myapp.models import *  # Don't do this

# Good: Rename for clarity
from myapp.legacy.user_model import User as LegacyUser
```

## Type Annotations

### Basic Types
```python
def process_items(
    items: list[str],
    max_length: int = 100,
    validate: bool = True
) -> dict[str, Any]:
    """Process list of items with validation."""
    pass

# Use union types for flexibility
def parse_number(value: str | int | float) -> float:
    """Parse various number formats."""
    return float(value)
```

### Complex Types
```python
from typing import TypeAlias, TypedDict, Protocol

# Type aliases for clarity
UserId: TypeAlias = int
Username: TypeAlias = str
UserMap: TypeAlias = dict[UserId, Username]

# TypedDict for structured dicts
class UserData(TypedDict):
    id: UserId
    username: Username
    email: str
    is_active: bool

# Protocol for duck typing
class Drawable(Protocol):
    def draw(self) -> None: ...
```

### Generic Types
```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Repository(Generic[T]):
    """Generic repository pattern."""
    
    def __init__(self) -> None:
        self._items: list[T] = []
    
    def add(self, item: T) -> None:
        self._items.append(item)
    
    def get_all(self) -> list[T]:
        return self._items.copy()
```

## Functions and Methods

### Function Design
```python
def calculate_total(
    items: list[Item],
    *,  # Force keyword-only arguments
    include_tax: bool = True,
    tax_rate: float = 0.08,
    discount: float | None = None
) -> Decimal:
    """Calculate total price with optional tax and discount.
    
    Args:
        items: List of items to calculate
        include_tax: Whether to include tax in total
        tax_rate: Tax rate to apply (default: 8%)
        discount: Optional discount percentage
        
    Returns:
        Total price as Decimal for precision
        
    Raises:
        ValueError: If tax_rate or discount is negative
    """
    if tax_rate < 0:
        raise ValueError("Tax rate cannot be negative")
    
    subtotal = sum(item.price * item.quantity for item in items)
    
    if discount is not None:
        if discount < 0:
            raise ValueError("Discount cannot be negative")
        subtotal *= (1 - discount)
    
    if include_tax:
        subtotal *= (1 + tax_rate)
    
    return Decimal(str(subtotal)).quantize(Decimal("0.01"))
```

### Method Chaining
```python
class QueryBuilder:
    """Fluent interface for building queries."""
    
    def __init__(self) -> None:
        self._conditions: list[str] = []
        self._limit: int | None = None
    
    def where(self, condition: str) -> "QueryBuilder":
        """Add WHERE condition."""
        self._conditions.append(condition)
        return self
    
    def limit(self, count: int) -> "QueryBuilder":
        """Set result limit."""
        self._limit = count
        return self
    
    def build(self) -> str:
        """Build final query."""
        query = "SELECT * FROM table"
        if self._conditions:
            query += f" WHERE {' AND '.join(self._conditions)}"
        if self._limit:
            query += f" LIMIT {self._limit}"
        return query

# Usage
query = (
    QueryBuilder()
    .where("status = 'active'")
    .where("age > 18")
    .limit(10)
    .build()
)
```

## Classes

### Data Classes
```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class Article:
    """Article with automatic methods."""
    title: str
    content: str
    author: str
    tags: list[str] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.utcnow)
    views: int = 0
    
    def __post_init__(self) -> None:
        """Validate after initialization."""
        if not self.title:
            raise ValueError("Title cannot be empty")
    
    @property
    def reading_time(self) -> int:
        """Estimate reading time in minutes."""
        words = len(self.content.split())
        return max(1, words // 200)
```

### Pydantic Models
```python
from pydantic import BaseModel, Field, validator
from typing import Optional

class UserProfile(BaseModel):
    """User profile with validation."""
    username: str = Field(..., min_length=3, max_length=20)
    email: str = Field(..., regex=r'^[\w\.-]+@[\w\.-]+\.\w+$')
    age: Optional[int] = Field(None, ge=0, le=150)
    bio: str = Field("", max_length=500)
    
    @validator('username')
    def username_alphanumeric(cls, v: str) -> str:
        """Ensure username is alphanumeric."""
        if not v.replace('_', '').isalnum():
            raise ValueError('Username must be alphanumeric')
        return v
    
    class Config:
        # Pydantic configuration
        validate_assignment = True
        use_enum_values = True
```

## Error Handling

### Custom Exceptions
```python
class AppError(Exception):
    """Base application exception."""
    def __init__(self, message: str, code: str | None = None) -> None:
        super().__init__(message)
        self.code = code

class ValidationError(AppError):
    """Validation specific errors."""
    def __init__(self, field: str, message: str) -> None:
        super().__init__(f"{field}: {message}", code="VALIDATION_ERROR")
        self.field = field

class NotFoundError(AppError):
    """Resource not found errors."""
    def __init__(self, resource: str, id: Any) -> None:
        super().__init__(
            f"{resource} with id {id} not found",
            code="NOT_FOUND"
        )
```

### Error Handling Patterns
```python
from typing import Optional
import logging

logger = logging.getLogger(__name__)

def safe_divide(a: float, b: float) -> Optional[float]:
    """Safely divide with None on error."""
    try:
        return a / b
    except ZeroDivisionError:
        logger.warning(f"Division by zero: {a} / {b}")
        return None

# Using context managers for cleanup
from contextlib import contextmanager

@contextmanager
def managed_resource(path: Path):
    """Ensure resource cleanup."""
    resource = acquire_resource(path)
    try:
        yield resource
    except Exception as e:
        logger.error(f"Error with resource {path}: {e}")
        raise
    finally:
        release_resource(resource)
```

## Async Patterns

### Basic Async
```python
import asyncio
from typing import List

async def fetch_data(url: str) -> dict:
    """Fetch data from URL asynchronously."""
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

async def process_urls(urls: List[str]) -> List[dict]:
    """Process multiple URLs concurrently."""
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)
```

### Async Context Managers
```python
class AsyncDatabase:
    """Async database connection manager."""
    
    async def __aenter__(self) -> "AsyncDatabase":
        self.conn = await create_connection()
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb) -> None:
        await self.conn.close()
    
    async def query(self, sql: str) -> List[dict]:
        return await self.conn.fetch(sql)

# Usage
async def get_users() -> List[dict]:
    async with AsyncDatabase() as db:
        return await db.query("SELECT * FROM users")
```

## Best Practices

### Naming Conventions
```python
# Constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30.0
API_BASE_URL = "https://api.example.com"

# Classes: PascalCase
class UserAuthentication:
    pass

# Functions and variables: snake_case
def calculate_interest_rate(principal: float) -> float:
    interest_rate = 0.05
    return principal * interest_rate

# Private methods/attributes: leading underscore
class Service:
    def __init__(self):
        self._cache = {}
    
    def _internal_method(self) -> None:
        pass
```

### String Formatting
```python
# Use f-strings for formatting
name = "Alice"
age = 30
message = f"{name} is {age} years old"

# Multi-line f-strings
sql = f"""
    SELECT * FROM users
    WHERE age > {age}
    AND name = '{name}'
"""

# Format specifications
price = 19.99
formatted = f"Price: ${price:.2f}"
```

### Collections
```python
# List comprehensions for simple transformations
numbers = [1, 2, 3, 4, 5]
squares = [n ** 2 for n in numbers]
even_squares = [n ** 2 for n in numbers if n % 2 == 0]

# Dictionary comprehensions
word_lengths = {word: len(word) for word in ["hello", "world"]}

# Use generators for large datasets
def read_large_file(path: Path):
    """Read file line by line."""
    with open(path) as f:
        for line in f:
            yield line.strip()

# Named tuples for simple data
from collections import namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(10, 20)
```

### Context Managers
```python
from contextlib import contextmanager
import time

@contextmanager
def timer(name: str):
    """Time code execution."""
    start = time.time()
    print(f"Starting {name}...")
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{name} took {elapsed:.2f} seconds")

# Usage
with timer("data processing"):
    process_large_dataset()
```

## Common Patterns

### Builder Pattern
```python
class EmailBuilder:
    """Build emails with fluent interface."""
    
    def __init__(self) -> None:
        self._to: List[str] = []
        self._subject: str = ""
        self._body: str = ""
        self._attachments: List[Path] = []
    
    def to(self, *recipients: str) -> "EmailBuilder":
        self._to.extend(recipients)
        return self
    
    def subject(self, subject: str) -> "EmailBuilder":
        self._subject = subject
        return self
    
    def body(self, body: str) -> "EmailBuilder":
        self._body = body
        return self
    
    def attach(self, path: Path) -> "EmailBuilder":
        self._attachments.append(path)
        return self
    
    def build(self) -> Email:
        return Email(
            to=self._to,
            subject=self._subject,
            body=self._body,
            attachments=self._attachments
        )
```

### Repository Pattern
```python
from abc import ABC, abstractmethod

class UserRepository(ABC):
    """Abstract user repository."""
    
    @abstractmethod
    async def get(self, user_id: int) -> User | None:
        pass
    
    @abstractmethod
    async def save(self, user: User) -> None:
        pass

class PostgresUserRepository(UserRepository):
    """PostgreSQL implementation."""
    
    async def get(self, user_id: int) -> User | None:
        # Implementation
        pass
    
    async def save(self, user: User) -> None:
        # Implementation
        pass
```