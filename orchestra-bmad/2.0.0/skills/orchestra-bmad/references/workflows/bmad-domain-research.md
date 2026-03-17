# Domain/Industry Research Workflow — Full Step-by-Step

**Goal:** Conduct comprehensive domain and industry research using current web data and verified sources to produce a complete research document covering industry analysis, competitive landscape, regulatory environment, and technical trends.

**Your Role:** Domain research facilitator working with an expert partner. You bring research methodology and web search capabilities. The user brings domain knowledge and research direction.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in exact order; do NOT skip steps
- Web search is REQUIRED — if unavailable, HALT immediately
- NEVER generate domain claims without web search verification
- ALWAYS cite sources with URLs for factual claims
- Present conflicting information when sources disagree
- Apply confidence levels to uncertain data
- Continue until research is COMPLETE unless a HALT condition is triggered

**PREREQUISITE:** Web search capability must be available. If unavailable → HALT: "Cannot conduct domain research without web search access."

---

## Step 1: Topic Discovery and Scope Confirmation (BẮT BUỘC)

**Goal:** Understand and confirm the domain research topic, goals, and scope.

### 1.1 Topic Discovery

If topic not already provided:

"Let's get started with your domain/industry research. What domain, industry, or sector do you want to research?

For example:
- 'The healthcare technology industry'
- 'Sustainable packaging regulations in Europe'
- 'Construction and building materials sector'"

### 1.2 Topic Clarification

Based on the user's topic, clarify:
1. **Core Domain:** "What specific aspect of {{RESEARCH_TOPIC}} are you most interested in?"
2. **Research Goals:** "What do you hope to achieve with this research?"
3. **Scope:** "Should we focus broadly or dive deep into specific aspects?"

### 1.3 Scope Confirmation

Present clear scope:

"**Domain Research Scope Confirmation:**

For **{{RESEARCH_TOPIC}}**, I will research:

- **Industry Analysis** — market structure, key players, competitive dynamics
- **Competitive Landscape** — key players, market share, competitive strategies
- **Regulatory Requirements** — compliance standards, legal frameworks
- **Technology Trends** — innovation patterns, digital transformation
- **Economic Factors** — market size, growth projections, economic impact

**Research Methodology:**
- All claims verified against current public sources
- Multi-source validation for critical domain claims
- Confidence level framework for uncertain information

**Does this scope align with your goals?**"

### 1.4 Document Setup

Create output file at: `{{OUTPUT_PATH}}/research/domain-{{RESEARCH_TOPIC}}-research.md`

```yaml
---
research_type: domain
research_topic: "{{RESEARCH_TOPIC}}"
research_goals: "{{RESEARCH_GOALS}}"
date: "{{TIMESTAMP}}"
web_research_enabled: true
source_verification: true
---
```

### Validation Gate
- [ ] Research topic and goals clearly confirmed
- [ ] Domain research scope defined with user agreement
- [ ] Output document initialized

---

## Step 2: Industry Analysis (BẮT BUỘC)

**Goal:** Analyze market size, growth dynamics, market structure, and industry trends.

### 2.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} market size value"`
- `"{{RESEARCH_TOPIC}} market growth rate dynamics"`
- `"{{RESEARCH_TOPIC}} market segmentation structure"`
- `"{{RESEARCH_TOPIC}} industry trends evolution"`

### 2.2 Analysis Areas

#### Market Size and Valuation
- Total market size and current valuation
- Growth rate (CAGR) and market projections
- Key market segments by size and value
- Economic contribution and impact
- _Source: [URL]_

#### Market Dynamics and Growth
- Key factors driving market growth
- Factors limiting market expansion
- Industry seasonality and cycles
- Market maturity — life cycle stage and development phase
- _Source: [URL]_

#### Market Structure and Segmentation
- Primary segments and their characteristics
- Detailed sub-segment breakdown
- Geographic distribution and regional variations
- Vertical integration and value chain structure
- _Source: [URL]_

