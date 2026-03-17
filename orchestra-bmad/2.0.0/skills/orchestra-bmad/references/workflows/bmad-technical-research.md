# Technical Research Workflow — Full Step-by-Step

**Goal:** Conduct comprehensive technical research using current web data and verified sources to produce a complete research document covering technology stacks, integration patterns, architectural patterns, implementation approaches, and strategic technical recommendations.

**Your Role:** Technical research facilitator working with an expert partner. You bring research methodology and web search capabilities. The user brings domain knowledge and technical direction.

**CRITICAL RULES (NO EXCEPTIONS):**
- Execute ALL steps in exact order; do NOT skip steps
- Web search is REQUIRED — if unavailable, HALT immediately
- NEVER generate technical claims without web search verification
- ALWAYS cite sources with URLs for factual claims
- Present conflicting information when sources disagree
- Apply confidence levels to uncertain data
- Continue until research is COMPLETE unless a HALT condition is triggered

**PREREQUISITE:** Web search capability must be available. If unavailable → HALT: "Cannot conduct technical research without web search access."

---

## Step 1: Topic Discovery and Scope Confirmation (BẮT BUỘC)

**Goal:** Understand and confirm the technical research topic, goals, and scope.

### 1.1 Topic Discovery

If topic not already provided:

"Let's get started with your technical research. What technology, tool, or technical area do you want to research?

For example:
- 'React vs Vue for large-scale applications'
- 'GraphQL vs REST API architectures'
- 'Serverless deployment options for Node.js'"

### 1.2 Topic Clarification

Based on the user's topic, clarify:
1. **Core Technology:** "What specific aspect of {{RESEARCH_TOPIC}} are you most interested in?"
2. **Research Goals:** "What do you hope to achieve with this research?"
3. **Scope:** "Should we focus broadly or dive deep into specific aspects?"

### 1.3 Scope Confirmation

Present clear scope:

"**Technical Research Scope Confirmation:**

For **{{RESEARCH_TOPIC}}**, I will research:

- **Technology Stack** — languages, frameworks, tools, platforms
- **Integration Patterns** — APIs, protocols, system interoperability
- **Architectural Patterns** — design patterns, scalability, maintainability
- **Implementation Approaches** — methodologies, workflows, deployment, operations
- **Performance Considerations** — scalability, optimization, benchmarks

**Research Methodology:**
- Current web data with rigorous source verification
- Multi-source validation for critical technical claims
- Confidence level framework for uncertain information

**Does this scope align with your goals?**"

### 1.4 Document Setup

Create output file at: `{{OUTPUT_PATH}}/research/technical-{{RESEARCH_TOPIC}}-research.md`

```yaml
---
research_type: technical
research_topic: "{{RESEARCH_TOPIC}}"
research_goals: "{{RESEARCH_GOALS}}"
date: "{{TIMESTAMP}}"
web_research_enabled: true
source_verification: true
---
```

### Validation Gate
- [ ] Research topic and goals clearly confirmed
- [ ] Technical research scope defined with user agreement
- [ ] Output document initialized

---

## Step 2: Technology Stack Analysis (BẮT BUỘC)

**Goal:** Analyze programming languages, frameworks, databases, tools, and cloud platforms relevant to the research topic.

### 2.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} programming languages frameworks"`
- `"{{RESEARCH_TOPIC}} development tools platforms"`
- `"{{RESEARCH_TOPIC}} database storage technologies"`
- `"{{RESEARCH_TOPIC}} cloud infrastructure platforms"`

### 2.2 Analysis Areas

#### Programming Languages
- Most widely used languages for {{RESEARCH_TOPIC}}
- Emerging languages gaining adoption
- Language preference evolution trends
- Performance characteristics and suitability for use case
- _Source: [URL]_

#### Development Frameworks and Libraries
- Major frameworks and their use cases
- Micro-frameworks and lightweight/specialized libraries
- Evolution trends — how frameworks are changing
- Ecosystem maturity — library availability, community support
- _Source: [URL]_

#### Database and Storage Technologies
- Relational databases — SQL options and their evolution
- NoSQL databases — document, key-value, graph options
- In-memory databases — Redis, Memcached, performance-focused solutions
- Data warehousing — analytics and big data storage
- _Source: [URL]_

#### Development Tools and Platforms
- IDE and editor landscape
- Version control and collaboration tools
- Build systems — compilation, packaging, automation
- Testing frameworks — unit, integration, E2E, QA tools
- _Source: [URL]_

