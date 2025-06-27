require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/user.model');
const admin = require('firebase-admin');

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

async function createAdminUser() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    const adminData = {
      email: 'admin@locapro.com',
      password: 'Admin123!',
      role: 'admin',
      nom: 'Admin',
      prenom: 'Super',
      telephone: '+212600000000',
      dateNaissance: new Date('1990-01-01'),
      isActive: true
    };

    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: adminData.email });
    if (existingAdmin) {
      console.log('Admin user already exists');
      process.exit(0);
    }

    // Create user in Firebase
    const firebaseUser = await admin.auth().createUser({
      email: adminData.email,
      password: adminData.password,
      displayName: `${adminData.prenom} ${adminData.nom}`
    });

    // Create user in MongoDB
    adminData.firebaseUID = firebaseUser.uid;
    const user = await User.create(adminData);

    console.log('Admin user created successfully:', {
      id: user._id,
      email: user.email,
      role: user.role
    });

    // Store these credentials securely:
    console.log('\nAdmin Credentials (STORE SECURELY):');
    console.log('Email:', adminData.email);
    console.log('Password:', adminData.password);

  } catch (error) {
    console.error('Error creating admin user:', error);
  } finally {
    await mongoose.disconnect();
  }
}

createAdminUser();