#### Industry Trends and Evolution
- Emerging trends and current developments
- Historical evolution over recent years
- Technology integration impact on the industry
- Future outlook and projected developments
- _Source: [URL]_

#### Competitive Dynamics
- Market concentration level and consolidation
- Competitive intensity and rivalry degree
- Barriers to entry for new market entrants
- Innovation pressure and rate of change
- _Source: [URL]_

### 2.3 Cross-Industry Analysis

Identify patterns connecting market dynamics, segmentation, and trends. Assess overall confidence levels and note research gaps.

### Validation Gate
- [ ] Market size and valuation analyzed with citations
- [ ] Growth dynamics and drivers documented
- [ ] Market structure and segmentation mapped
- [ ] Industry trends identified
- [ ] Competitive dynamics assessed
- [ ] Content written to document

---

## Step 3: Competitive Landscape (BẮT BUỘC)

**Goal:** Analyze key players, market share, competitive strategies, business models, and ecosystem dynamics.

### 3.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} key players market leaders"`
- `"{{RESEARCH_TOPIC}} market share competitive landscape"`
- `"{{RESEARCH_TOPIC}} competitive strategies differentiation"`
- `"{{RESEARCH_TOPIC}} entry barriers competitive dynamics"`

### 3.2 Analysis Areas

#### Key Players and Market Leaders
- Dominant players and their market positions
- Major competitors and their specialties
- Emerging players and innovative companies
- Global vs regional player distribution
- _Source: [URL]_

#### Market Share and Competitive Positioning
- Current market share breakdown
- How players position themselves in the market
- Value proposition mapping across players
- Customer segments served by competitor
- _Source: [URL]_

#### Competitive Strategies and Differentiation
- Cost leadership strategies — competing on price/efficiency
- Differentiation strategies — competing on unique value
- Focus/niche strategies — targeting specific segments
- Innovation approaches — how different players innovate
- _Source: [URL]_

#### Business Models and Value Propositions
- Primary business models — how competitors make money
- Revenue streams — different monetization approaches
- Value chain integration — vertical integration vs partnerships
- Customer relationship models — loyalty building approaches
- _Source: [URL]_

#### Competitive Dynamics and Entry Barriers
- Barriers to entry facing new market entrants
- Competitive intensity and rivalry pressure
- M&A activity and market consolidation trends
- Switching costs for customers
- _Source: [URL]_

#### Ecosystem and Partnership Analysis
- Key supplier partnerships and dependencies
- Distribution channels and market reach strategies
- Strategic technology alliances
- Ecosystem control — who controls key value chain parts
- _Source: [URL]_

### Validation Gate
- [ ] Key players identified with market share data
- [ ] Competitive positioning mapped
- [ ] Strategies and differentiation analyzed
- [ ] Business models documented
- [ ] Entry barriers and ecosystem dynamics assessed
- [ ] Content written to document

---

## Step 4: Regulatory Focus (BẮT BUỘC)

**Goal:** Analyze regulatory requirements, compliance frameworks, industry standards, and data protection considerations.

### 4.1 Targeted Web Research

Execute focused searches:
- `"{{RESEARCH_TOPIC}} regulations compliance requirements"`
- `"{{RESEARCH_TOPIC}} standards best practices"`
- `"data privacy regulations {{RESEARCH_TOPIC}}"`

### 4.2 Analysis Areas

#### Applicable Regulations
- Specific regulations applicable to the domain
- Regulatory bodies and enforcement agencies
- Recent regulatory changes and updates
- Geographic variations in regulatory requirements
- _Source: [URL]_

#### Industry Standards and Best Practices
- Industry-specific technical standards
- Best practices and guidelines
- Certification requirements
- Quality assurance frameworks
- _Source: [URL]_

