# Mesón Santa Rosa - Project Context

> Last updated: 2026-03-03

## Project Overview

**Project**: Mesón Santa Rosa Boutique Hotel Landing Page  
**Type**: Static single-page website  
**Location**: `/home/otelo/Documents/Code/new-meson-santa-rosa`

## What This Project Is

A complete, responsive landing page for **Mesón Santa Rosa**, a boutique hotel in Tlaxcala, Mexico. The site showcases:
- Hotel rooms (Standard, Double)
- Restaurant & Bar
- Café
- Gallery
- Contact/Location

## Tech Stack

- **HTML5** - Single `index.html` file
- **Tailwind CSS** (via CDN) - Styling
- **Font Awesome 6.5** (via CDN) - Icons
- **Google Fonts** - Playfair Display (serif) + Inter (sans-serif)
- **No build tools** - Pure static HTML

## Design System

### Colors
| Name | Hex | Usage |
|------|-----|-------|
| Pink Accent | `#E90065` | Primary buttons, active states, badge borders |
| Brown Heading | `#4A3525` | Headings |
| Body Text | `#5C4A42` | Body text |
| Cream Background | `#FDFBF7` | Main background |
| White | `#FFFFFF` | Cards, header, widgets |

### Typography
- **Headings**: Playfair Display (serif)
- **Body/UI**: Inter (sans-serif)

## Current State

### ✅ Completed Features

1. **Header/Nav**
   - Fixed header with logo (`logo_meson_estampa.png`)
   - Desktop navigation (Home, Rooms, Restaurant & Bar, Cafe, Gallery, Contact)
   - "Book Now" CTA button (pink)
   - Mobile hamburger menu

2. **Hero Section**
   - Full-viewport background image (Mexican colonial courtyard)
   - Dark warm overlay gradient
   - Headline + subheading text
   - Two CTA buttons
   - Floating booking widget (horizontal row layout)
   - Circular review badge (9.4/10)

3. **Welcome Section**
   - 3 feature cards (Breakfast, Amenities, Explore Tlaxcala)
   - Filigree watermark background

4. **Rooms Section**
   - Standard Room ($55/night)
   - Double Room ($70/night)
   - Links to Expedia, Hotels.com

5. **Restaurant & Bar**
   - Two-column layout with text + food photo grid

6. **Café Section**
   - Two-column layout with café features grid

7. **Gallery**
   - Responsive asymmetric image grid

8. **Reviews**
   - 3 guest review cards (hardcoded)

9. **Contact/Location**
   - Address, phones, email, social links
   - Google Maps embed

10. **Footer**
    - Logo, navigation links, contact info

### ❌ Not Yet Implemented

1. **Booking functionality** - Widgets are visual only, no form submission
2. **Real photos** - All images are Unsplash placeholders
3. **Real Google Maps embed** - Placeholder coordinates used
4. **Real reviews** - Hardcoded fictional reviews
5. **SEO** - No Open Graph tags, no JSON-LD structured data
6. **WhatsApp button** - Common for Mexican businesses

## Key Files

| File | Description |
|------|-------------|
| `index.html` | Main (and only) HTML file - 1443 lines |
| `logo_meson_estampa.png` | Hotel logo image |

## Working On This Project

When resuming work on this project:
1. Open `index.html` directly in browser to preview
2. Use Chrome DevTools for live editing
3. All assets are CDN-hosted (no local dependencies)
4. Changes reflect immediately on save

## Git Status

- Initial commit: `4cc81ab`
- All changes committed
