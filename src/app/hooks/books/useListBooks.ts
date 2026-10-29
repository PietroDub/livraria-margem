'use client';

import { useCallback, useEffect, useState } from 'react';
import { booksApi, type Book } from '@/lib/books';

export function useListBooks() {
  const [books, setBooks] = useState<Book[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const reload = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      setBooks(await booksApi.list());
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : 'Não foi possível carregar o catálogo.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void reload();
  }, [reload]);

  function upsert(book: Book) {
    setBooks(current => current.some(item => item.id === book.id)
      ? current.map(item => item.id === book.id ? book : item)
      : [...current, book]);
  }

  function drop(id: number) {
    setBooks(current => current.filter(book => book.id !== id));
  }

  return { books, loading, error, reload, upsert, drop };
}
