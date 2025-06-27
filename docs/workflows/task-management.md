# Task Management Workflows

## Overview

Structured workflows ensure consistent, high-quality task completion. Choose the appropriate approach based on task complexity.

## Using the Todo Tool

The Todo tool is essential for task tracking and should be used proactively:

### When to Use
- **Complex multi-step tasks** - 3 or more distinct steps
- **Non-trivial tasks** - Require careful planning
- **Multiple tasks** - When given a list of things to do
- **After receiving instructions** - Capture requirements immediately

### When NOT to Use
- Single, straightforward tasks
- Trivial operations (<3 simple steps)
- Purely conversational/informational requests

### Example Usage
```python
# Create initial todos
TodoWrite(todos=[
    {"id": "1", "content": "Analyze existing code structure", 
     "status": "pending", "priority": "high"},
    {"id": "2", "content": "Implement new feature", 
     "status": "pending", "priority": "high"},
    {"id": "3", "content": "Write comprehensive tests", 
     "status": "pending", "priority": "medium"},
])

# Update as you progress
TodoWrite(todos=[
    {"id": "1", "content": "Analyze existing code structure", 
     "status": "completed", "priority": "high"},
    {"id": "2", "content": "Implement new feature", 
     "status": "in_progress", "priority": "high"},
    # ... other todos
])
```

## Task Workflow Templates

### Long Task Template

For complex, multi-step tasks requiring careful planning:

1. **Task Understanding**
   - Read task description carefully
   - Identify success criteria
   - Note any constraints or requirements
   - Ask for clarification if needed

2. **Context Exploration**
   - Search relevant files with Grep/Glob
   - Read key modules in parallel
   - Use Task() agents for complex searches
   - Document findings

3. **Planning**
   - Break down into manageable steps
   - Create comprehensive todo list
   - Consider edge cases and error handling
   - Plan testing approach

4. **Implementation**
   - Work through todos systematically
   - Update status in real-time
   - Test as you go
   - Handle errors gracefully

5. **Verification**
   - Run all tests
   - Check linting/type checking
   - Verify requirements met
   - Clean up any temporary code

6. **Completion**
   - Mark all todos complete
   - Submit PR if needed
   - Document any follow-up tasks

### Short Task Template

For straightforward, well-defined tasks:

1. **Read and understand** the task
2. **Explore** relevant code quickly
3. **Plan** with simple todo list
4. **Execute** the plan
5. **Verify** with tests
6. **Complete** and submit

## Best Practices

### Task Management
- **Frequent Updates**: Mark todos complete immediately after finishing
- **Granular Tasks**: Break large items into smaller, trackable pieces
- **Priority Focus**: Work on high-priority items first
- **Real-time Status**: Keep todos current as you work

### Planning
- Think through edge cases upfront
- Include testing in your plan
- Consider dependencies between tasks
- Add buffer for unexpected issues

### Communication
- Update todos before long operations
- Note blockers or issues in todo content
- Create new todos for discovered work
- Keep task descriptions clear and specific

## Common Patterns

### Feature Implementation
```
1. Research existing patterns
2. Design the solution
3. Implement core functionality
4. Add error handling
5. Write tests
6. Update documentation
7. Submit PR
```

### Bug Fix
```
1. Reproduce the issue
2. Identify root cause
3. Implement fix
4. Add regression test
5. Verify related functionality
6. Submit PR
```

### Refactoring
```
1. Understand current implementation
2. Identify improvement areas
3. Plan incremental changes
4. Refactor with tests passing
5. Optimize if needed
6. Update documentation
```

## Task States

- **pending**: Not yet started
- **in_progress**: Currently working (only ONE at a time)
- **completed**: Successfully finished

### Important Rules
- Only ONE task should be `in_progress` at any time
- Mark tasks complete IMMEDIATELY when done
- Never mark incomplete work as completed
- If blocked, keep as `in_progress` and note the issue

## Decision Guidelines

### Work Independently When
- Following established patterns
- Making localized changes
- Fixing obvious bugs
- Working within clear requirements

### Seek Clarification When
- Requirements are ambiguous
- Multiple valid approaches exist
- Changes affect core functionality
- Trade-offs need evaluation