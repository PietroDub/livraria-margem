'use client';

import { useState } from 'react';
import { booksApi } from '@/lib/books';

export function useDeleteBook() {
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  function clearError() {
    setError('');
  }

  async function remove(id: number) {
    setSaving(true);
    setError('');
    try {
      await booksApi.remove(id);
    } catch (cause) {
      const message = cause instanceof Error ? cause.message : 'Não foi possível excluir o livro.';
      setError(message);
      throw cause;
    } finally {
      setSaving(false);
    }
  }

  return { remove, saving, error, clearError };
}
