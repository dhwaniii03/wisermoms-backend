import rateLimit from "express-rate-limit";

// General API rate limiter: max 100 requests per 15 minutes per IP
export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 100,
  standardHeaders: "draft-7",
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message:
        "Too many requests from this IP, please try again after 15 minutes",
      statusCode: 429,
    },
  },
});

// Strict Auth rate limiter: max 20 requests per hour per IP
export const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  limit: 20,
  standardHeaders: "draft-7",
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      message:
        "Too many authentication attempts from this IP, please try again after an hour",
      statusCode: 429,
    },
  },
});
