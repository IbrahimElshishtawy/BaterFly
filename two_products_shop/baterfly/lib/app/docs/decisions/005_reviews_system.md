# ⭐ ADR 005 — Product Reviews System

**Date:** 2025-10-23  
**Status:** Accepted  

---

## 🎯 Context
Reviews increase trust and engagement but must be moderated.

---

## 💡 Decision
- Store reviews in `product_reviews`.
- Only approved ones appear to public.
- Use Supabase trigger to recalc average rating.

---

## 🧩 SQL
Defined in `/supabase/policies/reviews.sql`.

---

## ✅ Benefits
- Automatic rating updates.
- Spam prevention.
- Public visibility only for valid reviews.
