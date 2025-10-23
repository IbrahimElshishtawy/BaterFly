# 🧱 ADR 001 — Architecture Choice

**Date:** 2025-10-23  
**Status:** Accepted  
**Decision Makers:** Moamen & Team

---

## 🎯 Context
We needed a simple, scalable architecture suitable for a small web shop with future potential for mobile expansion.

---

## 💡 Decision
We adopted a **Clean Architecture** structure divided into:
- `domain` → entities, repositories, use cases
- `data` → data sources (Supabase + local), models, implementations
- `features` → UI + controllers per module
- `core` → global utilities, errors, env, theming
- `services` → external APIs (Supabase, notifications, etc.)

---

## 🧠 Rationale
- Clear separation between logic and UI.
- Easier unit testing and maintenance.
- Flexible to scale for mobile or API integration later.
- Matches Supabase + Flutter best practices.

---

## 🚀 Alternatives Considered
| Option | Reason Rejected |
|--------|-----------------|
| MVC | UI-heavy, poor scalability |
| BLoC-only structure | Tightly coupled layers |
| Provider-only | No separation of data logic |

---

## ✅ Consequences
- Code more verbose but structured.
- Testing easier.
- Onboarding new developers simpler.
