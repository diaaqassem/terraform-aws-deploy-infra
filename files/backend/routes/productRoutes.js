// routes/productRoutes.js
const express = require("express");
const router = express.Router();
const controller = require("../controllers/controller");

// Get all products
router.get("/", controller.getAll);

// Create a new product
router.post("/", controller.create);

// Update a product
router.put("/:id", controller.update);

// Delete a product
router.delete("/:id", controller.delete);

module.exports = router;
