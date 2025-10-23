# ⚙️ ADR 002 — Supabase as Backend

**Date:** 2025-10-23  
**Status:** Accepted  
**Decision Makers:** Moamen & Team

---

## 🎯 Context
We needed a backend solution that provides:
- Database
- Authentication
- Storage
- Row-level security
- Edge functions

without managing servers manually.

---

## 💡 Decision
Use **Supabase** instead of Firebase.

---

## 🧠 Rationale
| Feature | Supabase | Firebase |
|----------|-----------|----------|
| SQL Database | ✅ PostgreSQL | ❌ NoSQL only |
| Edge Functions | ✅ TypeScript | ⚙️ Limited |
| Row Level Security | ✅ Native | ❌ Not supported |
| Self-hosting option | ✅ | ❌ |
| Open Source | ✅ | ❌ |

---

## ⚠️ Risks
- Learning curve for SQL policies.
- Edge function cold starts.

---

## ✅ Mitigations
- Predefine policies and migrations in `/supabase/policies` and `/supabase/migrations`.
- Cache queries on client side.
