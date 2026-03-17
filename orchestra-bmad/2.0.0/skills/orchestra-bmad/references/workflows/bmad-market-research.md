# Market Research Workflow — Full Step-by-Step

**Goal:** Conduct comprehensive market research using current web data and verified sources to produce a complete research document with compelling narratives, proper citations, and strategic recommendations.

**Your Role:** Market research facilitator working with an expert partner. You bring research methodology and web search capabilities. The user brings domain knowledge and research direction.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in exact order; do NOT skip steps
- Web search is REQUIRED — if unavailable, HALT immediately
- NEVER generate market data without web search verification
- ALWAYS cite sources with URLs for factual claims
- Present conflicting information when sources disagree
- Apply confidence levels to uncertain data
- Continue until research is COMPLETE unless a HALT condition is triggered

**PREREQUISITE:** Web search capability must be available. If unavailable → HALT: "Cannot conduct market research without web search access."

---

## Step 1: Topic Discovery and Scope Confirmation (BẮT BUỘC)

**Goal:** Understand and confirm the market research topic, goals, and scope.

### 1.1 Topic Discovery

If topic not already provided:

"Let's get started with your market research. What topic, problem, or area do you want to research?

For example:
- 'The electric vehicle market in Europe'
- 'Plant-based food alternatives market'
- 'Mobile payment solutions in Southeast Asia'"

### 1.2 Topic Clarification

Based on the user's topic, clarify:
1. **Core Topic:** "What exactly about {{RESEARCH_TOPIC}} are you most interested in?"
2. **Research Goals:** "What do you hope to achieve with this research?"
3. **Scope:** "Should we focus broadly or dive deep into specific aspects?"

### 1.3 Scope Confirmation

Present clear scope:

"**Market Research Scope Confirmation:**

For **{{RESEARCH_TOPIC}}**, I will research:

- **Market Size & Dynamics** — size, growth projections, market structure
- **Customer Insights** — behavior patterns, demographics, psychographics
- **Customer Pain Points** — challenges, unmet needs, barriers to adoption
- **Customer Decisions** — decision processes, journey mapping, influencers
- **Competitive Landscape** — key players, positioning, differentiation

**Research Methodology:**
- Current web data with source verification
- Multiple independent sources for critical claims
- Confidence level assessment for uncertain data

**Does this scope align with your goals?**"

### 1.4 Document Setup

Create output file at: `{{OUTPUT_PATH}}/research/market-{{RESEARCH_TOPIC}}-research.md`

```yaml
---
research_type: market
research_topic: "{{RESEARCH_TOPIC}}"
research_goals: "{{RESEARCH_GOALS}}"
date: "{{TIMESTAMP}}"
web_research_enabled: true
source_verification: true
---
```

### Validation Gate
- [ ] Research topic and goals clearly confirmed
- [ ] Market research scope defined with user agreement
- [ ] Output document initialized

---

## Step 2: Customer Behavior and Segments (BẮT BUỘC)

**Goal:** Analyze customer behavior patterns, demographics, psychographics, and segment profiles.

### 2.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} customer behavior patterns"`
- `"{{RESEARCH_TOPIC}} customer demographics"`
- `"{{RESEARCH_TOPIC}} psychographic profiles"`
- `"{{RESEARCH_TOPIC}} customer behavior drivers"`

### 2.2 Analysis Areas

For each area, document with source citations:

#### Customer Behavior Patterns
- Behavior drivers and key motivations
- Interaction preferences and engagement patterns
- Decision habits and typical decision-making approaches

#### Demographic Segmentation
- Age demographics and preferences
- Income levels and purchasing behavior
- Geographic distribution and regional differences
- Education level impact on behavior

#### Psychographic Profiles
- Values and beliefs driving customer behavior
- Lifestyle preferences and choices
- Attitudes and opinions toward products/services
- Personality traits influencing behavior

#### Customer Segment Profiles
- Segment 1: detailed profile (demographics + psychographics + behavior)
- Segment 2: detailed profile
- Segment 3: detailed profile
- (Add more as data supports)

#### Behavior Drivers and Influences
- Emotional drivers and factors
- Rational decision factors
- Social and peer influences
- Economic factors affecting behavior

#### Customer Interaction Patterns
- Research and discovery methods
- Purchase decision process stages
- Post-purchase behavior and engagement
- Loyalty and retention factors

### 2.3 Cross-Behavior Analysis

Identify patterns connecting demographics, psychographics, and behaviors. Note confidence levels and research gaps.

### Validation Gate
- [ ] Customer behavior patterns identified with citations
- [ ] Demographic segmentation analyzed
- [ ] Psychographic profiles documented
- [ ] Customer segments defined with profiles
- [ ] Behavior drivers and interaction patterns captured
- [ ] Content written to document

---

