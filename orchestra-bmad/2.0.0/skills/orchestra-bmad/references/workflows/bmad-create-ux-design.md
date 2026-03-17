# UX Design Specification Workflow — 14 Steps

**Goal:** Create comprehensive UX design specifications through collaborative visual exploration and informed decision-making.

**Your Role:** UX Facilitator working with the product stakeholder. You guide discovery, not generate content independently.

**CRITICAL RULES:**
- Execute ALL 14 steps in order — no skipping
- **Interactive mode** (Orchestrator as Sally): facilitate discovery with user, wait for confirmation at each step
- **Worker/autonomous mode** (dispatched via Agent tool): use PRD, product brief, and architecture as authoritative input. Make design decisions based on available context. Document rationale for each choice.
- Save content to output document progressively as steps complete
- Read ALL input documents completely before starting

**Output:** `{{PLANNING_ARTIFACTS}}/ux-design-specification.md`

---

## Step 1: Initialization (BAT BUOC)

### Fresh Workflow
1. Discover input documents:
   - Product Brief (`*brief*.md`)
   - PRD (`*prd*.md`)
   - Project Context (`**/project-context.md`)
   - Other docs in `{{PLANNING_ARTIFACTS}}/` and `docs/`
2. For sharded folders: load ALL files via index.md first
3. **Confirm with user** what was found + ask for additional docs
4. Load ALL confirmed documents completely (no offset/limit)
5. Create output document from template with frontmatter:
   ```yaml
   ---
   stepsCompleted: [1]
   inputDocuments: [list of loaded files]
   ---
   ```
6. Report to user: docs found, files loaded, ready to continue

### Continuation (if output doc already exists)
1. Read existing document + frontmatter
2. Reload all documents from `inputDocuments` array
3. Report progress to user, identify next step from `stepsCompleted`
4. Resume from where left off

**Validation Gate:** Output file created, input docs loaded, user confirmed setup.

---

## Step 2: Project Understanding (BAT BUOC)

### Discovery Sequence
1. **Review loaded context** — summarize key insights from PRD, briefs, other docs
2. **Present to user:** project vision, target users, key features/goals
3. **Fill gaps** — if docs missing key info, ask user directly:
   - What are you building? (1-2 sentences)
   - Who is this for?
   - What makes this special/different?
   - What's the main user action?
4. **Explore user context deeper:**
   - What problem are users solving?
   - What frustrates them with current solutions?
   - How tech-savvy are target users?
   - What devices will they use? When/where?
5. **Identify UX design challenges** — 2-3 key challenges + 2-3 design opportunities
6. **Generate content and present to user:**

### Output Structure (append to document)
```markdown
## Executive Summary

### Project Vision
[Vision summary from conversation]

### Target Users
[User descriptions from conversation]

### Key Design Challenges
[Challenges identified]

### Design Opportunities
[Opportunities identified]
```

**Validation Gate:** User confirms project understanding is accurate.

---

## Step 3: Core Experience Definition

### Discovery Sequence
1. **Define core user action:**
   - What's the ONE thing users do most frequently?
   - What action is critical to get right?
   - What should be completely effortless?
2. **Explore platform requirements:**
   - Web, mobile, desktop, or multi-platform?
   - Touch-based or mouse/keyboard?
   - Offline functionality needed?
   - Device-specific capabilities to leverage?
3. **Identify effortless interactions:**
   - What should feel natural and require zero thought?
   - Where do users struggle with similar products?
   - What can we eliminate vs competitors?
4. **Define critical success moments:**
   - When does the user realize "this is better"?
   - What interaction, if failed, ruins the experience?
   - Where does first-time user success happen?
5. **Synthesize experience principles** — 3-4 guiding principles from conversation

### Output Structure
```markdown
## Core User Experience

### Defining Experience
[Core experience definition]

### Platform Strategy
[Platform requirements and decisions]

### Effortless Interactions
[Areas that must be effortless]

### Critical Success Moments
[Make-or-break moments]

### Experience Principles
[Guiding UX principles]
```

