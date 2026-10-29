'use client';

import { useState } from 'react';
import { categories, type Book, type BookInput } from '@/lib/books';

const blank: BookInput = {
  title: '',
  author: '',
  category: categories[0],
  price_cents: 0,
  stock: 0,
  isbn: '',
  description: ''
};

export function useBookForm() {
  const [form, setForm] = useState<BookInput>(blank);
  const [price, setPrice] = useState('');
  const [error, setError] = useState('');

  function fill(book: Book) {
    setForm({ ...book });
    setPrice((book.price_cents / 100).toFixed(2));
    setError('');
  }

  function reset() {
    setForm({ ...blank });
    setPrice('');
    setError('');
  }

  function toInput(): BookInput | null {
    const amount = Number(price.replace(',', '.'));
    const stockIsValid = Number.isInteger(form.stock) && form.stock >= 0 && form.stock <= 1000000;
    const priceIsValid = Number.isFinite(amount) && amount >= 0 && amount <= 1000000;
    if (!priceIsValid || !stockIsValid) {
      setError('Informe preço e estoque válidos.');
      return null;
    }
    setError('');
    return {
      ...form,
      title: form.title.trim(),
      author: form.author.trim(),
      isbn: form.isbn.trim(),
      price_cents: Math.round(amount * 100)
    };
  }

  return { form, setForm, price, setPrice, error, fill, reset, toInput };
}