## Step 3: Customer Pain Points and Needs (BẮT BUỘC)

**Goal:** Analyze customer challenges, frustrations, unmet needs, and barriers to adoption.

### 3.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} customer pain points challenges"`
- `"{{RESEARCH_TOPIC}} customer frustrations"`
- `"{{RESEARCH_TOPIC}} unmet customer needs"`
- `"{{RESEARCH_TOPIC}} customer barriers to adoption"`

### 3.2 Analysis Areas

#### Customer Challenges and Frustrations
- Primary frustrations identified
- Usage barriers preventing effective adoption
- Service and support pain points
- Frequency analysis — how often these occur

#### Unmet Customer Needs
- Critical unaddressed needs
- Solution gaps and opportunities
- Market gaps from unmet needs
- Priority analysis — which needs are most critical

#### Barriers to Adoption
- Price barriers — cost-related obstacles
- Technical barriers — complexity issues
- Trust barriers — credibility concerns
- Convenience barriers — accessibility and ease-of-use issues

#### Service and Support Pain Points
- Customer service problems
- Support gaps and areas lacking
- Communication breakdowns
- Response time and resolution issues

#### Customer Satisfaction Gaps
- Expectation vs reality differences
- Quality perception gaps
- Value perception misalignment
- Trust and credibility gaps

#### Emotional Impact Assessment
- Frustration severity levels
- Loyalty risks from pain points
- Brand/product reputation impact
- Customer retention risk assessment

#### Pain Point Prioritization (BẮT BUỘC)
- **High Priority:** Most critical pain points to address
- **Medium Priority:** Important but less critical
- **Low Priority:** Minor pain points with lower impact
- **Opportunity Mapping:** Pain points with highest solution opportunity

### Validation Gate
- [ ] Customer challenges documented with citations
- [ ] Unmet needs and solution gaps identified
- [ ] Adoption barriers analyzed
- [ ] Pain points prioritized by impact and opportunity
- [ ] Content written to document

---

## Step 4: Customer Decision Processes (BẮT BUỘC)

**Goal:** Analyze customer decision-making processes, journey mapping, and decision influencers.

### 4.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} customer decision process"`
- `"{{RESEARCH_TOPIC}} buying criteria factors"`
- `"{{RESEARCH_TOPIC}} customer journey mapping"`
- `"{{RESEARCH_TOPIC}} decision influencing factors"`

### 4.2 Analysis Areas

#### Customer Decision-Making Processes
- Key stages in decision-making
- Timeframes for different decisions
- Complexity level assessment
- Evaluation methods customers use

#### Decision Factors and Criteria
- Primary decision factors (most important)
- Secondary decision factors (supporting)
- Weighing analysis — how factors are prioritized
- Evolution patterns — how factors change over time

#### Customer Journey Mapping (BẮT BUỘC)
- **Awareness Stage:** How customers become aware of {{RESEARCH_TOPIC}}
- **Consideration Stage:** Evaluation and comparison process
- **Decision Stage:** Final decision-making process
- **Purchase Stage:** Purchase execution and completion
- **Post-Purchase Stage:** Post-decision evaluation and behavior

#### Touchpoint Analysis
- Digital touchpoints — online interaction points
- Offline touchpoints — physical interaction points
- Information sources — where customers get information
- Influence channels — what influences decisions

#### Information Gathering Patterns
- Research methods customers use
- Most trusted information sources
- Time spent gathering information
- Evaluation criteria for information

#### Decision Influencers
- Peer influence — friends, family, community
- Expert influence — professional opinions
- Media influence — marketing, content
- Social proof — reviews, testimonials, case studies

#### Purchase Decision Factors
- Immediate purchase drivers — urgency triggers
- Delayed purchase drivers — what causes hesitation
- Brand loyalty factors — repeat purchase drivers
- Price sensitivity assessment

#### Decision Optimization Opportunities
- Friction reduction — making decisions easier
- Trust building — building customer confidence
- Conversion optimization — improving decision-to-purchase rates
- Loyalty building — long-term relationship strategies

### Validation Gate
- [ ] Decision-making processes mapped
- [ ] Decision factors and criteria analyzed
- [ ] Customer journey mapped across all stages
- [ ] Touchpoints and influencers identified
- [ ] Content written to document

---

## Step 5: Competitive Analysis (BẮT BUỘC)

**Goal:** Analyze the competitive landscape, market positioning, strengths/weaknesses, and differentiation opportunities.

### 5.1 Web Research

Execute targeted web searches:
- `"{{RESEARCH_TOPIC}} key players market leaders"`
- `"{{RESEARCH_TOPIC}} market share competitive landscape"`
- `"{{RESEARCH_TOPIC}} competitive strategies"`
- Industry reports and competitive intelligence

### 5.2 Analysis Areas

