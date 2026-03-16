---
name: branching-matrix-analysis
description: Systematic matrix thinking for EVERYTHING — before any important decision, recommendation, answer, or action, identify all relevant domains, enumerate sibling concepts per domain, verify coverage, check cross-domain interactions. Use for specs, designs, brainstorming, debugging, planning, problem-solving, or ANY task requiring thoroughness.
---

# Branching Matrix Analysis

Phương pháp tư duy có hệ thống để có cái nhìn TOÀN CẢNH + TƯỜNG TẬN CHI TIẾT trước khi đưa ra quyết định, lời nói, hay hành động.

**KHÔNG chỉ cho code.** Áp dụng cho MỌI THỨ: brainstorm, tìm vấn đề, đề xuất giải pháp, lên kế hoạch, trả lời câu hỏi, debug, design, review.

## Khi nào dùng

- **TRƯỚC KHI** đưa ra recommendation, quyết định, hoặc kết luận quan trọng
- Review spec/design xong, trước khi kết luận "complete"
- Phát hiện 1 gap/vấn đề → cần tìm gaps/vấn đề cùng họ
- Thiết kế hệ thống mới → verify không thiếu concerns
- Brainstorm → đảm bảo explore hết các góc nhìn
- Debug → đảm bảo không bỏ sót root cause tiềm ẩn
- Bất kỳ khi nào cần đảm bảo thoroughness

## Nguyên tắc cốt lõi

> Trước khi nói hay làm bất kỳ điều gì quan trọng → suy nghĩ dạng ma trận:
> domains → siblings → verify → cross-domain → rồi mới output.

## Quy trình

### Bước 1: Xác định các DOMAIN chính của deliverable

Mỗi deliverable (spec, design, plan) đều nằm tại giao điểm của nhiều domains. Liệt kê tất cả domains liên quan.

**Ví dụ — Framework design:**
```
Domains:
  1. Core system (BMAD methodology)
  2. Platform (Claude Code capabilities)
  3. End User Experience (Tyler's perspective)
  4. Fault tolerance (checkpoint, recovery)
  5. Performance (latency, throughput, limits)
  6. Security (permissions, isolation, data)
  7. Operations (monitoring, maintenance, updates)
```

**Ví dụ — API design:**
```
Domains:
  1. Functional (endpoints, data models)
  2. Non-functional (performance, rate limits)
  3. Security (auth, authorization, input validation)
  4. Client experience (SDK, docs, errors)
  5. Operations (monitoring, versioning, deprecation)
  6. Integration (dependencies, third-party)
```

### Bước 2: Cho mỗi domain, ENUMERATE sibling concepts

Không đoán — research domain knowledge để liệt kê đầy đủ.

**Ví dụ — Domain "Fault tolerance":**
```
Fault tolerance:
  ├── Checkpoint (save state)
  ├── Rollback (revert to good state)
  ├── Idempotency (re-run safely)
  ├── State consistency (sources agree)
  ├── Graceful shutdown (orderly stop)
  ├── Observability (know what's happening)
  ├── Health checks (system alive?)
  ├── Circuit breaker (stop cascading failure)
  ├── Retry with backoff (transient errors)
  └── Data integrity (no corruption)
```

### Bước 3: Verify mỗi concept trong deliverable

Cho mỗi concept, check:
- Có trong spec? → OK
- Không có nhưng relevant? → GAP — thêm vào
- Không có và không relevant? → Skip, ghi lý do

### Bước 4: Cross-domain interaction check

Một số gaps chỉ xuất hiện tại GIAO ĐIỂM của 2+ domains.

**Ví dụ:**
```
Core system × Platform = "BMAD workflows có chạy được trên Claude Code không?"
Core system × UX = "Tyler có hiểu BMAD phases không?"
Platform × Fault tolerance = "Claude Code crash thì checkpoint có persist không?"
```

Tạo matrix NxN, check mỗi intersection.

## Anti-patterns

- **Linear thinking**: Check từng section tuần tự → bỏ sót cross-cutting concerns
- **Ad-hoc thinking**: Nghĩ tới đâu check tới đó → thiếu systematic coverage
- **Single-domain focus**: Chỉ check functional requirements → miss UX, operations, security
- **Surface-level check**: "Có mention checkpoint" ≠ "Checkpoint design đầy đủ" → phải trace nhánh con

## Template output

```markdown
## Branching Matrix Analysis: [Deliverable Name]

### Domains identified
1. [Domain A]
2. [Domain B]
...

### Per-domain gap check

#### Domain A: [Name]
| Concept | In spec? | Relevant? | Gap? | Action |
|---------|----------|-----------|------|--------|
| Concept 1 | Yes | Yes | No | — |
| Concept 2 | No | Yes | YES | Add section on... |
| Concept 3 | No | No | No | Not applicable because... |

#### Domain B: [Name]
...

### Cross-domain interactions
| Domain A × Domain B | Gap? | Notes |
|---------------------|------|-------|
| Core × Platform | YES | Need to verify X works on Y |
| Core × UX | YES | User doesn't understand X |
...

### Summary
- Total gaps found: N
- Critical: X
- Important: Y
- Nice-to-have: Z
```

## Depth Calibration

Không phải task nào cũng cần full 10-domain matrix:

| Task scope | Domains | Cross-domain | Time |
|------------|---------|--------------|------|
| Nhỏ (bug fix, config change) | 3-4 relevant | Top 3 intersections | 2-3 phút |
| Trung bình (feature, API) | 5-7 | Top 10 intersections | 10-15 phút |
| Lớn (framework, system design) | 8-10+ | Full NxN matrix | 30-60 phút |

