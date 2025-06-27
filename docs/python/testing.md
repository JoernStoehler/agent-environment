# Python Testing Guide

## Overview

This guide covers Python-specific testing practices using pytest and related tools.

## Testing Tools

### Core Tools
- **pytest** - Modern test runner with powerful features
- **pytest-cov** - Coverage reporting integration
- **pytest-xdist** - Parallel test execution
- **pytest-asyncio** - Async test support
- **pytest-mock** - Enhanced mocking capabilities

### Installation
```bash
# Using uv (recommended)
uv add --dev pytest pytest-cov pytest-xdist pytest-asyncio pytest-mock

# Using pip
pip install pytest pytest-cov pytest-xdist pytest-asyncio pytest-mock
```

## Running Tests

### Basic Commands
```bash
# Run all tests
uv run pytest

# Run with coverage
uv run pytest --cov --cov-report=term-missing

# Run specific test file
uv run pytest tests/test_module.py

# Run specific test
uv run pytest tests/test_module.py::test_function

# Run tests matching pattern
uv run pytest -k "test_authentication"

# Run tests in parallel
uv run pytest -n auto

# Stop on first failure
uv run pytest -x

# Verbose output with print statements
uv run pytest -xvs

# Show local variables on failure
uv run pytest -l
```

### Coverage Analysis
```bash
# Generate HTML coverage report
uv run pytest --cov --cov-report=html

# View coverage in browser
open htmlcov/index.html

# Fail if coverage below threshold
uv run pytest --cov --cov-fail-under=80

# Coverage for specific module
uv run pytest --cov=mypackage tests/
```

## Test Structure

### Directory Layout
```
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── core.py
│       └── utils.py
├── tests/
│   ├── conftest.py      # Shared fixtures
│   ├── test_core.py
│   ├── test_utils.py
│   └── integration/
│       └── test_api.py
└── pyproject.toml
```

### Basic Test Example
```python
# tests/test_calculator.py
import pytest
from mypackage.calculator import Calculator, CalculatorError

class TestCalculator:
    """Test suite for Calculator class."""
    
    def test_addition(self):
        """Test basic addition."""
        calc = Calculator()
        assert calc.add(2, 3) == 5
    
    def test_division_by_zero(self):
        """Test that division by zero raises appropriate error."""
        calc = Calculator()
        with pytest.raises(CalculatorError, match="Cannot divide by zero"):
            calc.divide(10, 0)
    
    @pytest.mark.parametrize("a,b,expected", [
        (1, 1, 2),
        (0, 5, 5),
        (-1, 1, 0),
        (100, 200, 300),
    ])
    def test_addition_multiple_inputs(self, a, b, expected):
        """Test addition with various inputs."""
        calc = Calculator()
        assert calc.add(a, b) == expected
```

## Fixtures

### Basic Fixtures
```python
# conftest.py
import pytest
from pathlib import Path

@pytest.fixture
def temp_data_file(tmp_path):
    """Create a temporary data file for testing."""
    file_path = tmp_path / "test_data.json"
    file_path.write_text('{"test": "data"}')
    return file_path

@pytest.fixture
def sample_user():
    """Provide a sample user object."""
    return {
        "id": 1,
        "username": "testuser",
        "email": "test@example.com"
    }
```

### Fixture Scopes
```python
@pytest.fixture(scope="session")
def database_connection():
    """Database connection shared across all tests."""
    conn = create_connection()
    yield conn
    conn.close()

@pytest.fixture(scope="module")
def api_client():
    """API client shared within a module."""
    return APIClient(base_url="http://test.local")

@pytest.fixture(scope="function")  # Default
def clean_database():
    """Fresh database for each test."""
    setup_test_db()
    yield
    teardown_test_db()
```

### Parametrized Fixtures
```python
@pytest.fixture(params=["sqlite", "postgres"])
def db_backend(request):
    """Test with multiple database backends."""
    return setup_db(request.param)
```

## Mocking

### Using pytest-mock
```python
def test_api_call(mocker):
    """Test with mocked API calls."""
    # Mock external API
    mock_response = mocker.Mock()
    mock_response.json.return_value = {"status": "ok"}
    
    mocker.patch("requests.get", return_value=mock_response)
    
    # Test your code
    result = fetch_data("https://api.example.com")
    assert result["status"] == "ok"
```

### Mock Assertions
```python
def test_email_sent(mocker):
    """Test that email is sent correctly."""
    mock_send = mocker.patch("myapp.email.send_email")
    
    # Trigger email
    notify_user(user_id=123, message="Hello")
    
    # Verify email was sent
    mock_send.assert_called_once_with(
        to="user@example.com",
        subject="Notification",
        body="Hello"
    )
```

## Async Testing

