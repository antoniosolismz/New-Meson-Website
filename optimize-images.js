#!/usr/bin/env node

/**
 * Mesón Santa Rosa - Image Optimization Script
 * 
 * This script optimizes all images in /assets/originals/ for web use.
 * It creates optimized versions in /assets/optimized/ with the same directory structure.
 * 
 * Features:
 * - Resizes images to max 1920px width (maintains aspect ratio)
 * - Compresses JPEG quality to 85% (optimal web quality)
 * - Strips metadata (EXIF, etc.) to reduce file size
 * - Preserves directory structure
 * - Provides detailed progress and size savings
 */

const sharp = require('sharp');
const fs = require('fs').promises;
const path = require('path');

// Configuration
const CONFIG = {
  sourceDir: './assets/originals',
  targetDir: './assets/optimized',
  maxWidth: 1920,
  maxHeight: 1920,
  quality: 85,
  progressive: true,
  stripMetadata: true
};

// Colors for terminal output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

// Utility functions
const log = {
  info: (msg) => console.log(`${colors.cyan}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`),
  warning: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
  progress: (current, total, filename) => {
    console.log(`${colors.yellow}[${current}/${total}]${colors.reset} Processing: ${colors.blue}${filename}${colors.reset}`);
  }
};

function formatBytes(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

async function getFileSize(filePath) {
  try {
    const stats = await fs.stat(filePath);
    return stats.size;
  } catch (error) {
    return 0;
  }
}

async function getAllImages(dir, baseDir = dir) {
  const images = [];
  const entries = await fs.readdir(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      const subImages = await getAllImages(fullPath, baseDir);
      images.push(...subImages);
    } else if (/\.(jpe?g|png)$/i.test(entry.name)) {
      const relativePath = path.relative(baseDir, fullPath);
      images.push({
        fullPath,
        relativePath,
        name: entry.name,
        dir: path.dirname(relativePath)
      });
    }
  }

  return images;
}

async function optimizeImage(sourceFile, targetFile) {
  try {
    // Get original file size
    const originalSize = await getFileSize(sourceFile);

    // Create target directory if it doesn't exist
    const targetDir = path.dirname(targetFile);
    await fs.mkdir(targetDir, { recursive: true });

    // Get image metadata to check dimensions
    const metadata = await sharp(sourceFile).metadata();
    
    // Optimize the image
    await sharp(sourceFile)
      .resize(CONFIG.maxWidth, CONFIG.maxHeight, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .jpeg({
        quality: CONFIG.quality,
        progressive: CONFIG.progressive,
        mozjpeg: true
      })
      .withMetadata(false) // Strip all metadata
      .toFile(targetFile);

    // Get optimized file size
    const optimizedSize = await getFileSize(targetFile);
    const savings = originalSize - optimizedSize;
    const savingsPercent = ((savings / originalSize) * 100).toFixed(1);

    return {
      success: true,
      originalSize,
      optimizedSize,
      savings,
      savingsPercent,
      originalDimensions: `${metadata.width}x${metadata.height}`
    };
  } catch (error) {
    return {
      success: false,
      error: error.message
    };
  }
}

async function main() {
  console.log(`
${colors.green}╔══════════════════════════════════════════════════╗
║    Mesón Santa Rosa Image Optimization Tool     ║
╚══════════════════════════════════════════════════╝${colors.reset}
  `);

  // Check if source directory exists
  try {
    await fs.access(CONFIG.sourceDir);
  } catch (error) {
    log.error(`Source directory not found: ${CONFIG.sourceDir}`);
    process.exit(1);
  }

  // Get all images
  log.info('Scanning for images...');
  const images = await getAllImages(CONFIG.sourceDir);

  if (images.length === 0) {
    log.warning('No images found to optimize.');
    process.exit(0);
  }

  log.success(`Found ${colors.blue}${images.length}${colors.reset} images to process\n`);

  // Statistics
  let totalOriginalSize = 0;
  let totalOptimizedSize = 0;
  let successCount = 0;
  let errorCount = 0;

  // Process each image
  for (let i = 0; i < images.length; i++) {
    const image = images[i];
    const sourceFile = image.fullPath;
    const targetFile = path.join(CONFIG.targetDir, image.relativePath);

    log.progress(i + 1, images.length, image.relativePath);

    const result = await optimizeImage(sourceFile, targetFile);

    if (result.success) {
      successCount++;
      totalOriginalSize += result.originalSize;
      totalOptimizedSize += result.optimizedSize;

      console.log(`  ${colors.cyan}Original:${colors.reset} ${formatBytes(result.originalSize)} (${result.originalDimensions})`);
      console.log(`  ${colors.green}Optimized:${colors.reset} ${formatBytes(result.optimizedSize)}`);
      console.log(`  ${colors.magenta}Saved:${colors.reset} ${formatBytes(result.savings)} (${result.savingsPercent}%)\n`);
    } else {
      errorCount++;
      log.error(`Failed to optimize: ${result.error}\n`);
    }
  }

  // Summary
  const totalSavings = totalOriginalSize - totalOptimizedSize;
  const totalSavingsPercent = ((totalSavings / totalOriginalSize) * 100).toFixed(1);

  console.log(`
${colors.green}╔══════════════════════════════════════════════════╗
║            Optimization Complete!               ║
╚══════════════════════════════════════════════════╝${colors.reset}

${colors.green}Summary:${colors.reset}
  Processed: ${colors.green}${successCount}${colors.reset} images
  Failed: ${errorCount > 0 ? colors.red : colors.green}${errorCount}${colors.reset} images
  
${colors.blue}Size Comparison:${colors.reset}
  Original size: ${colors.red}${formatBytes(totalOriginalSize)}${colors.reset}
  Optimized size: ${colors.green}${formatBytes(totalOptimizedSize)}${colors.reset}
  Total saved: ${colors.magenta}${formatBytes(totalSavings)}${colors.reset} (${totalSavingsPercent}%)

${colors.cyan}Next Steps:${colors.reset}
  1. Review images in ${colors.yellow}${CONFIG.targetDir}${colors.reset}
  2. Run: ${colors.yellow}node update-html.js${colors.reset} to update HTML references
  3. Test the website to ensure all images load correctly
  `);
}

// Run the script
main().catch((error) => {
  log.error(`Script failed: ${error.message}`);
  console.error(error);
  process.exit(1);
});
