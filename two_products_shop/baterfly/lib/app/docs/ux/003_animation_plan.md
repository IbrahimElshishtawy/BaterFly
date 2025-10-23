# 💫 UX 003 — Animation Plan

**Goal:** Make the app feel alive without slowing performance.

---

## ✨ Used Animations
| Component | Animation | Duration | Purpose |
|------------|------------|-----------|----------|
| Hero Section | FadeSlide | 400ms | جذب الانتباه في البداية |
| Product Cards | Fade-in staggered | 150ms each | ديناميكية أثناء تحميل الشبكة |
| Page Transition | Fade | 300ms | انتقال ناعم بين الصفحات |
| Button Click | Scale effect | 120ms | شعور بالاستجابة الفورية |

---

## 🧠 Implementation
- All animations are lightweight (using Flutter’s `AnimatedOpacity`, `AnimatedSlide`).
- Defined in `/core/widgets/animations/`.
- Avoid using 3rd-party libraries to preserve performance.

---

## 🧩 Lottie
- `/assets/lottie/success.json` → عند إتمام الطلب.
- `/assets/lottie/loading.json` → أثناء الاتصال بـ Supabase.