### Basic Async Tests
```python
import pytest
import asyncio

@pytest.mark.asyncio
async def test_async_function():
    """Test async function."""
    result = await fetch_data_async()
    assert result is not None

@pytest.mark.asyncio
async def test_concurrent_requests():
    """Test multiple concurrent requests."""
    tasks = [fetch_user(i) for i in range(10)]
    results = await asyncio.gather(*tasks)
    assert len(results) == 10
```

### Async Fixtures
```python
@pytest.fixture
async def async_client():
    """Async client fixture."""
    client = AsyncAPIClient()
    await client.connect()
    yield client
    await client.disconnect()
```

## Test Organization

### Test Classes
```python
class TestUserAuthentication:
    """Group related authentication tests."""
    
    @pytest.fixture(autouse=True)
    def setup(self, db):
        """Setup run before each test in class."""
        self.db = db
        self.user = create_test_user()
    
    def test_valid_login(self):
        """Test login with valid credentials."""
        token = login(self.user.email, "password123")
        assert token is not None
    
    def test_invalid_password(self):
        """Test login with wrong password."""
        with pytest.raises(AuthenticationError):
            login(self.user.email, "wrongpass")
```

### Marks and Tags
```python
@pytest.mark.slow
def test_large_data_processing():
    """Test that processes large datasets."""
    # Long running test
    pass

@pytest.mark.integration
def test_external_api():
    """Test requiring external services."""
    pass

# Run only fast tests
# pytest -m "not slow"

# Run only integration tests
# pytest -m integration
```

## Advanced Patterns

### Property-Based Testing
```python
from hypothesis import given, strategies as st

@given(st.integers(), st.integers())
def test_addition_commutative(a, b):
    """Test that addition is commutative."""
    assert add(a, b) == add(b, a)

@given(st.lists(st.integers()))
def test_sort_idempotent(lst):
    """Test that sorting twice gives same result."""
    sorted_once = sorted(lst)
    sorted_twice = sorted(sorted_once)
    assert sorted_once == sorted_twice
```

### Test Helpers
```python
# tests/helpers.py
from contextlib import contextmanager

@contextmanager
def assert_logs_message(caplog, message, level="INFO"):
    """Assert that a specific log message is produced."""
    with caplog.at_level(level):
        yield
    assert message in caplog.text

# Usage in test
def test_logging(caplog):
    with assert_logs_message(caplog, "Processing started"):
        process_data()
```

### Database Testing
```python
@pytest.fixture
def db_session():
    """Provide a transactional database session."""
    connection = engine.connect()
    transaction = connection.begin()
    session = Session(bind=connection)
    
    yield session
    
    session.close()
    transaction.rollback()
    connection.close()

def test_user_creation(db_session):
    """Test creating a user in database."""
    user = User(name="Test User", email="test@example.com")
    db_session.add(user)
    db_session.commit()
    
    assert user.id is not None
    assert db_session.query(User).count() == 1
```

## Configuration

### pytest.ini
```ini
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    --strict-markers
    --verbose
    --cov=mypackage
    --cov-report=term-missing
markers =
    slow: marks tests as slow
    integration: marks tests as integration tests
    unit: marks tests as unit tests
```

### pyproject.toml
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = [
    "--strict-markers",
    "--verbose",
    "--cov=mypackage",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
]

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
precision = 2
show_missing = true
skip_covered = false
```

## Best Practices

### Test Naming
- Use descriptive names: `test_user_login_with_invalid_email_raises_error`
- Group related tests in classes
- Use docstrings to explain complex tests

### Test Independence
- Each test should be independent
- Use fixtures for setup/teardown
- Avoid test order dependencies

### Test Data
- Use factories or fixtures for test data
- Keep test data minimal but realistic
- Use meaningful values, not random strings

### Performance
- Use `pytest-xdist` for parallel execution
- Mark slow tests and run separately
- Mock external dependencies

### Debugging
- Use `pytest -s` to see print statements
- Use `pytest --pdb` to drop into debugger on failure
- Use `pytest -vv` for very verbose output

## Common Patterns

### Testing CLI Commands
```python
from click.testing import CliRunner

def test_cli_command():
    """Test CLI command execution."""
    runner = CliRunner()
    result = runner.invoke(cli, ['--name', 'Test'])
    
    assert result.exit_code == 0
    assert 'Hello Test' in result.output
```

### Testing with Environment Variables
```python
def test_with_env_vars(monkeypatch):
    """Test with modified environment."""
    monkeypatch.setenv("API_KEY", "test-key")
    monkeypatch.setenv("DEBUG", "true")
    
    config = load_config()
    assert config.api_key == "test-key"
    assert config.debug is True
```

### Testing File Operations
```python
def test_file_processing(tmp_path):
    """Test file reading and writing."""
    # Create test file
    input_file = tmp_path / "input.txt"
    input_file.write_text("test data")
    
    # Process file
    output_file = tmp_path / "output.txt"
    process_file(input_file, output_file)
    
    # Verify output
    assert output_file.exists()
    assert output_file.read_text() == "TEST DATA"
```