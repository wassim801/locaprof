const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const validator = require('validator');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: [true, 'Email est requis'],
    unique: true,
    lowercase: true,
    trim: true,
    validate: [validator.isEmail, 'Format d\'email invalide'],
    index: true
  },
  password: {
    type: String,
    required: [true, 'Mot de passe est requis'],
    minlength: 6,
    select: false
  },
  role: {
    type: String,
    enum: ['locataire', 'proprietaire', 'admin'],
    default: 'locataire'
  },
  nom: {
    type: String,
    required: [true, 'Nom est requis'],
    trim: true
  },
  prenom: {
    type: String,
    required: [true, 'Prénom est requis'],
    trim: true
  },
  telephone: {
    type: String,
    required: [true, 'Numéro de téléphone est requis'],
    validate: {
      validator: function(v) {
        return /^\+?[1-9]\d{1,14}$/.test(v);
      },
      message: 'Format de numéro de téléphone invalide'
    }
  },
  dateNaissance: {
    type: Date,
    required: [true, 'Date de naissance est requise']
  },
  adresse: {
    rue: {
      type: String,
      required: [true, 'Rue est requise'],
      trim: true
    },
    ville: {
      type: String,
      required: [true, 'Ville est requise'],
      trim: true
    },
    codePostal: {
      type: String,
      required: [true, 'Code postal est requis'],
      validate: {
        validator: function(v) {
          return /^\d{5}$/.test(v);
        },
        message: 'Format de code postal invalide'
      }
    },
    pays: {
      type: String,
      required: [true, 'Pays est requis'],
      trim: true
    }
  },
  pieceIdentite: {
    type: String,
    required: [true, 'Pièce d\'identité est requise']
  },
  justificatifDomicile: {
    type: String,
    required: function() { return this.role === 'locataire'; }
  },
  justificatifRevenu: {
    type: String,
    required: function() { return this.role === 'locataire'; }
  },
  firebaseUID: {
    type: String,
    unique: true,
    sparse: true
  },
  stripeCustomerId: {
    type: String,
    unique: true,
    sparse: true
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  isActive: {
    type: Boolean,
    default: true
  },
  lastLogin: Date,
  resetPasswordToken: String,
  resetPasswordExpire: Date
}, {
  timestamps: true
});

// Crypter le mot de passe avant la sauvegarde
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) {
    next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Méthode pour vérifier le mot de passe
userSchema.methods.comparePassword = async function(enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Méthode pour générer un token de réinitialisation de mot de passe
userSchema.methods.getResetPasswordToken = function() {
  const resetToken = crypto.randomBytes(20).toString('hex');
  
  // Hasher le token et le stocker dans la base de données
  this.resetPasswordToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');

  // Définir l'expiration du token (30 minutes)
  this.resetPasswordExpire = Date.now() + 30 * 60 * 1000;

  return resetToken;
};

// Méthode pour vérifier si le compte est actif
userSchema.methods.isAccountActive = function() {
  return this.isActive && this.isVerified;
};

// Méthode pour mettre à jour la dernière connexion
userSchema.methods.updateLastLogin = function() {
  this.lastLogin = Date.now();
  return this.save();
};

// Index composé pour les recherches fréquentes
userSchema.index({ role: 1, isActive: 1 });
userSchema.index({ email: 1, isVerified: 1 });

// Middleware pour nettoyer les tokens expirés
userSchema.pre('save', function(next) {
  if (this.resetPasswordExpire && this.resetPasswordExpire < Date.now()) {
    this.resetPasswordToken = undefined;
    this.resetPasswordExpire = undefined;
  }
  next();
});



const User = mongoose.model('User', userSchema);

module.exports = User;


