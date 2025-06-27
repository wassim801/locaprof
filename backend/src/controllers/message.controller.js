const { Message, Conversation } = require('../models/message.model');
const { validationResult } = require('express-validator');

// @desc    Créer une nouvelle conversation
// @route   POST /api/messages/conversations
// @access  Private
exports.createConversation = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const { participants, property, booking } = req.body;

    // Vérifier si une conversation existe déjà
    let conversation = await Conversation.findOne({
      participants: { $all: participants },
      property: property
    });

    if (conversation) {
      return res.status(400).json({
        success: false,
        message: 'Une conversation existe déjà'
      });
    }

    conversation = await Conversation.create({
      participants,
      property,
      booking
    });

    res.status(201).json({
      success: true,
      data: conversation
    });
  } catch (error) {
    console.error('Erreur lors de la création de la conversation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de la conversation'
    });
  }
};

// @desc    Obtenir les conversations d'un utilisateur
// @route   GET /api/messages/conversations
// @access  Private
exports.getConversations = async (req, res) => {
  try {
    const conversations = await Conversation.find({
      participants: req.user.id,
      statut: { $ne: 'supprime' }
    })
      .populate('participants', 'nom prenom email')
      .populate('property', 'titre photos')
      .populate('dernierMessage')
      .sort('-updatedAt');

    res.status(200).json({
      success: true,
      count: conversations.length,
      data: conversations
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des conversations:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des conversations'
    });
  }
};

// @desc    Envoyer un message
// @route   POST /api/messages
// @access  Private
exports.sendMessage = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const { conversation: conversationId, destinataire, contenu, type } = req.body;

    // Vérifier si la conversation existe
    const conversation = await Conversation.findById(conversationId);
    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: 'Conversation non trouvée'
      });
    }

    // Vérifier si l'utilisateur fait partie de la conversation
    if (!conversation.participants.includes(req.user.id)) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à envoyer des messages dans cette conversation'
      });
    }

    // Créer le message
    const message = await Message.create({
      conversation: conversationId,
      expediteur: req.user.id,
      destinataire,
      contenu,
      type
    });

    // Mettre à jour la conversation
    conversation.dernierMessage = message._id;
    await conversation.incrementerNonLus(destinataire);
    await conversation.save();

    // Envoyer une notification Firebase si configuré
    // TODO: Implémenter les notifications Firebase

    res.status(201).json({
      success: true,
      data: message
    });
  } catch (error) {
    console.error('Erreur lors de l\'envoi du message:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'envoi du message'
    });
  }
};

// @desc    Obtenir les messages d'une conversation
// @route   GET /api/messages/conversations/:id
// @access  Private
exports.getMessages = async (req, res) => {
  try {
    const conversation = await Conversation.findById(req.params.id);
    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: 'Conversation non trouvée'
      });
    }

    // Vérifier l'accès
    if (!conversation.participants.includes(req.user.id)) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à accéder à cette conversation'
      });
    }

    // Pagination
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 50;
    const startIndex = (page - 1) * limit;

    const messages = await Message.find({
      conversation: req.params.id,
      'supprime.expediteur': false,
      'supprime.destinataire': false
    })
      .sort('-createdAt')
      .skip(startIndex)
      .limit(limit)
      .populate('expediteur', 'nom prenom');

    // Marquer les messages comme lus
    await conversation.marquerCommeLu(req.user.id);

    res.status(200).json({
      success: true,
      count: messages.length,
      data: messages.reverse() // Renvoyer dans l'ordre chronologique
    });
  } catch (error) {
    console.error('Erreur lors de la récupération des messages:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des messages'
    });
  }
};

// @desc    Marquer une conversation comme archivée
// @route   PUT /api/messages/conversations/:id/archive
// @access  Private
exports.archiveConversation = async (req, res) => {
  try {
    const conversation = await Conversation.findById(req.params.id);
    if (!conversation) {
      return res.status(404).json({
        success: false,
        message: 'Conversation non trouvée'
      });
    }

    if (!conversation.participants.includes(req.user.id)) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à archiver cette conversation'
      });
    }

    conversation.statut = 'archive';
    await conversation.save();

    res.status(200).json({
      success: true,
      message: 'Conversation archivée avec succès'
    });
  } catch (error) {
    console.error('Erreur lors de l\'archivage de la conversation:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'archivage de la conversation'
    });
  }
};