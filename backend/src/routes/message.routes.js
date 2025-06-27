const express = require('express');
const { check } = require('express-validator');
const router = express.Router();

const {
  createConversation,
  getConversations,
  sendMessage,
  getMessages,
  archiveConversation
} = require('../controllers/message.controller');

const { protect } = require('../middleware/auth.middleware');

// Validation pour la création d'une conversation
const conversationValidation = [
  check('participants', 'Au moins deux participants sont requis')
    .isArray()
    .isLength({ min: 2 }),
  check('participants.*', 'ID de participant invalide').isMongoId(),
  check('property', 'ID de propriété invalide').optional().isMongoId(),
  check('booking', 'ID de réservation invalide').optional().isMongoId()
];

// Validation pour l'envoi d'un message
const messageValidation = [
  check('conversation', 'ID de conversation invalide').isMongoId(),
  check('destinataire', 'ID de destinataire invalide').isMongoId(),
  check('contenu', 'Le contenu du message est requis').notEmpty(),
  check('type', 'Type de message invalide')
    .optional()
    .isIn(['texte', 'image', 'document', 'systeme'])
];

// Routes des conversations
router
  .route('/conversations')
  .post(protect, conversationValidation, createConversation)
  .get(protect, getConversations);

router
  .route('/conversations/:id')
  .get(protect, getMessages);

router
  .route('/conversations/:id/archive')
  .put(protect, archiveConversation);

// Routes des messages
router
  .route('/')
  .post(protect, messageValidation, sendMessage);

module.exports = router;