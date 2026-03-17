# Generate Project Context Workflow — Full Step-by-Step

**Goal:** Create a concise, LLM-optimized `project-context.md` file containing critical rules, patterns, and guidelines that AI agents MUST follow when implementing code. Focus on unobvious details that agents need to be reminded of.

**Your Role:** Technical facilitator working with a peer to capture essential implementation rules that ensure consistent, high-quality code generation across all AI agents working on the project.

**CRITICAL RULES (NO EXCEPTIONS):**
- Keep content LEAN — optimize for LLM context efficiency
- Focus on unobvious rules agents might miss (not generic advice)
- Each rule must be specific and actionable
- Verify exact technology versions from actual project files
- Collaborative discovery — facilitate, do NOT generate without user input

---

## Step 1: Context Discovery & Initialization (BẮT BUỘC)

### 1.1 Check for Existing Project Context

Search for `**/project-context.md` in project:
- If exists: read complete file, present to user with section count
- Ask: "Update existing or create new?"

### 1.2 Discover Project Technology Stack

**Architecture Document:**
- Load `{{PLANNING_ARTIFACTS}}/architecture.md` if exists
- Extract technology choices with specific versions
- Note architectural decisions affecting implementation

**Package Files:**
- Check `package.json`, `requirements.txt`, `Cargo.toml`, etc.
- Extract exact versions of ALL dependencies
- Note dev vs production dependencies

**Configuration Files:**
- Language configs (tsconfig.json, pyproject.toml, etc.)
- Build tool configs (webpack, vite, next.config.js)
- Linting/formatting configs (.eslintrc, .prettierrc)
- Testing configs (jest.config.js, vitest.config.ts)

### 1.3 Identify Existing Code Patterns

Search codebase for:
- **Naming conventions:** file naming, component/function/variable naming, test file naming
- **Code organization:** component structure, utility placement, service organization
- **Documentation patterns:** comment styles, doc requirements

### 1.4 Extract Critical Implementation Rules

Look for rules AI agents might miss:
- **Language-specific:** strict mode, import/export conventions, async patterns, error handling
- **Framework-specific:** hooks usage, API route conventions, middleware, state management
- **Testing:** test structure, mock conventions, coverage requirements, test boundaries
- **Workflow:** branch naming, commit patterns, PR requirements, deployment

### 1.5 Initialize Document

If fresh: create `{{OUTPUT_FOLDER}}/project-context.md` from template:
```markdown
# Project Context for AI Agents

_Critical rules and patterns AI agents must follow when implementing code._

---
```

### 1.6 Present Discovery Summary

Report to user:
- Technology stack discovered (with versions)
- Number of patterns, conventions, and rules found
- Key areas for context rules

**GATE:** Wait for user confirmation before proceeding.

---

## Step 2: Context Rules Generation (BẮT BUỘC)

Generate rules for each category collaboratively. For each category: present findings, get user feedback, save approved content.

### 2.1 Technology Stack & Versions

Document exact technology stack from discovery:
- Core technologies with exact versions
- Key dependencies with versions
- Version constraints or compatibility notes

### 2.2 Language-Specific Rules

Focus on UNOBVIOUS patterns agents might miss:
- Configuration requirements (strict mode, compiler options)
- Import/export conventions (barrel exports, path aliases)
- Error handling patterns specific to the project
- Async patterns (Promise vs async/await conventions)

### 2.3 Framework-Specific Rules

Document framework patterns:
- Hooks/composable usage patterns
- Component structure conventions
- State management patterns
- Performance optimization requirements
- Routing conventions

### 2.4 Testing Rules

Ensure consistent testing:
- Test organization (co-located vs separate)
- Mock usage conventions
- Coverage requirements
- Integration vs unit test boundaries
- Test naming patterns

### 2.5 Code Quality & Style Rules

- Linting/formatting configuration requirements
- File and folder structure rules
- Naming conventions agents MUST follow
- Documentation and comment patterns

### 2.6 Development Workflow Rules

- Branch naming conventions
- Commit message format
- PR requirements and checklist
- Deployment patterns and considerations

### 2.7 Critical Don't-Miss Rules (BẮT BUỘC)

Identify rules that prevent common mistakes:
- **Anti-patterns to avoid** — with concrete examples
- **Edge cases** agents should handle
- **Security rules** — specific to this project
- **Performance gotchas** — patterns to avoid

### 2.8 Save Each Category

After user approves each category, append to project-context.md.

---

## Step 3: Completion & Finalization

### 3.1 Review Complete File

Analyze the full project-context.md for:
- Total length and LLM readability
- Clarity and specificity of rules
- Coverage of all critical areas
- No redundant or obvious information

### 3.2 Optimize for LLM Context

- Remove redundant rules or obvious information
- Combine related rules into concise bullet points
- Use specific, actionable language
- Ensure each rule provides unique value
- Use consistent markdown formatting
- Strategic bolding for scannability

### 3.3 Add Usage Guidelines

Append to document:
```markdown
---

## Usage Guidelines

**For AI Agents:**
- Read this file before implementing any code
- Follow ALL rules exactly as documented
- When in doubt, prefer the more restrictive option

**For Humans:**
- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules

Last Updated: {{DATE}}
```

### 3.4 Update Frontmatter

```yaml
---
project_name: '{{PROJECT_NAME}}'
date: '{{DATE}}'
status: 'complete'
optimized_for_llm: true
---
```

### 3.5 Present Completion

Report:
- Rule count and section count
- File saved location
- Key benefits (consistent implementation, reduced errors)
- Next steps (agents read before implementing, update as project evolves)

---

## Quality Checklist (BẮT BUỘC — verify before completion)

- [ ] All critical technology versions documented from actual project files
- [ ] Language-specific rules cover unobvious patterns (not generic advice)
- [ ] Framework rules capture project-specific conventions
- [ ] Testing rules ensure consistent test quality
- [ ] Code quality rules maintain project standards
- [ ] Anti-patterns documented with concrete examples
- [ ] Content is LEAN — no redundant or obvious information
- [ ] Every rule is specific and actionable
- [ ] File saved to `{{OUTPUT_FOLDER}}/project-context.md`
