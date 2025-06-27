const admin = require('firebase-admin');

const initializeFirebase = () => {
  try {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
      }),
      // Autres configurations Firebase si nécessaire
    });

    console.log('Firebase Admin SDK initialisé avec succès');
  } catch (error) {
    console.error('Erreur lors de l\'initialisation de Firebase:', error);
    process.exit(1);
  }
};

// Fonction utilitaire pour envoyer des notifications
const sendNotification = async (token, notification) => {
  try {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body
      },
      data: notification.data || {},
      token: token
    };

    const response = await admin.messaging().send(message);
    console.log('Notification envoyée avec succès:', response);
    return response;
  } catch (error) {
    console.error('Erreur lors de l\'envoi de la notification:', error);
    throw error;
  }
};

// Fonction utilitaire pour envoyer des notifications à plusieurs utilisateurs
const sendMulticastNotification = async (tokens, notification) => {
  try {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body
      },
      data: notification.data || {},
      tokens: tokens
    };

    const response = await admin.messaging().sendMulticast(message);
    console.log(
      `Notifications envoyées avec succès: ${response.successCount}/${tokens.length}`
    );
    return response;
  } catch (error) {
    console.error('Erreur lors de l\'envoi des notifications:', error);
    throw error;
  }
};

// Fonction utilitaire pour vérifier un token Firebase
const verifyToken = async (idToken) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    console.error('Erreur lors de la vérification du token:', error);
    throw error;
  }
};

module.exports = {
  initializeFirebase,
  sendNotification,
  sendMulticastNotification,
  verifyToken
};