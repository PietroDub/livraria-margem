'use client';

import { useState } from 'react';
import { booksApi, type BookInput } from '@/lib/books';

export function useSaveBook() {
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  function clearError() {
    setError('');
  }

  async function save(input: BookInput, id?: number) {
    setSaving(true);
    setError('');
    try {
      return await booksApi.save(input, id);
    } catch (cause) {
      const message = cause instanceof Error ? cause.message : 'Não foi possível salvar o livro.';
      setError(message);
      throw cause;
    } finally {
      setSaving(false);
    }
  }

  return { save, saving, error, clearError };
}