#### Cloud Infrastructure and Deployment
- Major cloud providers (AWS, Azure, GCP) and relevant services
- Container technologies — Docker, Kubernetes, orchestration
- Serverless platforms — FaaS and event-driven computing
- CDN and edge computing options
- _Source: [URL]_

#### Technology Adoption Trends
- Migration patterns — how technology choices are evolving
- Emerging technologies gaining traction
- Legacy technologies being phased out
- Community trends — developer preferences and open-source adoption
- _Source: [URL]_

### Validation Gate
- [ ] Programming languages analyzed with citations
- [ ] Frameworks and libraries evaluated
- [ ] Database technologies assessed
- [ ] Development tools documented
- [ ] Cloud infrastructure options mapped
- [ ] Adoption trends identified
- [ ] Content written to document

---

## Step 3: Integration Patterns (BẮT BUỘC)

**Goal:** Analyze API design patterns, communication protocols, system interoperability, microservices integration, and event-driven architectures.

### 3.1 Parallel Web Research

Execute multiple web searches simultaneously:
- `"{{RESEARCH_TOPIC}} API design patterns protocols"`
- `"{{RESEARCH_TOPIC}} communication protocols data formats"`
- `"{{RESEARCH_TOPIC}} system interoperability integration"`
- `"{{RESEARCH_TOPIC}} microservices integration patterns"`

### 3.2 Analysis Areas

#### API Design Patterns
- RESTful APIs — principles and best practices
- GraphQL APIs — adoption patterns and implementation
- RPC and gRPC — high-performance communication
- Webhook patterns — event-driven API integration
- _Source: [URL]_

#### Communication Protocols
- HTTP/HTTPS — web-based communication evolution
- WebSocket — real-time and persistent connections
- Message queue protocols — AMQP, MQTT, messaging patterns
- gRPC and Protocol Buffers — binary communication
- _Source: [URL]_

#### Data Formats and Standards
- JSON and XML — structured data exchange evolution
- Protobuf and MessagePack — efficient binary serialization
- CSV and flat files — legacy integration and bulk transfer
- Domain-specific data exchange standards
- _Source: [URL]_

#### System Interoperability Approaches
- Point-to-point integration — direct system communication
- API gateway patterns — centralized management and routing
- Service mesh — service-to-service communication and observability
- Enterprise Service Bus — traditional enterprise integration
- _Source: [URL]_

#### Microservices Integration Patterns (BẮT BUỘC)
- **API Gateway Pattern** — external API management and routing
- **Service Discovery** — dynamic registration and discovery
- **Circuit Breaker Pattern** — fault tolerance and resilience
- **Saga Pattern** — distributed transaction management
- _Source: [URL]_

#### Event-Driven Integration
- Publish-Subscribe — event broadcasting and subscription models
- Event Sourcing — event-based state management and persistence
- Message Broker patterns — RabbitMQ, Kafka, routing strategies
- CQRS — Command Query Responsibility Segregation
- _Source: [URL]_

#### Integration Security Patterns
- OAuth 2.0 and JWT — authentication and authorization
- API key management — secure access and rotation
- Mutual TLS — certificate-based service authentication
- Data encryption — secure transmission and storage
- _Source: [URL]_

### Validation Gate
- [ ] API design patterns analyzed with citations
- [ ] Communication protocols evaluated
- [ ] Data formats documented
- [ ] Interoperability approaches assessed
- [ ] Microservices patterns mapped
- [ ] Event-driven integration covered
- [ ] Security patterns included
- [ ] Content written to document

---

## Step 4: Architectural Patterns (BẮT BUỘC)

**Goal:** Analyze system architecture patterns, design principles, scalability approaches, security architecture, and data architecture.

### 4.1 Targeted Web Research

Execute focused searches:
- `"system architecture patterns best practices"`
- `"software design principles patterns"`
- `"scalability architecture patterns"`

### 4.2 Analysis Areas

#### System Architecture Patterns
- Microservices vs monolithic vs serverless — trade-offs
- Event-driven and reactive architectures
- Domain-driven design patterns
- Cloud-native and edge architecture patterns
- _Source: [URL]_

#### Design Principles and Best Practices
- SOLID principles and their application
- Clean architecture and hexagonal architecture
- API design patterns (GraphQL vs REST vs gRPC decisions)
- Database design and data modeling patterns
- _Source: [URL]_

