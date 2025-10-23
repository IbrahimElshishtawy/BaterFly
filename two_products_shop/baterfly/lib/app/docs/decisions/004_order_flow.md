# 🧾 ADR 004 — Order Flow Design

**Date:** 2025-10-23  
**Status:** Accepted  

---

## 🎯 Context
We wanted a frictionless one-step order process for guests (no login).

---

## 💡 Decision
- Guests can place orders directly via Supabase `orders` table.
- Validation handled via SQL check constraints.
- Confirmation handled by Flutter `ThankYouPage`.

---

## 🧠 Flow
1. User clicks **Buy Now**.
2. Fills quick form (Name, Phone, Address, Quantity).
3. Supabase insert → triggers server-side validation.
4. Shows `ThankYouPage` upon success.

---

## ✅ Benefits
- Faster checkout.
- No need for auth.
- Less drop-off during conversion.
