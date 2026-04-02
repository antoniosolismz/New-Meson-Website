#!/bin/bash

###############################################################################
# Mesón Santa Rosa - Photo Optimization Script
# 
# This script will automatically optimize your photos for web use.
# It creates multiple versions sized for different uses.
#
# REQUIREMENTS: ImageMagick must be installed
#   Ubuntu/Debian: sudo apt-get install imagemagick
#   macOS: brew install imagemagick
#
# USAGE:
#   1. Put all your original photos in a folder called "originals"
#   2. Run this script: bash optimize-photos.sh
#   3. Find optimized photos in the "optimized" folder
###############################################################################

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${RED}Error: ImageMagick is not installed.${NC}"
    echo -e "Install it with:"
    echo -e "  ${YELLOW}Ubuntu/Debian:${NC} sudo apt-get install imagemagick"
    echo -e "  ${YELLOW}macOS:${NC} brew install imagemagick"
    exit 1
fi

# Create directories if they don't exist
mkdir -p originals
mkdir -p optimized

# Count files
file_count=$(find originals -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)

if [ "$file_count" -eq 0 ]; then
    echo -e "${RED}No images found in 'originals/' folder.${NC}"
    echo -e "Please add your photos to the ${YELLOW}originals/${NC} folder first."
    exit 1
fi

echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║    Mesón Santa Rosa Photo Optimization Tool    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Found ${BLUE}$file_count${NC} images to process"
echo ""

counter=0

# Process each image
for img in originals/*.{jpg,jpeg,JPG,JPEG,png,PNG} 2>/dev/null; do
    # Skip if no files found
    [ -e "$img" ] || continue
    
    counter=$((counter + 1))
    filename=$(basename "$img")
    name="${filename%.*}"
    
    echo -e "${YELLOW}[$counter/$file_count]${NC} Processing: ${BLUE}$filename${NC}"
    
    # Hero size (1920x1080, landscape, 85% quality)
    echo -e "  → Creating hero version (1920x1080)..."
    convert "$img" \
        -resize 1920x1080^ \
        -gravity center \
        -extent 1920x1080 \
        -quality 85 \
        -strip \
        "optimized/hero-${name}.jpg" 2>/dev/null
    
    # Section size (1200x800, 82% quality)
    echo -e "  → Creating section version (1200x800)..."
    convert "$img" \
        -resize 1200x800^ \
        -gravity center \
        -extent 1200x800 \
        -quality 82 \
        -strip \
        "optimized/section-${name}.jpg" 2>/dev/null
    
    # Gallery/Card size (800x600, 80% quality)
    echo -e "  → Creating gallery version (800x600)..."
    convert "$img" \
        -resize 800x600^ \
        -gravity center \
        -extent 800x600 \
        -quality 80 \
        -strip \
        "optimized/gallery-${name}.jpg" 2>/dev/null
    
    # Thumbnail size (500x400, 75% quality)
    echo -e "  → Creating thumbnail version (500x400)..."
    convert "$img" \
        -resize 500x400^ \
        -gravity center \
        -extent 500x400 \
        -quality 75 \
        -strip \
        "optimized/thumb-${name}.jpg" 2>/dev/null
    
    echo -e "  ${GREEN}✓ Complete${NC}"
    echo ""
done

echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Optimization Complete!             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Processed: ${GREEN}$counter${NC} images"
echo -e "Output folder: ${YELLOW}optimized/${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. Review images in the ${YELLOW}optimized/${NC} folder"
echo -e "  2. Rename files according to PHOTO_STRATEGY.md guide"
echo -e "  3. Upload to your website"
echo ""

# Calculate total size saved
original_size=$(du -sh originals | cut -f1)
optimized_size=$(du -sh optimized | cut -f1)

echo -e "Original folder size: ${RED}$original_size${NC}"
echo -e "Optimized folder size: ${GREEN}$optimized_size${NC}"
echo ""
echo -e "${BLUE}Check PHOTO_STRATEGY.md for detailed placement instructions!${NC}"
