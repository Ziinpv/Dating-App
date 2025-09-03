# Firebase Setup Guide

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name (e.g., "dating-app-backend")
4. Enable Google Analytics (optional)
5. Click "Create project"

## 2. Enable Authentication

1. In Firebase Console, go to "Authentication" > "Sign-in method"
2. Enable "Email/Password" provider
3. Enable "Phone" provider (optional)

## 3. Create Firestore Database

1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to your users)

## 4. Generate Service Account Key

1. Go to "Project Settings" (gear icon)
2. Click "Service accounts" tab
3. Click "Generate new private key"
4. Download the JSON file
5. **IMPORTANT**: Keep this file secure and never commit it to version control

## 5. Configure Environment Variables

1. Copy `env.example` to `.env`:
   ```bash
   cp env.example .env
   ```

2. Open the downloaded service account JSON file and copy its contents

3. In your `.env` file, replace the `FIREBASE_SERVICE_ACCOUNT_KEY` value with the entire JSON content as a single line string:

   ```env
   FIREBASE_SERVICE_ACCOUNT_KEY={"type":"service_account","project_id":"your-actual-project-id",...}
   ```

   **Important**: The entire JSON must be on one line with escaped quotes.

## 6. Alternative: Use Individual Environment Variables

If you prefer not to use the JSON string, you can set individual variables:

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYour actual private key\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=your-service-account@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
```

## 7. Test Firebase Connection

Run the server to test Firebase connection:

```bash
npm run dev
```

You should see:
```
✅ Firebase Admin SDK initialized successfully
🚀 Server running on port 3000
```

## 8. Security Rules for Firestore

Add these security rules to your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Matches are readable by both users
    match /matches/{matchId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid in resource.data.userIds);
    }
    
    // Messages are readable by sender and receiver
    match /messages/{messageId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
    }
  }
}
```

## 9. Storage Rules

For Firebase Storage (if using image uploads):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Troubleshooting

### Error: "Firebase Admin SDK initialization failed"
- Check that your service account JSON is valid
- Ensure all required fields are present
- Verify the JSON is properly escaped in the .env file

### Error: "Permission denied"
- Check Firestore security rules
- Verify the service account has proper permissions
- Ensure the project ID matches your Firebase project

### Error: "Invalid private key"
- Make sure the private key includes the full certificate with `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`
- Check that newlines are properly escaped as `\n`