#### Compliance Frameworks
- Applicable compliance frameworks (SOC2, PCI-DSS, ISO, etc.)
- Implementation requirements and timelines
- Audit and reporting requirements
- Compliance cost considerations
- _Source: [URL]_

#### Data Protection and Privacy
- GDPR, CCPA, and other data protection laws
- Industry-specific privacy requirements
- Data governance and security standards
- User consent and data handling requirements
- _Source: [URL]_

#### Licensing and Certification
- Required licenses for market operation
- Professional certifications relevant to the domain
- Accreditation requirements
- Renewal and maintenance obligations
- _Source: [URL]_

#### Implementation Considerations
- Practical steps for achieving compliance
- Common compliance challenges and pitfalls
- Resource requirements for compliance programs
- Timeline considerations for regulatory readiness

#### Regulatory Risk Assessment (BẮT BUỘC)
- Major regulatory risks identified
- Probability and impact assessment
- Mitigation strategies for each risk
- Monitoring and early warning indicators

### Validation Gate
- [ ] Applicable regulations identified with citations
- [ ] Industry standards documented
- [ ] Compliance frameworks mapped
- [ ] Data protection requirements analyzed
- [ ] Licensing requirements documented
- [ ] Risk assessment completed
- [ ] Content written to document

---

## Step 5: Technical Trends and Innovation (BẮT BUỘC)

**Goal:** Analyze emerging technologies, digital transformation impacts, innovation patterns, and future technology outlook for the domain.

### 5.1 Targeted Web Research

Execute focused searches:
- `"{{RESEARCH_TOPIC}} emerging technologies innovations"`
- `"{{RESEARCH_TOPIC}} digital transformation trends"`
- `"{{RESEARCH_TOPIC}} future outlook trends"`

### 5.2 Analysis Areas

#### Emerging Technologies
- AI, machine learning, and automation impacts
- New technologies disrupting the industry
- Innovation patterns and breakthrough developments
- Technology adoption rates and barriers
- _Source: [URL]_

#### Digital Transformation
- Digital adoption trends and rates
- Business model evolution driven by technology
- Customer experience innovations
- Operational efficiency improvements
- _Source: [URL]_

#### Innovation Patterns
- R&D investment trends in the domain
- Patent and intellectual property activity
- Startup ecosystem and venture capital trends
- Open source and collaboration patterns
- _Source: [URL]_

#### Future Outlook
- Technology roadmaps and projections
- Market evolution predictions
- Innovation pipelines and R&D trends
- Long-term industry transformation expectations
- _Source: [URL]_

#### Implementation Opportunities
- Technologies ready for immediate adoption
- Technologies requiring 1-2 year preparation
- Early-stage technologies for monitoring
- Build vs buy vs partner decisions

#### Challenges and Risks
- Technology adoption barriers
- Legacy system integration challenges
- Skill gaps and workforce readiness
- Security risks from new technologies

### 5.3 Recommendations

#### Technology Adoption Strategy
- Recommended technology adoption priorities
- Phased approach to technology transformation
- Resource allocation recommendations

#### Innovation Roadmap
- Near-term innovation opportunities (0-12 months)
- Medium-term strategic bets (1-3 years)
- Long-term vision and positioning (3-5 years)

#### Risk Mitigation
- Technology risk management strategies
- Contingency plans for adoption failures
- Vendor risk management approaches

### Validation Gate
- [ ] Emerging technologies identified with citations
- [ ] Digital transformation trends documented
- [ ] Innovation patterns analyzed
- [ ] Future outlook projections included
- [ ] Implementation opportunities and challenges mapped
- [ ] Recommendations provided
- [ ] Content written to document

---

## Step 6: Research Synthesis and Completion (BẮT BUỘC)

**Goal:** Produce the comprehensive domain research document with executive summary, cross-domain synthesis, strategic recommendations, and complete structure.

### 6.1 Additional Strategic Research

Execute targeted web search:
- `"{{RESEARCH_TOPIC}} significance importance"` — for narrative introduction context

