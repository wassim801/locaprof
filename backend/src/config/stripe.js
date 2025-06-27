const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Configuration des webhooks Stripe
const handleWebhookEvent = async (event) => {
  try {
    switch (event.type) {
      case 'payment_intent.succeeded':
        await handlePaymentSuccess(event.data.object);
        break;

      case 'payment_intent.payment_failed':
        await handlePaymentFailure(event.data.object);
        break;

      case 'charge.refunded':
        await handleRefund(event.data.object);
        break;

      default:
        console.log(`Event non géré: ${event.type}`);
    }
  } catch (error) {
    console.error('Erreur lors du traitement du webhook:', error);
    throw error;
  }
};

// Gérer un paiement réussi
const handlePaymentSuccess = async (paymentIntent) => {
  try {
    // Mettre à jour le statut du paiement dans la base de données
    const booking = await Booking.findOne({
      'paiements.stripePaymentId': paymentIntent.id
    });

    if (booking) {
      const paiement = booking.paiements.find(
        p => p.stripePaymentId === paymentIntent.id
      );

      if (paiement) {
        paiement.statut = 'complete';
        await booking.save();

        // Envoyer une notification au propriétaire
        // TODO: Implémenter les notifications
      }
    }
  } catch (error) {
    console.error('Erreur lors du traitement du paiement réussi:', error);
    throw error;
  }
};

// Gérer un paiement échoué
const handlePaymentFailure = async (paymentIntent) => {
  try {
    const booking = await Booking.findOne({
      'paiements.stripePaymentId': paymentIntent.id
    });

    if (booking) {
      const paiement = booking.paiements.find(
        p => p.stripePaymentId === paymentIntent.id
      );

      if (paiement) {
        paiement.statut = 'echoue';
        await booking.save();

        // Envoyer une notification au locataire
        // TODO: Implémenter les notifications
      }
    }
  } catch (error) {
    console.error('Erreur lors du traitement du paiement échoué:', error);
    throw error;
  }
};

// Gérer un remboursement
const handleRefund = async (charge) => {
  try {
    const booking = await Booking.findOne({
      'paiements.stripePaymentId': charge.payment_intent
    });

    if (booking) {
      const paiement = booking.paiements.find(
        p => p.stripePaymentId === charge.payment_intent
      );

      if (paiement) {
        paiement.statut = 'rembourse';
        await booking.save();

        // Envoyer des notifications
        // TODO: Implémenter les notifications
      }
    }
  } catch (error) {
    console.error('Erreur lors du traitement du remboursement:', error);
    throw error;
  }
};

// Créer une session de paiement
const createPaymentSession = async ({
  amount,
  currency = 'eur',
  customer,
  description,
  metadata
}) => {
  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency,
            product_data: {
              name: description
            },
            unit_amount: amount * 100 // Stripe utilise les centimes
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      customer,
      metadata,
      success_url: `${process.env.FRONTEND_URL}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.FRONTEND_URL}/payment/cancel`
    });

    return session;
  } catch (error) {
    console.error('Erreur lors de la création de la session de paiement:', error);
    throw error;
  }
};

// Créer ou mettre à jour un client Stripe
const createOrUpdateCustomer = async (user) => {
  try {
    let customer;

    if (user.stripeCustomerId) {
      // Mettre à jour le client existant
      customer = await stripe.customers.update(user.stripeCustomerId, {
        email: user.email,
        name: `${user.prenom} ${user.nom}`,
        phone: user.telephone,
        metadata: {
          userId: user._id.toString()
        }
      });
    } else {
      // Créer un nouveau client
      customer = await stripe.customers.create({
        email: user.email,
        name: `${user.prenom} ${user.nom}`,
        phone: user.telephone,
        metadata: {
          userId: user._id.toString()
        }
      });

      // Mettre à jour l'ID du client dans la base de données
      user.stripeCustomerId = customer.id;
      await user.save();
    }

    return customer;
  } catch (error) {
    console.error('Erreur lors de la gestion du client Stripe:', error);
    throw error;
  }
};

module.exports = {
  handleWebhookEvent,
  createPaymentSession,
  createOrUpdateCustomer,
  stripe
};