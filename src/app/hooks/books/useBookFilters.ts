'use client';

import { useMemo, useState } from 'react';
import type { Book } from '@/lib/books';

export function useBookFilters(books: Book[]) {
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState('Todas as categorias');
  const [availability, setAvailability] = useState('Todos os estoques');

  const filtered = useMemo(() => books.filter(book => {
    const haystack = `${book.title} ${book.author} ${book.isbn}`.toLocaleLowerCase('pt-BR');
    const matchesQuery = haystack.includes(query.toLocaleLowerCase('pt-BR'));
    const matchesCategory = category === 'Todas as categorias' || book.category === category;
    const matchesAvailability = availability === 'Todos os estoques'
      || (availability === 'Disponíveis' ? book.stock > 0 : book.stock === 0);
    return matchesQuery && matchesCategory && matchesAvailability;
  }), [books, query, category, availability]);

  const stock = books.reduce((total, book) => total + book.stock, 0);
  const value = books.reduce((total, book) => total + book.price_cents * book.stock, 0);
  const outOfStock = books.filter(book => book.stock === 0).length;

  function clear() {
    setQuery('');
    setCategory('Todas as categorias');
    setAvailability('Todos os estoques');
  }

  return {
    query,
    setQuery,
    category,
    setCategory,
    availability,
    setAvailability,
    filtered,
    stock,
    value,
    outOfStock,
    clear
  };
}