#### Scalability and Performance Patterns (BẮT BUỘC)
- **Horizontal vs vertical scaling** — when to use each
- **Load balancing strategies** — algorithms, health checks, session affinity
- **Caching strategies** — CDN, application cache, database cache, invalidation
- **Distributed systems** — consensus, partitioning, replication
- **Performance optimization** — profiling, bottleneck identification, tuning
- _Source: [URL]_

#### Integration and Communication Patterns
- Synchronous vs asynchronous communication trade-offs
- Request-reply vs fire-and-forget patterns
- API versioning and backward compatibility strategies
- Service orchestration vs choreography
- _Source: [URL]_

#### Security Architecture Patterns
- Zero-trust architecture principles
- Defense in depth strategies
- Identity and access management patterns
- Data protection and encryption architecture
- _Source: [URL]_

#### Data Architecture Patterns
- Data lake vs data warehouse vs data mesh
- ETL vs ELT vs streaming data pipelines
- Multi-model database strategies
- Data governance and lineage
- _Source: [URL]_

#### Deployment and Operations Architecture
- Blue-green and canary deployment patterns
- Infrastructure as Code approaches
- GitOps and continuous deployment
- Observability architecture (logging, metrics, tracing)
- _Source: [URL]_

### Validation Gate
- [ ] System architecture patterns analyzed with trade-offs
- [ ] Design principles documented
- [ ] Scalability patterns thoroughly mapped
- [ ] Security architecture covered
- [ ] Data architecture patterns included
- [ ] Deployment patterns documented
- [ ] Content written to document

---

## Step 5: Implementation Research (BẮT BUỘC)

**Goal:** Analyze technology adoption strategies, development workflows, testing/deployment practices, team organization, and cost optimization.

### 5.1 Targeted Web Research

Execute focused searches:
- `"technology adoption strategies migration"`
- `"software development workflows tooling"`
- `"DevOps operations best practices"`

### 5.2 Analysis Areas

#### Technology Adoption Strategies
- Migration patterns and approaches (gradual vs big-bang)
- Legacy system modernization strategies
- Vendor evaluation and selection criteria
- Proof of concept and pilot program approaches
- _Source: [URL]_

#### Development Workflows and Tooling
- CI/CD pipelines and automation tools
- Code quality and review processes
- Branching strategies and version control workflows
- Collaboration and communication tools
- _Source: [URL]_

#### Testing and Quality Assurance
- Unit testing frameworks and strategies
- Integration and E2E testing approaches
- Performance testing and load testing tools
- Security testing and vulnerability scanning
- _Source: [URL]_

#### Deployment and Operations Practices
- Monitoring and observability implementation
- Incident response and disaster recovery planning
- Infrastructure as Code tooling and practices
- Security operations and compliance automation
- _Source: [URL]_

#### Team Organization and Skills
- Team structure patterns (platform teams, feature teams, stream-aligned)
- Required skill sets and competency mapping
- Training and upskilling approaches
- Hiring and talent acquisition considerations
- _Source: [URL]_

#### Cost Optimization and Resource Management
- Cloud cost optimization strategies
- Infrastructure right-sizing approaches
- Reserved capacity vs on-demand decisions
- Total cost of ownership analysis frameworks
- _Source: [URL]_

#### Risk Assessment and Mitigation
- Technical debt management strategies
- Vendor lock-in risks and mitigation
- Technology obsolescence risk management
- Security vulnerability management

### 5.3 Recommendations

#### Implementation Roadmap
- Phase 1: Foundation and quick wins (0-3 months)
- Phase 2: Core capabilities (3-6 months)
- Phase 3: Advanced features (6-12 months)
- Phase 4: Optimization and scaling (12+ months)

#### Technology Stack Recommendations
- Recommended primary technologies with rationale
- Alternative options and when to consider them
- Technologies to avoid and why

#### Skill Development Requirements
- Critical skills needed immediately
- Skills to develop over 6-12 months
- Training resources and learning paths

#### Success Metrics and KPIs
- Technical performance KPIs
- Development velocity metrics
- Quality and reliability metrics
- Cost efficiency metrics

### Validation Gate
- [ ] Adoption strategies documented
- [ ] Development workflows analyzed
- [ ] Testing and QA approaches covered
- [ ] Deployment and operations practices mapped
- [ ] Team organization and skills assessed
- [ ] Cost optimization strategies included
- [ ] Implementation roadmap drafted
- [ ] Content written to document