Calibrate dựa trên: impact of missing something × cost of checking.

## High-Yield Patterns (learned from usage)

**Domains thường bị bỏ sót:**
- Cost (token spend, budget, billing)
- Operations (deployment, backup, upgrades)
- Security (isolation, secrets, audit)
- Testing (framework validation, not just product tests)

**Cross-domain intersections luôn có gap:**
- Anything × Security (permissions, secrets, isolation)
- Anything × Cost (resource consumption, budget impact)
- Fault tolerance × Operations (backup vs checkpoint, disaster recovery drills)
- UX × Technical domains (user doesn't understand technical state)

**Cross-domain intersections luôn có gap (from 2 uses):**
- BMAD × Testing (Phase 1+2 untested, Quick Flow untested, adversarial review rules untested)
- Platform × Dependencies (env assumptions, BMAD source path, git init)
- Testing × Data Integrity (brain seeding missing, test isolation missing)

**Check những cặp HIGH-YIELD TRƯỚC** — xác suất gap cao, tiết kiệm thời gian.

## Domain Templates (sẵn, mở rộng dần)

### Framework / System Design
1. Core system (methodology, patterns)
2. Platform (runtime capabilities, limits)
3. End User Experience
4. Fault tolerance (checkpoint, recovery, rollback)
5. Performance (latency, throughput)
6. Security (isolation, secrets, audit)
7. Operations (deploy, backup, upgrades)
8. Cost (tokens, billing, budget)
9. Scalability (growth, multi-user)
10. Testing (validation, fixtures, metrics)

### API Design
1. Functional (endpoints, data models, business logic)
2. Non-functional (performance, rate limits, SLA)
3. Security (auth, authorization, input validation)
4. Client experience (SDK, docs, error messages)
5. Operations (monitoring, versioning, deprecation)
6. Integration (dependencies, third-party, webhooks)

### Product Decision
1. User value (problem solved, benefit delivered)
2. Feasibility (technical, resource, timeline)
3. Market (competition, timing, positioning)
4. Cost (build cost, maintenance cost, opportunity cost)
5. Risk (technical risk, market risk, legal risk)
6. Team (skills available, hiring needs, knowledge gaps)

### Bug Investigation
1. Code (logic error, race condition, edge case)
2. Data (corrupt, missing, unexpected format)
3. Infrastructure (network, disk, memory, CPU)
4. User behavior (unexpected input, workflow, timing)
5. Dependencies (library bug, API change, version mismatch)
6. Environment (config diff, OS, permissions)

*(Thêm templates mới sau mỗi lần áp dụng)*

## Improvement Roadmap

### Phase 1: Capture lessons (sau mỗi lần dùng)
- Ghi domain nào hữu ích, domain nào skip được
- Ghi cross-domain nào tìm ra gap mới
- Update high-yield patterns

### Phase 2: Build domain library (sau 3-5 lần dùng)
- Thêm domain templates cho loại task mới
- Mỗi template kèm sibling concepts sẵn
- Reduce enum time từ 10 phút → 2 phút

### Phase 3: Pattern recognition (sau 10 lần dùng)
- Track domain nào luôn có gap ở mọi project
- Build "skip list" cho low-yield intersections
- Build "must-check" list cho high-yield intersections

### Phase 4: Auto-trigger + integration
- Tự nhận diện khi nào cần matrix (không đợi prompt)
- Integrate với brainstorming: brainstorm xong → auto-matrix
- Integrate với spec review: spec xong → auto-matrix
- Calibrate depth tự động dựa trên task complexity

## Origin

Phương pháp này học từ anh Tyler — non-technical user dùng tư duy ma trận nhánh tìm ra gaps mà AI bỏ sót. Session 2026-03-16, Orchestra-BMAD brainstorm.

## Usage Log

| Date | Task | Domains | Gaps Found | Lessons |
|------|------|---------|------------|---------|
| 2026-03-16 | Orchestra-BMAD Framework Design | 10 | ~150 (per-domain + cross-domain) | Cost, Operations, Security luôn thiếu. Cross-domain × Security = always gap. Full matrix mất ~60 phút nhưng xứng đáng cho framework design |
| 2026-03-17 | Orchestra-BMAD Implementation Plan | 10 | 47 (12 critical, 18 important, 17 nice-to-have) | Plan review tìm 32 issues nhưng matrix analysis tìm thêm 15 gaps reviewers bỏ sót: Phase 1+2 untested, Quick Flow untested, no test fixtures, no brain seeding, UX features missing entirely, no scope enforcement. Dependencies domain (env assumptions, prerequisite ordering) hữu ích — reviewer bỏ sót BMAD source path verification + git init for test projects |
| 2026-03-17 | Orchestra-BMAD Post-Implementation Verify | 7 | 6 gaps (cleanup, noise, regression docs) | CRITICAL LESSON: "25/25 tasks done" ≠ "implementation complete". Matrix analysis post-implementation phát hiện: 111 bilateral noise tái tạo bởi workers, 32 test memories uncleaned, stale files, 3 gaps chưa ghi REGRESSIONS, UX features spec'd but not built. Cleanup domain + Data Integrity domain catch issues mà task completion tracking bỏ sót. PHẢI chạy matrix analysis sau implementation, không chỉ trước |