**Validation Gate:** Core action identified, platform decided, principles established.

---

## Step 4: Desired Emotional Response

### Discovery Sequence
1. **Core emotional goals:** What should users FEEL? (Empowered? Delighted? Efficient? Calm? Connected?)
2. **Emotional journey mapping:** Feelings at discovery, during core action, after task completion, on error, on return
3. **Micro-emotions:** Confidence vs Confusion, Trust vs Skepticism, Excitement vs Anxiety, Accomplishment vs Frustration
4. **Connect emotions to UX decisions:** Each emotion maps to specific design approaches
5. **Validate:** Primary emotional goal, secondary feelings, emotions to avoid

### Output Structure
```markdown
## Desired Emotional Response

### Primary Emotional Goals
[Primary goals]

### Emotional Journey Mapping
[Journey across stages]

### Micro-Emotions
[Critical emotional states]

### Design Implications
[Emotion-to-design connections]

### Emotional Design Principles
[Guiding emotional principles]
```

---

## Step 5: UX Pattern Analysis & Inspiration

### Discovery Sequence
1. **Identify favorite apps** — 2-3 apps target users love and USE frequently
2. **Analyze each app:** Core problem solved, onboarding, navigation, innovative interactions, visual choices, error handling
3. **Extract transferable patterns:** Navigation, Interaction, Visual — categorized with relevance to project
4. **Identify anti-patterns to avoid** — confusing/frustrating patterns from competitors
5. **Define inspiration strategy:**
   - What to Adopt (supports core experience)
   - What to Adapt (modify for unique requirements)
   - What to Avoid (conflicts with goals)

### Output Structure
```markdown
## UX Pattern Analysis & Inspiration

### Inspiring Products Analysis
[Analysis per product]

### Transferable UX Patterns
[Categorized patterns]

### Anti-Patterns to Avoid
[Patterns to avoid with rationale]

### Design Inspiration Strategy
[Adopt / Adapt / Avoid strategy]
```

---

## Step 6: Design System Choice (BAT BUOC)

### Discovery Sequence
1. **Present options:**
   - Custom Design System — full uniqueness, higher investment
   - Established System (Material, Ant Design) — fast, proven, less differentiation
   - Themeable System (MUI, Chakra, Tailwind UI) — balance of speed and uniqueness
2. **Analyze project requirements:** platform, timeline, team size, brand requirements, technical constraints
3. **Explore specific options** for the chosen platform type
4. **Facilitate decision:** Speed vs uniqueness, team expertise, brand guidelines, maintenance needs
5. **Finalize choice** with clear rationale

### Output Structure
```markdown
## Design System Foundation

### Design System Choice
[Chosen system and description]

### Rationale for Selection
[Why this system]

### Implementation Approach
[How to implement]

### Customization Strategy
[What to customize]
```

**Validation Gate:** Design system chosen with rationale documented.

---

## Step 7: Defining Core Experience

### Discovery Sequence
1. **Identify the defining experience** — the core interaction that, if nailed, everything else follows
   - Famous examples: Tinder=swipe, Snapchat=disappearing photos, Spotify=play any song instantly
   - For this project: What will users describe to friends?
2. **Explore user's mental model:** How users currently solve this, expectations, confusion points
3. **Define success criteria:** What makes users say "this just works", how fast should it feel
4. **Novel vs established patterns:** Use proven patterns? Need innovation? Combine familiar in new ways?
5. **Experience mechanics — step by step:**
   - Initiation: How does user start?
   - Interaction: What does user do? How does system respond?
   - Feedback: How does user know it's working?
   - Completion: How do they know they're done?

### Output Structure
```markdown
## Core User Experience

### Defining Experience
[The one interaction that defines the product]

### User Mental Model
[How users think about this task]

### Success Criteria
[What makes the interaction successful]

### Novel UX Patterns
[Novel vs established pattern analysis]

### Experience Mechanics
[Step-by-step flow: initiation, interaction, feedback, completion]
```

