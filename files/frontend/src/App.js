// src/App.js
import React, { useState, useEffect } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [products, setProducts] = useState([]);
  const [formData, setFormData] = useState({
    name: "",
    price: "",
    description: "",
  });
  const [editingId, setEditingId] = useState(null);

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await axios.get(
        "http://localhost:4000/api/products"
      );
      setProducts(response.data);
    } catch (error) {
      console.error("Error fetching products:", error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingId) {
        await axios.put(
          `http://localhost:4000/api/products/${editingId}`,
          formData
        );
      } else {
        await axios.post(
          "http://localhost:4000/api/products",
          formData
        );
      }
      setFormData({ name: "", price: "", description: "" });
      setEditingId(null);
      fetchProducts();
    } catch (error) {
      console.error("Error saving product:", error);
    }
  };

  const handleEdit = (product) => {
    setFormData({
      name: product.name,
      price: product.price,
      description: product.description,
    });
    setEditingId(product._id);
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(
        `http://localhost:4000/api/products/${id}`
      );
      fetchProducts();
    } catch (error) {
      console.error("Error deleting product:", error);
    }
  };

  return (
    <div className="container">
      <header className="app-header">
        <h1>Product Management</h1>
      </header>

      <div className="content">
        <div className="form-section">
          <h2>{editingId ? "Update Product" : "Add New Product"}</h2>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Product Name</label>
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                required
              />
            </div>
            <div className="form-group">
              <label>Price</label>
              <input
                type="text"
                name="price"
                value={formData.price}
                onChange={handleInputChange}
                required
              />
            </div>
            <div className="form-group">
              <label>Description</label>
              <textarea
                name="description"
                value={formData.description}
                onChange={handleInputChange}
                required
              />
            </div>
            <button type="submit" className="submit-btn">
              {editingId ? "Update Product" : "Add Product"}
            </button>
          </form>
        </div>

        <div className="products-section">
          <h2>Product List</h2>
          {products.length === 0 ? (
            <p className="no-products">
              No products available. Add some products to get started.
            </p>
          ) : (
            <table className="products-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Price</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {products.map((product) => (
                  <tr key={product._id}>
                    <td>{product.name}</td>
                    <td>{product.price}</td>
                    <td>{product.description}</td>
                    <td className="actions">
                      <button
                        onClick={() => handleEdit(product)}
                        className="edit-btn"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => handleDelete(product._id)}
                        className="delete-btn"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
