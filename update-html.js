#!/usr/bin/env node

/**
 * Update HTML to reference optimized images
 * 
 * This script updates index.html to use /assets/optimized/ instead of /assets/originals/
 */

const fs = require('fs').promises;
const path = require('path');

// Colors for terminal output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

const log = {
  info: (msg) => console.log(`${colors.cyan}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  warning: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`)
};

async function updateHtmlReferences() {
  console.log(`
${colors.green}╔══════════════════════════════════════════════════╗
║        Update HTML Image References             ║
╚══════════════════════════════════════════════════╝${colors.reset}
  `);

  const htmlFile = './index.html';

  try {
    // Read the HTML file
    log.info(`Reading ${htmlFile}...`);
    let content = await fs.readFile(htmlFile, 'utf8');

    // Count occurrences before replacement
    const originalMatches = content.match(/\/assets\/originals\//g);
    const countBefore = originalMatches ? originalMatches.length : 0;

    log.info(`Found ${colors.blue}${countBefore}${colors.reset} references to /assets/originals/`);

    // Replace all occurrences of /assets/originals/ with /assets/optimized/
    const updatedContent = content.replace(/\/assets\/originals\//g, '/assets/optimized/');

    // Count occurrences after replacement
    const optimizedMatches = updatedContent.match(/\/assets\/optimized\//g);
    const countAfter = optimizedMatches ? optimizedMatches.length : 0;

    // Create backup
    const backupFile = './index.html.backup';
    log.info(`Creating backup: ${backupFile}`);
    await fs.writeFile(backupFile, content, 'utf8');

    // Write updated content
    log.info('Writing updated HTML...');
    await fs.writeFile(htmlFile, updatedContent, 'utf8');

    console.log(`
${colors.green}╔══════════════════════════════════════════════════╗
║              Update Complete!                   ║
╚══════════════════════════════════════════════════╝${colors.reset}

${colors.green}Summary:${colors.reset}
  File: ${colors.blue}${htmlFile}${colors.reset}
  Updated: ${colors.green}${countAfter}${colors.reset} image references
  Backup: ${colors.yellow}${backupFile}${colors.reset}

${colors.cyan}Next Steps:${colors.reset}
  1. Open ${colors.yellow}index.html${colors.reset} in a browser to test
  2. Verify all images load correctly
  3. If there are issues, restore from ${colors.yellow}${backupFile}${colors.reset}
  4. Commit changes when satisfied
    `);

  } catch (error) {
    console.error(`${colors.reset}✗ Error: ${error.message}`);
    process.exit(1);
  }
}

// Run the script
updateHtmlReferences();
