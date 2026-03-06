# AGENTS.md - Guidelines for Agentic Coding

This file provides development guidelines for agents operating in this repository.

---

## Project Overview

**Project Name:** Mesón Santa Rosa - Hotel Boutique Website  
**Type:** Static HTML website (single-page landing)  
**Technology:** HTML5, Tailwind CSS (CDN), Font Awesome, Google Fonts  

This is a simple static website. No build tools, no linters, no test frameworks are required.

---

## Development Commands

### Running the Project

Since this is a static HTML file, no build step is required:

- **View locally:** Open `index.html` directly in a browser, or serve with:
  ```bash
  # Using Python
  python -m http.server 8000
  
  # Using Node.js
  npx serve .
  
  # Using PHP
  php -S localhost:8000
  ```

- **Deploy:** Upload `index.html` and `logo_meson_estampa.png` to any static host (Netlify, Vercel, GitHub Pages, etc.)

### Validation (Manual)

- **HTML validation:** Use [W3C Validator](https://validator.w3.org/) to check HTML markup
- **Accessibility:** Use browser dev tools or axe DevTools to audit accessibility
- **Performance:** Use Lighthouse or PageSpeed Insights

---

## Code Style Guidelines

### General Principles

1. **Keep it simple** - This is a static site; avoid unnecessary complexity
2. **Maintain consistency** - Follow existing patterns in the codebase
3. **Prioritize accessibility** - Always include semantic HTML and ARIA attributes
4. **Optimize for performance** - Lazy load images, defer scripts

### HTML Structure

```html
<!-- Document structure -->
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Page Title</title>
  <meta name="description" content="..." />
  <!-- Preconnects, fonts, stylesheets -->
</head>
<body>
  <!-- Content -->
</body>
</html>
```

**Rules:**
- Always use `<!DOCTYPE html>` and `lang="es"` (Spanish site)
- Include viewport meta tag for responsive design
- Add meaningful meta descriptions for SEO
- Use semantic elements: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`
- Use proper heading hierarchy: `<h1>` → `<h2>` → `<h3>` (never skip levels)
- Include `aria-label` on interactive elements without visible text

### CSS / Tailwind

- **Tailwind CDN:** Currently using `https://cdn.tailwindcss.com` with JIT
- **Custom colors:** Define in Tailwind config's `theme.extend.colors`:
  ```javascript
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          'pink-meson': '#E90065',
          'brown-heading': '#4A3525',
          'brown-body': '#5C4A42',
          'cream-bg': '#FDFBF7',
        }
      }
    }
  }
  ```
- **Custom classes:** Use when Tailwind can't express the design (filigree backgrounds, complex gradients)
- **Responsive:** Mobile-first: base classes → `sm:` → `md:` → `lg:` → `xl:`
- **Avoid:** Inline styles except for dynamic values; use utility classes

### CSS Custom Properties (Variables)

Use CSS variables for theme consistency:
```css
:root {
  --pink: #E90065;
  --brown-h: #4A3525;
  --brown-b: #5C4A42;
  --cream: #FDFBF7;
}
```

### JavaScript

- **Placement:** Put inline JS at the end of `<body>` or use `defer`
- **Event handling:** Use event delegation for dynamic elements
- **Mobile menu:** Toggle class `open` on `#mobile-menu`
- **Scroll effects:** Add `scrolled` class to header on scroll

Example pattern:
```javascript
document.getElementById('menu-btn').addEventListener('click', function() {
  const menu = document.getElementById('mobile-menu');
  menu.classList.toggle('open');
});
```

### Accessibility

- Include `skip-link` as first focusable element
- Use `aria-label` on icon-only buttons
- Ensure color contrast meets WCAG AA (4.5:1 for text)
- Include `alt` text on all images (descriptive, not "image")
- Use `focus-visible` styles for keyboard navigation

### SEO

- Include canonical URL
- Add Open Graph and Twitter Card meta tags
- Use JSON-LD structured data for rich results
- Use semantic HTML throughout

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| IDs | kebab-case | `#main-header`, `#mobile-menu` |
| Classes | kebab-case | `.btn-pink`, `.feature-card` |
| Sections | kebab-case | `#habitaciones`, `#restaurante` |
| Colors | descriptive | `pink-meson`, `brown-heading` |
| Fonts | descriptive | `font-serif`, `font-sans` |

### Image Handling

- Use `loading="lazy"` for below-the-fold images
- Use `loading="eager"` + `fetchpriority="high"` for hero image
- Include `decoding="async"` for non-critical images
- Use descriptive `alt` text in Spanish

---

## Common Tasks

### Adding a New Section

1. Use semantic `<section id="section-name">` with unique ID
2. Include heading hierarchy (h2 for section titles)
3. Add section divider pattern:
   ```html
   <div class="section-divider">
     <span></span>
     <i class="fa-solid fa-icon"></i>
     <span></span>
   </div>
   ```
4. Use consistent padding: `py-24 px-4`

### Adding a New Card/Component

1. Use `.feature-card` base class for hover effects
2. Include `transition` classes for smooth animations
3. Wrap images in `.gallery-img-wrap` for hover zoom

### Modifying Colors

Update both Tailwind config AND CSS variables to maintain consistency:
- Tailwind config: `theme.extend.colors`
- CSS custom properties: `:root` section

---

## File Structure

```
/home/otelo/Documents/Code/new-meson-santa-rosa/
├── index.html              # Main website (single page)
├── logo_meson_estampa.png  # Logo image
└── .git/                  # Git repository
```

---

## Performance Targets

- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Cumulative Layout Shift: < 0.1
- Total page weight: < 2MB (aim)

---

## Notes for Agents

1. **No testing required** - Manual browser testing is sufficient
2. **No build process** - Edit HTML directly
3. **Spanish content** - All text is in Spanish
4. **Mobile-first** - Design for mobile, enhance for desktop
5. **Accessibility mandatory** - All changes must maintain WCAG AA compliance
