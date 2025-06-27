const jwt = require('jsonwebtoken');
const User = require('../models/user.model');

// Middleware pour protéger les routes
exports.protect = async (req, res, next) => {
  try {
    let token;

    // Vérifier si le token est présent dans les headers
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Accès non autorisé. Veuillez vous connecter.'
      });
    }

    try {
      // Vérifier le token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Vérifier si l'utilisateur existe toujours
      const user = await User.findById(decoded.id);
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Utilisateur non trouvé'
        });
      }

      // Vérifier si l'utilisateur est actif
      if (!user.isActive) {
        return res.status(401).json({
          success: false,
          message: 'Votre compte a été désactivé'
        });
      }

      // Ajouter l'utilisateur à la requête
      req.user = user;
      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Token invalide ou expiré'
      });
    }
  } catch (error) {
    console.error('Erreur d\'authentification:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'authentification'
    });
  }
};

// Middleware pour vérifier les rôles
exports.authorize = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: `Le rôle ${req.user.role} n'est pas autorisé à accéder à cette ressource`
      });
    }
    next();
  };
};
exports.admin =(model)=> (req, res, next) => {
  if (moddel.user && model.user.role === 'admin') {
    next();
  } else {
    res.status(403);
    throw new Error('Non autorisé, admin seulement');
  }
};
// Middleware pour vérifier la propriété d'une ressource
exports.checkOwnership = (model) => async (req, res, next) => {
  try {
    const resource = await model.findById(req.params.id);

    if (!resource) {
      return res.status(404).json({
        success: false,
        message: 'Ressource non trouvée'
      });
    }

    // Vérifier si l'utilisateur est propriétaire ou admin
    if (req.user.role !== 'admin' && 
        resource.proprietaire.toString() !== req.user.id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à accéder à cette ressource'
      });
    }

    req.resource = resource;
    next();
  } catch (error) {
    console.error('Erreur lors de la vérification de la propriété:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la vérification de la propriété'
    });
  }
};

// Middleware pour la validation Firebase
exports.validateFirebaseToken = async (req, res, next) => {
  try {
    const firebaseToken = req.headers['firebase-token'];

    if (!firebaseToken) {
      return res.status(401).json({
        success: false,
        message: 'Token Firebase manquant'
      });
    }

    try {
      const decodedToken = await admin.auth().verifyIdToken(firebaseToken);
      req.firebaseUser = decodedToken;
      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        message: 'Token Firebase invalide'
      });
    }
  } catch (error) {
    console.error('Erreur lors de la validation Firebase:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la validation Firebase'
    });
  }
};