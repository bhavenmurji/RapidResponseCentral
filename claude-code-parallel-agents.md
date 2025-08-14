# Claude Code Parallel Agents Guide for SwiftUI Development

## Problem: Agents Running Sequentially Instead of Parallel

The issue you're experiencing is that when you invoke multiple agents in Claude Code, they run sequentially (one after another) instead of in parallel. Here's how to fix this:

## Solution: Parallel Agent Invocation Pattern

### 1. Single Message, Multiple Tasks Pattern

Instead of calling agents one by one, invoke ALL agents in a SINGLE message:

```markdown
# Parallel SwiftUI Development Task

I need to enhance the Emergency Protocol UI in RapidResponseCentral. Please coordinate these tasks in parallel:

## Task 1: Architecture Review (system-architect)
Review the current SwiftUI architecture in RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/ and suggest optimizations for the Emergency Protocol views. Focus on MVVM patterns, state management, and performance.

## Task 2: UI Enhancement (ui-designer)  
Improve the Emergency Protocol UI components with better accessibility, responsive layouts, and medical-grade design patterns. Update the visual hierarchy and user flow.

## Task 3: Data Model Updates (backend-architect)
Review and optimize the EmergencyProtocolService and related data models. Ensure proper concurrency handling with @MainActor and Sendable conformance.

## Task 4: Test Creation (tester)
Create comprehensive XCTest cases for the Emergency Protocol functionality, including UI tests and unit tests for the protocol services.

## Task 5: Performance Optimization (performance-benchmarker)
Analyze the current Emergency Protocol views for performance bottlenecks and suggest optimizations for memory usage and rendering performance.

## Task 6: Build Validation (production-validator)
Verify that all changes compile correctly and run the app in the iOS Simulator to ensure functionality.

**Coordination Instructions:**
- All tasks should run simultaneously
- Share findings through the coordination system
- Update the shared memory with results
- Coordinate any conflicting changes
```

### 2. BMAD Method Integration

Use the BMAD method structure in your parallel task:

```markdown
# BMAD Method Parallel Development

## B - Brainstorm (Parallel Ideation)
- **system-architect**: Brainstorm architecture improvements
- **ui-designer**: Brainstorm UI/UX enhancements  
- **trend-researcher**: Brainstorm feature ideas

## M - Map (Parallel Planning)
- **backend-architect**: Map data flow and services
- **devops-automator**: Map build and deployment pipeline

## A - Act (Parallel Implementation)
- **coder**: Implement SwiftUI improvements
- **rapid-prototyper**: Create rapid prototypes
- **mobile-app-builder**: Build native iOS features

## D - Decide (Parallel Validation)
- **tester**: Create and run tests
- **performance-benchmarker**: Validate performance
- **production-validator**: Validate builds and deployment

**Execute all phases simultaneously with cross-coordination.**
```

### 3. Contains Studio Agent Integration

Integrate Contains Studio agents for specialized tasks:

```markdown
# Parallel Development with Studio Agents

## Engineering Phase (Parallel)
- **rapid-prototyper**: Create Emergency Protocol UI prototypes
- **mobile-app-builder**: Implement native iOS features
- **backend-architect**: Optimize data models and services

## Design Phase (Parallel)  
- **brand-guardian**: Ensure medical app branding consistency
- **ui-designer**: Improve visual design and accessibility
- **ux-researcher**: Analyze user experience patterns

## Product Phase (Parallel)
- **feedback-synthesizer**: Analyze user feedback and suggest improvements
- **sprint-prioritizer**: Prioritize features and tasks
- **trend-researcher**: Research medical app trends

## Testing Phase (Parallel)
- **test-writer-fixer**: Write comprehensive tests
- **performance-benchmarker**: Optimize performance
- **tool-evaluator**: Evaluate development tools and processes

**All agents work simultaneously with shared memory coordination.**
```

## 4. Memory Coordination Setup

Set up shared memory for cross-agent communication:

```markdown
# Memory Coordination Setup

## Shared Architecture Memory
- Current SwiftUI architecture patterns
- Project structure and file organization
- Data flow and state management approach

## Shared Design Memory  
- Medical app design guidelines
- Accessibility requirements
- Brand consistency rules

## Shared Development Memory
- Build configuration and dependencies
- Testing strategies and frameworks
- Performance benchmarks and targets

## Shared Product Memory
- User feedback and feature requests
- Sprint priorities and timelines
- Success metrics and KPIs
```

## 5. Practical Example: Emergency Protocol Enhancement

Here's a complete example for enhancing your Emergency Protocol UI:

```markdown
# Emergency Protocol UI Enhancement - Parallel Development

## Context
Enhance the Emergency Protocol UI in RapidResponseCentral with better accessibility, performance, and user experience.

## Parallel Tasks (Execute Simultaneously)

### Architecture Task (system-architect)
Review `RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/Views/EmergencyHomeView.swift` and suggest MVVM improvements, state management optimizations, and architectural patterns.

### UI Design Task (ui-designer)
Improve the visual design of Emergency Protocol cards, enhance accessibility with VoiceOver support, and create responsive layouts for different screen sizes.

### Data Model Task (backend-architect)
Review `Services/EmergencyProtocolService.swift` and optimize the data models, ensure proper concurrency handling, and improve protocol loading performance.

### Testing Task (tester)
Create XCTest cases for Emergency Protocol functionality, including unit tests for services and UI tests for the protocol flow.

### Performance Task (performance-benchmarker)
Analyze memory usage and rendering performance of Emergency Protocol views, suggest optimizations for large protocol datasets.

### Validation Task (production-validator)
Build and test the app in iOS Simulator, verify all Emergency Protocol features work correctly, and check for any build issues.

## Coordination Instructions
- All tasks run in parallel
- Share findings through comments
- Coordinate any architectural changes
- Update shared memory with results
- Resolve conflicts through discussion
```

## 6. Troubleshooting Parallel Execution

### If agents still run sequentially:

1. **Use explicit parallel keywords**: Include "parallel", "simultaneous", "concurrent" in your prompts
2. **Group related tasks**: Put all tasks in a single message with clear separation
3. **Use coordination hooks**: Add instructions for agents to communicate with each other
4. **Set shared context**: Provide the same context to all agents so they can work independently

### Example coordination prompt:

```markdown
**IMPORTANT: Execute all tasks in parallel, not sequentially.**
**Each agent should work independently but coordinate through shared memory.**
**Do not wait for other agents to complete their tasks.**
```

## 7. Monitoring Parallel Execution

To verify agents are running in parallel:

1. **Check response timing**: Parallel execution should be faster than sequential
2. **Look for coordination**: Agents should reference each other's work
3. **Monitor memory updates**: Shared memory should be updated by multiple agents
4. **Verify independence**: Each agent should work on their specific task without waiting

## 8. Best Practices

1. **Clear task separation**: Each agent should have a distinct, non-overlapping task
2. **Shared context**: Provide the same project context to all agents
3. **Coordination instructions**: Tell agents how to work together
4. **Memory management**: Use shared memory for cross-agent communication
5. **Conflict resolution**: Establish how to handle conflicting changes

This approach should resolve your parallel execution issues and allow multiple agents to work simultaneously on your SwiftUI app development. 