---

## Step 6: Technical Synthesis and Completion (BẮT BUỘC)

**Goal:** Produce the comprehensive technical research document with executive summary, cross-cutting analysis, strategic recommendations, and complete structure.

### 6.1 Additional Strategic Research

Execute targeted web search:
- `"{{RESEARCH_TOPIC}} technical significance importance"` — for narrative introduction context

### 6.2 Generate Complete Document Structure

Synthesize ALL research from Steps 2-5 into a comprehensive document:

#### Executive Summary (BẮT BUỘC)
- 2-3 paragraph compelling overview of key technical findings
- Key technical findings (4-5 most significant)
- Top technical recommendations (3-5 actionable)

#### Technical Research Introduction and Methodology
- Compelling narrative about why {{RESEARCH_TOPIC}} research is critical now
- Research methodology (scope, sources, analysis framework, technical depth)
- Research goals achievement assessment

#### Technical Landscape and Architecture Analysis
- Current architectural patterns (from Step 4)
- System design principles and best practices
- Architecture trade-off analysis

#### Implementation Approaches and Best Practices
- Current implementation methodologies (from Step 5)
- Code organization and quality approaches
- Deployment and operations practices

#### Technology Stack Evolution and Trends
- Current technology landscape (from Step 2)
- Technology adoption patterns and migration trends
- Emerging technologies and their potential impact

#### Integration and Interoperability Patterns
- Current integration approaches (from Step 3)
- Interoperability standards and protocols
- Integration challenges and solutions

#### Performance and Scalability Analysis
- Performance characteristics and benchmarks
- Scalability patterns and capacity planning
- Optimization strategies and monitoring

#### Security and Compliance Considerations
- Security frameworks and best practices
- Threat landscape and mitigation
- Industry standards and regulatory compliance

#### Strategic Technical Recommendations (BẮT BUỘC)
- **Architecture Recommendations** — recommended patterns and approaches
- **Technology Selection** — recommended stack and selection criteria
- **Implementation Strategy** — recommended methodology and phasing
- **Competitive Technical Advantage** — differentiation through technology

#### Implementation Roadmap and Risk Assessment
- Phased implementation approach
- Technology migration strategy
- Technical risk management plan

#### Future Technical Outlook
- Near-term (1-2 year) technical evolution expectations
- Medium-term (3-5 year) expected developments
- Long-term (5+ year) technical outlook
- Innovation and research opportunities

#### Research Methodology and Source Documentation
- Complete source documentation
- Research quality assurance notes
- Confidence levels for uncertain data
- Research limitations and areas for further investigation

### 6.3 Document Quality Checks

- [ ] Executive summary is compelling and can stand alone
- [ ] All factual technical claims have source citations
- [ ] Architecture trade-offs clearly presented
- [ ] Confidence levels noted for uncertain data
- [ ] No critical gaps in coverage
- [ ] Strategic recommendations are actionable and technically sound
- [ ] Professional structure with clear narrative
- [ ] Implementation roadmap is realistic

### 6.4 Completion Communication

"Technical research for **{{RESEARCH_TOPIC}}** is complete!

**Research Document:** `{{OUTPUT_PATH}}/research/technical-{{RESEARCH_TOPIC}}-research.md`

**Key Deliverables:**
- Technology stack analysis with adoption trends
- Integration patterns and interoperability analysis
- Architectural patterns with trade-off analysis
- Implementation approaches and operational practices
- Strategic technical recommendations and roadmap

**Recommended next steps:**
- Use research to inform architecture design decisions
- Conduct deeper research on specific technologies if needed
- Move forward with implementation based on roadmap recommendations"

---

## HALT Conditions

- Web search unavailable → HALT: "Cannot conduct technical research without web search"
- Research topic too broad and user unable to narrow → HALT with clarification request
- Critical data gaps that cannot be filled → HALT with explanation of what's missing

## Quality Standards

- Always cite URLs for web search results
- Use authoritative sources (official docs, tech blogs, conference proceedings, developer surveys)
- Note data currency and potential limitations
- Present multiple perspectives when sources conflict
- Apply confidence levels: High (multiple authoritative sources), Medium (single reliable source), Low (limited/dated sources)
- Focus on actionable insights with clear trade-off analysis
- Include code examples or configuration snippets where they clarify architectural decisions
