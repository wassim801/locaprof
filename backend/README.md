# LocaPro - Backend API

## Description
Backend API pour l'application LocaPro de gestion locative. Cette API fournit toutes les fonctionnalités nécessaires pour gérer les locations, les utilisateurs, les paiements et les communications entre locataires et propriétaires.

## Technologies utilisées
- Node.js
- Express.js
- MongoDB avec Mongoose
- Firebase Admin SDK
- Stripe pour les paiements
- JWT pour l'authentification

## Prérequis
- Node.js (v14 ou supérieur)
- MongoDB (v4.4 ou supérieur)
- Compte Firebase
- Compte Stripe

## Installation

1. Cloner le repository :
```bash
git clone <repository-url>
cd backend
```

2. Installer les dépendances :
```bash
npm install
```

3. Configurer les variables d'environnement :
Créer un fichier `.env` à la racine du projet et ajouter les variables suivantes :
```env
# Configuration du serveur
PORT=5000
NODE_ENV=development

# Base de données MongoDB
MONGODB_URI=votre_uri_mongodb

# JWT
JWT_SECRET=votre_secret_jwt
JWT_EXPIRE=24h

# Firebase Admin SDK
FIREBASE_PROJECT_ID=votre_project_id
FIREBASE_PRIVATE_KEY=votre_private_key
FIREBASE_CLIENT_EMAIL=votre_client_email

# Stripe
STRIPE_SECRET_KEY=votre_stripe_secret_key
STRIPE_WEBHOOK_SECRET=votre_stripe_webhook_secret
```

4. Démarrer le serveur :
```bash
# Mode développement
npm run dev

# Mode production
npm start
```

## Structure du projet
```
src/
├── config/         # Configuration (Firebase, Stripe)
├── controllers/    # Contrôleurs
├── middleware/     # Middleware (auth, validation)
├── models/         # Modèles Mongoose
├── routes/         # Routes API
└── server.js       # Point d'entrée
```

## API Endpoints

### Authentification
- POST `/api/auth/register` - Inscription
- POST `/api/auth/login` - Connexion
- GET `/api/auth/me` - Profil utilisateur
- POST `/api/auth/logout` - Déconnexion

### Propriétés
- GET `/api/properties` - Liste des propriétés
- POST `/api/properties` - Créer une propriété
- GET `/api/properties/:id` - Détails d'une propriété
- PUT `/api/properties/:id` - Modifier une propriété
- DELETE `/api/properties/:id` - Supprimer une propriété

### Réservations
- GET `/api/bookings` - Liste des réservations
- POST `/api/bookings` - Créer une réservation
- GET `/api/bookings/:id` - Détails d'une réservation
- PUT `/api/bookings/:id` - Modifier une réservation
- POST `/api/bookings/:id/payment` - Effectuer un paiement

### Messagerie
- GET `/api/messages/conversations` - Liste des conversations
- POST `/api/messages/conversations` - Créer une conversation
- GET `/api/messages/conversations/:id` - Messages d'une conversation
- POST `/api/messages` - Envoyer un message

## Tests
```bash
npm test
```

## Sécurité
- Authentification JWT
- Validation des données avec express-validator
- Protection CORS
- Rate limiting
- Helmet pour la sécurité des headers

## Déploiement
Instructions pour le déploiement en production :
1. Configurer les variables d'environnement de production
2. Construire l'application : `npm run build`
3. Démarrer le serveur : `npm start`

## Contribution
1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## License
Ce projet est sous licence MIT.