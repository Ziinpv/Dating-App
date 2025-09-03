const Joi = require('joi');

// Validation schemas
const registerSchema = Joi.object({
  name: Joi.string()
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.min': 'Name must be at least 2 characters long',
      'string.max': 'Name cannot exceed 50 characters',
      'any.required': 'Name is required'
    }),
  
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    }),
  
  password: Joi.string()
    .min(6)
    .max(128)
    .pattern(new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)'))
    .required()
    .messages({
      'string.min': 'Password must be at least 6 characters long',
      'string.max': 'Password cannot exceed 128 characters',
      'string.pattern.base': 'Password must contain at least one lowercase letter, one uppercase letter, and one number',
      'any.required': 'Password is required'
    }),
  
  phoneNumber: Joi.string()
    .pattern(new RegExp('^[0-9+\\-\\s()]+$'))
    .optional()
    .messages({
      'string.pattern.base': 'Please provide a valid phone number'
    })
});

const loginSchema = Joi.object({
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    }),
  
  password: Joi.string()
    .required()
    .messages({
      'any.required': 'Password is required'
    })
});

const updateProfileSchema = Joi.object({
  name: Joi.string()
    .min(2)
    .max(50)
    .optional(),
  
  age: Joi.number()
    .integer()
    .min(18)
    .max(100)
    .optional()
    .messages({
      'number.min': 'Age must be at least 18',
      'number.max': 'Age cannot exceed 100'
    }),
  
  location: Joi.string()
    .max(100)
    .optional(),
  
  bio: Joi.string()
    .max(500)
    .optional()
    .messages({
      'string.max': 'Bio cannot exceed 500 characters'
    }),
  
  interests: Joi.array()
    .items(Joi.string())
    .min(1)
    .max(20)
    .optional()
    .messages({
      'array.min': 'Please select at least one interest',
      'array.max': 'Cannot select more than 20 interests'
    }),
  
  gender: Joi.string()
    .valid('Nam', 'Nữ', 'Khác')
    .optional(),
  
  lookingFor: Joi.string()
    .valid('Nam', 'Nữ', 'Tất cả')
    .optional()
});

const swipeSchema = Joi.object({
  swipedUserId: Joi.string()
    .required()
    .messages({
      'any.required': 'Swiped user ID is required'
    }),
  
  isLike: Joi.boolean()
    .required()
    .messages({
      'any.required': 'Like status is required'
    })
});

// Validation middleware functions
const validateRegister = (req, res, next) => {
  const { error, value } = registerSchema.validate(req.body, { abortEarly: false });
  
  if (error) {
    const errors = error.details.map(detail => ({
      field: detail.path[0],
      message: detail.message
    }));
    
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors
    });
  }
  
  req.body = value;
  next();
};

const validateLogin = (req, res, next) => {
  const { error, value } = loginSchema.validate(req.body, { abortEarly: false });
  
  if (error) {
    const errors = error.details.map(detail => ({
      field: detail.path[0],
      message: detail.message
    }));
    
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors
    });
  }
  
  req.body = value;
  next();
};

const validateUpdateProfile = (req, res, next) => {
  const { error, value } = updateProfileSchema.validate(req.body, { abortEarly: false });
  
  if (error) {
    const errors = error.details.map(detail => ({
      field: detail.path[0],
      message: detail.message
    }));
    
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors
    });
  }
  
  req.body = value;
  next();
};

const validateSwipe = (req, res, next) => {
  const { error, value } = swipeSchema.validate(req.body, { abortEarly: false });
  
  if (error) {
    const errors = error.details.map(detail => ({
      field: detail.path[0],
      message: detail.message
    }));
    
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors
    });
  }
  
  req.body = value;
  next();
};

module.exports = {
  validateRegister,
  validateLogin,
  validateUpdateProfile,
  validateSwipe
};