---

## Step 8: Visual Foundation

### Discovery Sequence
1. **Brand guidelines assessment:** Existing brand? Colors? Fonts? If no, generate theme options
2. **Color system:** Brand colors or generated themes, semantic color mapping (primary, secondary, success, warning, error), accessibility (4.5:1 contrast)
3. **Typography system:**
   - Tone: Professional, friendly, modern, classic?
   - Content volume: Headings only or long-form?
   - Primary + secondary typefaces, type scale, line heights
4. **Spacing and layout:** Dense vs airy, base spacing unit (4px/8px/12px), grid system, white space approach
5. **Accessibility:** Color contrast ratios, touch targets (44x44px min), focus indicators

### Output Structure
```markdown
## Visual Design Foundation

### Color System
[Color strategy with semantic mapping]

### Typography System
[Typefaces, scale, hierarchy]

### Spacing & Layout Foundation
[Spacing system, grid, layout principles]

### Accessibility Considerations
[Contrast, targets, focus management]
```

---

## Step 9: Design Direction Mockups

### Discovery Sequence
1. **Generate 6-8 design direction variations** exploring different:
   - Layout approaches and information hierarchy
   - Interaction patterns and visual weights
   - Color applications, density, navigation arrangements
2. **Create visual showcase** — HTML file at `{{PLANNING_ARTIFACTS}}/ux-design-directions.html`
3. **Evaluation framework:**
   - Layout Intuitiveness — which hierarchy matches priorities?
   - Interaction Style — which fits core experience?
   - Visual Weight — which density feels right for brand?
   - Navigation Approach — matches user expectations?
   - Brand Alignment — supports emotional goals?
4. **Facilitate selection:** Pick favorite, combine elements, request modifications
5. **Document decision** with rationale

### Output Structure
```markdown
## Design Direction Decision

### Design Directions Explored
[Summary of directions explored]

### Chosen Direction
[Selected direction with key elements]

### Design Rationale
[Why this direction]

### Implementation Approach
[How to implement chosen direction]
```

---

## Step 10: User Journey Flows (BAT BUOC)

### Discovery Sequence
1. **Load PRD user journeys** as foundation — extract who/why from PRD, design how in detail
2. **For each critical journey, design flow:**
   - Entry point and trigger
   - Information needed at each step
   - Decision points and branches
   - Success and failure paths
   - Error recovery mechanisms
3. **Create Mermaid flow diagrams** for each journey
4. **Optimize for efficiency and delight:**
   - Minimize steps to value
   - Reduce cognitive load at decision points
   - Clear feedback and progress indicators
   - Moments of delight
   - Graceful error handling
5. **Extract journey patterns:** Navigation, Decision, Feedback patterns across flows

### Output Structure
```markdown
## User Journey Flows

### [Journey 1 Name]
[Description + Mermaid diagram]

### [Journey 2 Name]
[Description + Mermaid diagram]

### Journey Patterns
[Reusable patterns across journeys]

### Flow Optimization Principles
[Principles for efficient flows]
```

**Validation Gate:** All critical journeys have detailed flows with Mermaid diagrams.

---

## Step 11: Component Strategy

### Discovery Sequence
1. **Analyze design system coverage:** Available components vs needed components — identify gaps
2. **Design custom components** (for each gap):
   - Purpose, Content, Actions, States (default/hover/active/disabled/error)
   - Variants (sizes/styles), Accessibility (ARIA labels, keyboard), Interaction behavior
3. **Define component strategy:** Foundation (from design system) + Custom (designed here)
4. **Implementation roadmap:**
   - Phase 1: Core components (needed for critical flows)
   - Phase 2: Supporting components
   - Phase 3: Enhancement components

### Output Structure
```markdown
## Component Strategy

### Design System Components
[Available components analysis]

### Custom Components
[Specifications per custom component]

### Component Implementation Strategy
[Overall approach]

### Implementation Roadmap
[Phased rollout]
```

