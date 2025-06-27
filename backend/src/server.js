require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const User = require('../src/models/user.model');
const corsOptions = {
  origin: 'http://localhost:5173', // Your frontend origin
  credentials: true, // Allow credentials
  allowedHeaders: ['Content-Type', 'Authorization']
};
const adminData = {
  email: 'admin@locapro.com',
  password: 'Admin123!',
  role: 'admin',
  nom: 'Admin',
  prenom: 'Super',
  telephone: '+212600000000',
  dateNaissance: new Date('1990-01-01'),
  adresse: {
    rue: '123 Admin Street',
    ville: 'Admin City',
    codePostal: '12345',
    pays: 'Morocco'
  },
  pieceIdentite: 'admin-passport-123',
  isVerified: true,
  isActive: true
};

// Initialisation de l'application Express
const app = express();

// Middleware de sécurité et utilitaires
app.use(helmet());
app.use(cors(corsOptions));
app.use(express.json());
app.use(morgan('dev'));

// Configuration de la base de données MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  retryWrites: true,
  w: 'majority',
  maxPoolSize: 10,
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
  family: 4
})
.then(() => console.log('Connexion à MongoDB établie'))
.catch(err => console.error('Erreur de connexion à MongoDB:', err));

// Gestion des événements MongoDB
mongoose.connection.on('error', err => {
  console.error('Erreur MongoDB:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('MongoDB déconnecté - tentative de reconnexion...');
});

mongoose.connection.on('reconnected', () => {
  console.log('MongoDB reconnecté avec succès');
});
   
// Routes API
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/users', require('./routes/user.routes'));
app.use('/api/properties', require('./routes/property.routes'));
app.use('/api/bookings', require('./routes/booking.routes'));
app.use('/api/messages', require('./routes/message.routes'));

// Middleware de gestion des erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Une erreur est survenue sur le serveur',
    error: process.env.NODE_ENV === 'development' ? err : {}
  });
});
// Démarrage du serveur
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});