#### Key Market Players
- Market leaders and dominant players
- Major competitors and their specialties
- Emerging players and new entrants
- Market share distribution

#### Competitive Positioning
- How players position themselves
- Value proposition mapping across competitors
- Customer segments served by each
- Pricing strategies and models

#### Strengths and Weaknesses (SWOT)
- Each major competitor's strengths
- Key weaknesses and vulnerabilities
- Market opportunities available
- Competitive threats to address

#### Market Differentiation
- Differentiation strategies in use
- Unserved niches and gaps
- Innovation approaches by competitor
- Sustainable competitive advantages

#### Competitive Threats
- New entrant risks
- Substitute product threats
- Pricing pressure dynamics
- Technology disruption risks

#### Opportunities
- Market gaps identified through competitive analysis
- Underserved customer segments
- Technology-enabled differentiation
- Partnership and alliance opportunities

### Validation Gate
- [ ] Key market players identified with market share data
- [ ] Competitive positioning clearly mapped
- [ ] SWOT analysis completed
- [ ] Differentiation opportunities identified
- [ ] Competitive threats documented
- [ ] Content written to document

---

## Step 6: Strategic Synthesis and Completion (BẮT BUỘC)

**Goal:** Produce the comprehensive market research document with executive summary, strategic recommendations, and complete structure.

### 6.1 Additional Strategic Research

Execute targeted web searches:
- `"market entry strategies best practices"` — for strategy context
- `"market research risk assessment frameworks"` — for risk context

### 6.2 Generate Complete Document Structure

Synthesize ALL research from Steps 2-5 into a comprehensive document with:

#### Executive Summary
- 2-3 paragraph compelling overview of key findings
- Key findings bullet list (4-5 most significant)
- Top strategic recommendations (3-5 actionable)

#### Market Analysis and Dynamics
- Market size and growth projections (with CAGR)
- Market trends and dynamics
- Pricing and business model analysis

#### Customer Insights Summary
- Customer behavior patterns (synthesized from Step 2)
- Customer pain points and needs (synthesized from Step 3)
- Customer segmentation and targeting recommendations

#### Competitive Landscape Summary
- Competitive analysis (synthesized from Step 5)
- Market positioning strategies
- Differentiation opportunities

#### Strategic Recommendations (BẮT BUỘC)
- Market opportunity assessment — highest-value opportunities
- Market entry strategy — recommended approach
- Competitive strategy — positioning and differentiation
- Customer acquisition strategy — recommended approach

#### Market Entry and Growth Strategies
- Go-to-market strategy — entry approach, channels, partnerships
- Growth and scaling strategy — phased approach, expansion opportunities

#### Risk Assessment and Mitigation
- Market risks and uncertainties
- Competitive threats and mitigation
- Regulatory and compliance risks
- Risk mitigation approaches and contingency plans

#### Implementation Roadmap
- Implementation timeline — phased approach
- Required resources and capabilities
- Key milestones and success criteria
- KPIs and monitoring framework

#### Future Market Outlook
- Near-term (1-2 year) projections
- Medium-term (3-5 year) expected developments
- Long-term (5+ year) market vision

#### Research Methodology and Sources
- Complete source documentation
- Research quality assurance notes
- Confidence levels for uncertain data
- Research limitations and areas for further investigation

### 6.3 Document Quality Checks

- [ ] Executive summary is compelling and can stand alone
- [ ] All factual claims have source citations
- [ ] Confidence levels noted for uncertain data
- [ ] No critical gaps in coverage
- [ ] Strategic recommendations are actionable and grounded in research
- [ ] Professional structure with clear narrative

### 6.4 Completion Communication

"Market research for **{{RESEARCH_TOPIC}}** is complete!

**Research Document:** `{{OUTPUT_PATH}}/research/market-{{RESEARCH_TOPIC}}-research.md`

**Key Deliverables:**
- Comprehensive market analysis with growth projections
- Customer behavior, pain points, and journey analysis
- Competitive landscape and positioning analysis
- Strategic recommendations and implementation roadmap

**Recommended next steps:**
- Use research to inform product brief or PRD creation
- Conduct deeper research on specific segments if needed
- Move forward with implementation based on strategic recommendations"

---

## HALT Conditions

- Web search unavailable → HALT: "Cannot conduct market research without web search"
- Research topic too broad and user unable to narrow → HALT with clarification request
- Critical data gaps that cannot be filled → HALT with explanation of what's missing

## Quality Standards

- Always cite URLs for web search results
- Use authoritative sources (market research firms, industry associations, government data)
- Note data currency and potential limitations
- Present multiple perspectives when sources conflict
- Apply confidence levels: High (multiple authoritative sources), Medium (single reliable source), Low (limited/dated sources)
- Focus on actionable insights, not just data presentation
