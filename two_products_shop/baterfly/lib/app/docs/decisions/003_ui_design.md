# 🎨 ADR 003 — UI/UX Design Decisions

**Date:** 2025-10-23  
**Status:** Accepted  

---

## 🎯 Context
The web app targets Arabic-speaking users, primarily mobile visitors.  
We needed a lightweight, responsive UI optimized for speed and simplicity.

---

## 💡 Decision
Adopt a **minimalist, motion-enhanced** design with:
- Hero section for featured product.
- Animated product grid (Fade + Slide).
- Arabic RTL layout.
- Soft shadows and rounded corners.

---

## 🧠 Rationale
- Simple UIs convert better in product-focused pages.
- Animation increases engagement and perceived smoothness.
- Avoid heavy assets to keep page load < 1s.

---

## 🧩 Implementation Notes
- Animations: `FadeSlide` in `/core/widgets/animations/`
- Fonts: Google Cairo
- Theme: Defined in `/core/theme/`
- RTL: Enabled via `Directionality(textDirection: TextDirection.rtl)`
