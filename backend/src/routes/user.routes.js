const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { protect, admin } = require('../middleware/auth.middleware');

// Public routes    
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);
router.get('/verify/:token', userController.verifyUser);
router.post('/forgotpassword', userController.forgotPassword);
router.put('/resetpassword/:token', userController.resetPassword);

// Protected routes
router.route('/profile')
  .get(protect, userController.getUserProfile)
  .put(protect, userController.updateUserProfile);

// Admin routes
router.route('/')
  .get(protect, admin, userController.getUsers);

router.route('/:id')
  .delete(protect, admin, userController.deleteUser);

module.exports = router;