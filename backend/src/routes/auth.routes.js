const express = require('express');
const { check } = require('express-validator');
const router = express.Router();
const {
  register,
  login,
  getMe,
  logout,
  forgotPassword
} = require('../controllers/auth.controller');
const { protect } = require('../middleware/auth.middleware');

// Validation pour l'inscription
const registerValidation = [
  check('email', 'Veuillez fournir un email valide').isEmail(),
  check('password', 'Le mot de passe doit contenir au moins 6 caractères').isLength({ min: 6 }),
  check('role', 'Le rôle doit être locataire, proprietaire ou admin').isIn(['locataire', 'proprietaire', 'admin']),
  check('nom', 'Le nom est requis').notEmpty(),
  check('prenom', 'Le prénom est requis').notEmpty(),
  check('telephone', 'Le numéro de téléphone est requis').notEmpty()
];

// Validation pour la connexion
const loginValidation = [
  check('email', 'Veuillez fournir un email valide').isEmail(),
  check('password', 'Le mot de passe est requis').exists()
];

// Routes publiques
router.post('/register', registerValidation, register);
router.post('/login', loginValidation, login);
router.post('/forgot-password', [
  check('email', 'Veuillez fournir un email valide').isEmail()
], forgotPassword);

// Routes protégées
router.get('/me', protect, getMe);
router.post('/logout', protect, logout);

module.exports = router;