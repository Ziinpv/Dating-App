#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function setupEnvironment() {
  console.log('🔧 Setting up environment variables for Dating App Backend\n');
  
  try {
    // Check if .env already exists
    const envPath = path.join(__dirname, '.env');
    if (fs.existsSync(envPath)) {
      const overwrite = await question('⚠️  .env file already exists. Overwrite? (y/N): ');
      if (overwrite.toLowerCase() !== 'y') {
        console.log('❌ Setup cancelled.');
        rl.close();
        return;
      }
    }

    console.log('📝 Please provide the following information:\n');

    // Basic configuration
    const port = await question('Port (default: 3000): ') || '3000';
    const nodeEnv = await question('Node Environment (development/production) [development]: ') || 'development';
    const frontendUrl = await question('Frontend URL (default: http://localhost:3000): ') || 'http://localhost:3000';
    
    // JWT secrets
    const jwtSecret = await question('JWT Secret (generate a random string): ');
    const jwtRefreshSecret = await question('JWT Refresh Secret (generate another random string): ');
    
    // Firebase configuration
    console.log('\n🔥 Firebase Configuration:');
    const firebaseProjectId = await question('Firebase Project ID: ');
    const firebaseStorageBucket = await question('Firebase Storage Bucket (default: project-id.appspot.com): ') || `${firebaseProjectId}.appspot.com`;
    
    console.log('\n📁 Firebase Service Account Key:');
    console.log('You can either:');
    console.log('1. Provide the path to your service account JSON file');
    console.log('2. Paste the JSON content directly');
    console.log('3. Skip and configure manually later');
    
    const keyOption = await question('Choose option (1/2/3): ');
    let firebaseServiceAccountKey = '';
    
    if (keyOption === '1') {
      const keyPath = await question('Path to service account JSON file: ');
      try {
        const keyContent = fs.readFileSync(keyPath, 'utf8');
        firebaseServiceAccountKey = JSON.stringify(JSON.parse(keyContent));
      } catch (error) {
        console.log('❌ Error reading file:', error.message);
        console.log('⚠️  You can configure Firebase manually later.');
      }
    } else if (keyOption === '2') {
      console.log('Paste your service account JSON content (press Enter twice when done):');
      let jsonLines = [];
      let emptyLineCount = 0;
      
      while (true) {
        const line = await question('');
        if (line === '') {
          emptyLineCount++;
          if (emptyLineCount >= 2) break;
        } else {
          emptyLineCount = 0;
          jsonLines.push(line);
        }
      }
      
      try {
        const jsonContent = jsonLines.join('\n');
        firebaseServiceAccountKey = JSON.stringify(JSON.parse(jsonContent));
      } catch (error) {
        console.log('❌ Invalid JSON:', error.message);
        console.log('⚠️  You can configure Firebase manually later.');
      }
    }

    // Create .env content
    const envContent = `# Server Configuration
PORT=${port}
NODE_ENV=${nodeEnv}
FRONTEND_URL=${frontendUrl}

# JWT Configuration
JWT_SECRET=${jwtSecret}
JWT_REFRESH_SECRET=${jwtRefreshSecret}

# Firebase Configuration
${firebaseServiceAccountKey ? `FIREBASE_SERVICE_ACCOUNT_KEY=${firebaseServiceAccountKey}` : '# FIREBASE_SERVICE_ACCOUNT_KEY=your-service-account-json-here'}
FIREBASE_PROJECT_ID=${firebaseProjectId}
FIREBASE_STORAGE_BUCKET=${firebaseStorageBucket}

# Cloudinary Configuration (for image uploads)
CLOUDINARY_CLOUD_NAME=your-cloudinary-cloud-name
CLOUDINARY_API_KEY=your-cloudinary-api-key
CLOUDINARY_API_SECRET=your-cloudinary-api-secret

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# CORS Configuration
CORS_ORIGIN=${frontendUrl}
`;

    // Write .env file
    fs.writeFileSync(envPath, envContent);
    
    console.log('\n✅ Environment file created successfully!');
    console.log(`📁 Location: ${envPath}`);
    
    if (!firebaseServiceAccountKey) {
      console.log('\n⚠️  Firebase not configured. Please:');
      console.log('1. Follow the FIREBASE_SETUP.md guide');
      console.log('2. Add your FIREBASE_SERVICE_ACCOUNT_KEY to .env');
    }
    
    console.log('\n🚀 Next steps:');
    console.log('1. Install dependencies: npm install');
    console.log('2. Start the server: npm run dev');
    
  } catch (error) {
    console.error('❌ Setup failed:', error.message);
  } finally {
    rl.close();
  }
}

// Run setup
setupEnvironment();
