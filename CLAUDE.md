# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static website for Oksana Security, a professional security and receptionist services business in Dutch. The website is built with pure HTML, CSS, and vanilla JavaScript without any build tools or frameworks.

## Architecture

- **Main files**: `index.html` (main website), `cv.html` (professional CV page)
- **All CSS and JavaScript is inline** within HTML files - no separate stylesheets or scripts
- **Static deployment** via GitHub Pages with automatic deployment on main branch pushes
- **Language**: Dutch (nl locale)
- **Responsive design** with mobile-first approach and hamburger menu

## Development Commands

Since this is a static website with no build process:

```bash
# No build, test, or lint commands available
# For local development, simply open HTML files in browser
# Or serve with any static file server like:
python -m http.server 8000
```

## Deployment

- **Automatic deployment** via GitHub Actions (`.github/workflows/static.yml`)
- Triggers on pushes to `main` branch
- Deploys entire repository to GitHub Pages

## Key Features

- **Contact form** with JavaScript validation and mailto functionality
- **Professional photo**: Currently using `foto_oksana.jpeg`
- **Smooth scrolling navigation** with CSS animations
- **Print-optimized CV page** without print button for cleaner appearance
- **CSS Grid/Flexbox layouts** for responsive design

## Code Structure

- All styling uses **CSS custom properties** for consistent theming
- **Semantic HTML** structure with proper accessibility considerations
- **Mobile breakpoints** implemented with CSS media queries
- **Font Awesome icons** and Google Fonts (Inter) integration

## Docker Deployment

Docker configuration is available for easy deployment:

```bash
# Build and start container
sudo docker-compose up --build -d

# Access website at http://localhost:3000

# Stop container
sudo docker-compose down

# View logs
sudo docker-compose logs -f
```

## Data Directory

The `data/` directory contains business documents organized by category (bu/, cv/, leger_des_heils/, uwv/, vergunning/, website/) - these are not part of the web application but stored for business purposes.