### 6.2 Generate Complete Document Structure

Synthesize ALL research from Steps 2-5 into a comprehensive document:

#### Executive Summary (BẮT BUỘC)
- 2-3 paragraph compelling overview of key findings
- Key findings (4-5 most significant across all research areas)
- Top strategic recommendations (3-5 actionable)

#### Research Introduction and Methodology
- Compelling narrative about why {{RESEARCH_TOPIC}} research is critical now
- Research methodology description (scope, sources, analysis framework, time period, geographic coverage)
- Research goals achievement assessment

#### Industry Overview and Market Dynamics
- Market size and growth projections (from Step 2)
- Industry structure and value chain
- Market dynamics and competitive forces

#### Competitive Landscape and Ecosystem
- Market positioning and key players (from Step 3)
- Ecosystem and partnership landscape
- Competitive dynamics and entry barriers

#### Regulatory Framework and Compliance
- Current regulatory landscape (from Step 4)
- Risk and compliance considerations
- Implementation guidance

#### Technology Landscape and Innovation
- Current technology adoption (from Step 5)
- Digital transformation impact
- Future technology outlook

#### Cross-Domain Strategic Insights (BẮT BUỘC)
This is where the real value lives — connections between research areas:
- **Market-Technology Convergence:** How technology and market forces interact
- **Regulatory-Strategic Alignment:** How regulatory environment shapes strategy
- **Competitive Positioning Opportunities:** Strategic advantages based on research

#### Strategic Opportunities
- Market opportunities (entry, expansion, niche)
- Technology opportunities (adoption, innovation, differentiation)
- Partnership opportunities (collaboration, strategic alliances)

#### Implementation Considerations and Risk Assessment
- Implementation framework (timeline, resources, milestones)
- Risk management (implementation risks, market risks, technology risks)
- Contingency planning

#### Future Outlook and Strategic Planning
- Near-term (1-2 year) projections
- Medium-term (3-5 year) expected developments
- Long-term (5+ year) strategic outlook
- Immediate actions, strategic initiatives, long-term strategy recommendations

#### Research Methodology and Source Documentation
- Complete source documentation
- Research quality assurance and verification notes
- Confidence levels for uncertain data
- Research limitations and areas for further investigation

### 6.3 Document Quality Checks

- [ ] Executive summary is compelling and can stand alone
- [ ] All factual claims have source citations
- [ ] Cross-domain insights provide genuine strategic value
- [ ] Confidence levels noted for uncertain data
- [ ] No critical gaps in coverage
- [ ] Strategic recommendations are actionable
- [ ] Professional structure with clear narrative

### 6.4 Completion Communication

"Domain research for **{{RESEARCH_TOPIC}}** is complete!

**Research Document:** `{{OUTPUT_PATH}}/research/domain-{{RESEARCH_TOPIC}}-research.md`

**Key Deliverables:**
- Industry analysis with market size and dynamics
- Competitive landscape and ecosystem analysis
- Regulatory framework and compliance requirements
- Technical trends and innovation landscape
- Cross-domain strategic insights and recommendations

**Recommended next steps:**
- Use research to inform product brief or PRD creation
- Conduct deeper research on specific areas if needed
- Move forward with implementation based on strategic recommendations"

---

## HALT Conditions

- Web search unavailable → HALT: "Cannot conduct domain research without web search"
- Research topic too broad and user unable to narrow → HALT with clarification request
- Critical data gaps that cannot be filled → HALT with explanation of what's missing

## Quality Standards

- Always cite URLs for web search results
- Use authoritative sources (market research firms, industry associations, government data, regulatory agencies)
- Note data currency and potential limitations
- Present multiple perspectives when sources conflict
- Apply confidence levels: High (multiple authoritative sources), Medium (single reliable source), Low (limited/dated sources)
- Focus on actionable insights, not just data presentation
- Cross-domain synthesis should reveal connections that individual sections don't
