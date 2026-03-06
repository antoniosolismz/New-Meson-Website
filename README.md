# Mesón Santa Rosa - Hotel Boutique Website

![Mesón Santa Rosa](https://images.unsplash.com/photo-1523699289804-55347c09047d?auto=format&fit=crop&w=1200&q=80)

> Hotel boutique y restaurante en el corazón histórico de Tlaxcala, México. Frente al Ex Convento de San Francisco, Patrimonio de la Humanidad UNESCO.

[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)](https://developer.mozilla.org/es/docs/Web/HTML)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=flat&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Descripción

**Mesón Santa Rosa** es un sitio web de hotel boutique ubicado en el centro histórico de Tlaxcala, México. El proyecto consiste en una página de aterrizaje (landing page) de una sola página que presenta el hotel, sus habitaciones, restaurante, café y galería de imágenes.

### Características Principales

- **Diseño responsive** - Mobile-first, funciona en todos los dispositivos
- **Accesibilidad WCAG AA** - Incluye skip-links, ARIA labels, y contraste adequado
- **Optimizado para SEO** - Meta tags, Open Graph, Twitter Cards, y JSON-LD
- **Rendimiento optimizado** - Lazy loading de imágenes, fuentes optimizadas
- **Animaciones suaves** - Efectos fade-in, hover en tarjetas y galería

## Tecnologías

| Tecnología | Propósito |
|------------|-----------|
| HTML5 | Estructura semántica del sitio |
| Tailwind CSS (CDN) | Estilos y diseño responsive |
| Font Awesome 6.5 | Iconos |
| Google Fonts | Tipografía (Playfair Display, Inter) |
| Vanilla JavaScript | Interactividad (menú móvil, scroll effects) |

## Estructura del Proyecto

```
new-meson-santa-rosa/
├── index.html              # Sitio principal (single-page)
├── logo_meson_estampa.png  # Logo del hotel
├── README.md               # Este archivo
└── .git/                   # Repositorio Git
```

## Secciones del Sitio

1. **Header/Navegación** - Logo, menú desktop y móvil, botón de reserva
2. **Hero** - Imagen principal, widgets flotantes de reserva y reseñas
3. **Bienvenida** - Presentación del hotel y tarjetas de características
4. **Habitaciones** - Habitación Estándar y Doble con precios
5. **Restaurante & Bar** - Galería de alimentos y información gastronómica
6. **Café** - Sección del rincón del café con terraza
7. **Galería** - Imágenes del hotel y alrededores
8. **Contacto** - Información de ubicación y contacto

## Desarrollo Local

### Ver el Sitio

Dado que es un sitio estático, no requiere build. Puedes abrirlo directamente:

```bash
# Opción 1: Abrir directamente en navegador
open index.html

# Opción 2: Servidor local con Python
python -m http.server 8000

# Opción 3: Servidor local con Node.js
npx serve .

# Opción 4: Servidor local con PHP
php -S localhost:8000
```

Luego visita `http://localhost:8000` en tu navegador.

### Validación

- **HTML**: [W3C Validator](https://validator.w3.org/)
- **Accesibilidad**: axe DevTools o Lighthouse
- **Rendimiento**: Google Lighthouse o PageSpeed Insights

## Paleta de Colores

| Color | Hex | Uso |
|-------|-----|-----|
| Pink Mesón | `#E90065` | Acentos, botones, iconos |
| Brown Heading | `#4A3525` | Títulos, encabezados |
| Brown Body | `#5C4A42` | Texto del cuerpo |
| Cream BG | `#FDFBF7` | Fondo principal |

## Tipografía

- **Títulos**: Playfair Display (serif)
- **Cuerpo**: Inter (sans-serif)

## Despliegue

El sitio puede desplegarse en cualquier hosting estático:

- **Netlify**: Arrastra y suelta los archivos
- **Vercel**: Conecta el repositorio
- **GitHub Pages**: Activa en configuración del repositorio
- **Cualquier hosting**: Sube `index.html` y `logo_meson_estampa.png`

## Contributing

1. Fork el repositorio
2. Crea tu rama de feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - voir el archivo [LICENSE](LICENSE) para detalles.

## Contacto

- **Sitio web**: https://santarosameson.com
- **Ubicación**: Calle Principal s/n, Centro Histórico, Tlaxcala, México
- **Teléfono**: +52 246 123 4567

---

Desarrollado con ❤️ en Tlaxcala, México
