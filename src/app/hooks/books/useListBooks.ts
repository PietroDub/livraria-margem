'use client';

import { useCallback, useEffect, useState } from 'react';
import type { Pagination } from '@/app/dto/book.dto';
import { booksApi, demoMode, type Book } from '@/lib/books';

export function useListBooks() {
  const [books, setBooks] = useState<Book[]>([]);
  const [pagination, setPagination] = useState<Pagination | null>(null);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const reload = useCallback(async () => {
    setLoading(true);
    setError('');
    try {
      if (demoMode) {
        const all = await booksApi.list();
        setBooks(all);
        setPagination({
          current_page: 1,
          total_pages: 1,
          per_page: all.length,
          total_count: all.length,
        });
        return;
      }
      const payload = await booksApi.listPage(page);
      setBooks(payload.books);
      setPagination(payload.pagination);
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : 'Não foi possível carregar o catálogo.');
    } finally {
      setLoading(false);
    }
  }, [page]);

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

  return { books, pagination, page, setPage, loading, error, reload, upsert, drop };
}