---

## Step 12: UX Consistency Patterns

### Discovery Sequence
1. **Identify pattern categories:** Button hierarchy, Feedback patterns, Form patterns, Navigation, Modals/overlays, Empty/loading states, Search/filtering
2. **Define each critical pattern:**
   - When to Use, Visual Design, Behavior
   - Accessibility, Mobile considerations, Variants
3. **Design system integration:** How patterns complement design system, what customizations needed
4. **Pattern documentation:** Usage guidelines, visual examples, implementation notes, a11y checklists

### Output Structure
```markdown
## UX Consistency Patterns

### Button Hierarchy
[Button patterns]

### Feedback Patterns
[Success, error, warning, info patterns]

### Form Patterns
[Form design patterns]

### Navigation Patterns
[Navigation patterns]

### Additional Patterns
[Other relevant patterns]
```

---

## Step 13: Responsive Design & Accessibility (BAT BUOC)

### Discovery Sequence
1. **Responsive strategy:**
   - Desktop: Multi-column? Side navigation? Content density?
   - Tablet: Simplified layouts? Touch optimization?
   - Mobile: Bottom nav or hamburger? Layout collapse? Critical info priority?
2. **Breakpoint strategy:** Mobile 320-767px, Tablet 768-1023px, Desktop 1024px+ (or custom)
3. **Accessibility strategy:**
   - WCAG Level: A (basic) / AA (recommended) / AAA (highest)
   - Color contrast (4.5:1 normal text), keyboard navigation, screen reader compatibility
   - Touch targets (44x44px min), focus indicators, skip links
4. **Testing strategy:**
   - Responsive: Device testing, browser testing, network performance
   - Accessibility: Automated tools, screen readers (VoiceOver/NVDA/JAWS), keyboard-only, color blindness
   - User testing: Users with disabilities, diverse assistive tech
5. **Implementation guidelines:**
   - Responsive: Relative units (rem, %, vw, vh), mobile-first media queries, optimized assets
   - Accessibility: Semantic HTML, ARIA labels/roles, keyboard nav, focus management, high contrast mode

### Output Structure
```markdown
## Responsive Design & Accessibility

### Responsive Strategy
[Per-device strategy]

### Breakpoint Strategy
[Breakpoints and layout changes]

### Accessibility Strategy
[WCAG level, key considerations]

### Testing Strategy
[Responsive + accessibility + user testing plan]

### Implementation Guidelines
[Developer guidelines for responsive + a11y]
```

**Validation Gate:** Responsive breakpoints defined, WCAG level chosen, testing plan documented.

---

## Step 14: Workflow Completion

### Completion Sequence
1. **Announce completion** — list all 13 content sections completed
2. **Verify completeness checklist:**
   - [ ] Executive summary and project understanding
   - [ ] Core experience and emotional response definition
   - [ ] UX pattern analysis and inspiration
   - [ ] Design system choice and strategy
   - [ ] Core interaction mechanics definition
   - [ ] Visual design foundation (colors, typography, spacing)
   - [ ] Design direction decisions and mockups
   - [ ] User journey flows and interaction design
   - [ ] Component strategy and specifications
   - [ ] UX consistency patterns documentation
   - [ ] Responsive design and accessibility strategy
3. **Update frontmatter:** `stepsCompleted: [1..14]`
4. **Report deliverables:**
   - UX Design Specification: `{{PLANNING_ARTIFACTS}}/ux-design-specification.md`
   - Color Themes (if generated): `{{PLANNING_ARTIFACTS}}/ux-color-themes.html`
   - Design Directions: `{{PLANNING_ARTIFACTS}}/ux-design-directions.html`
5. **Suggest next steps:**
   - Wireframe generation
   - Interactive prototype
   - Solution architecture
   - High-fidelity UI design
   - Epic creation

### Recommended Sequence
- Design-focused teams: Wireframes -> Prototypes -> Visual Design -> Development
- Technical teams: Architecture -> Epic Creation -> Development
