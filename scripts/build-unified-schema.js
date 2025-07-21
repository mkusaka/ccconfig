#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const $RefParser = require('@apidevtools/json-schema-ref-parser');

async function buildUnifiedSchema() {
  const schemaDir = path.join(__dirname, '..', 'schemas');
  const outputPath = path.join(schemaDir, 'claude-code-config.unified.schema.json');

  try {
    // Load and dereference the master schema
    const masterSchemaPath = path.join(schemaDir, 'claude-code-config.schema.json');
    const unifiedSchema = await $RefParser.dereference(masterSchemaPath);

    // Recursively clean up all $id and $schema references
    function cleanupIds(obj) {
      if (typeof obj !== 'object' || obj === null) return;
      
      // Remove $id references
      delete obj.$id;
      
      // Remove $schema except at the root level
      if (obj !== unifiedSchema) {
        delete obj.$schema;
      }
      
      // Recursively clean nested objects
      for (const key in obj) {
        if (typeof obj[key] === 'object') {
          cleanupIds(obj[key]);
        }
      }
    }
    
    cleanupIds(unifiedSchema);
    
    // Write the unified schema
    fs.writeFileSync(
      outputPath,
      JSON.stringify(unifiedSchema, null, 2) + '\n'
    );

    console.log(`✅ Unified schema created: ${outputPath}`);
    console.log(`📏 Size: ${(fs.statSync(outputPath).size / 1024).toFixed(2)} KB`);
  } catch (error) {
    console.error('❌ Error building unified schema:', error);
    process.exit(1);
  }
}

buildUnifiedSchema();