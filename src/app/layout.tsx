import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'Margem | Sua livraria, organizada', description: 'Um catálogo de livros e um espaço para aprender Ruby on Rails.' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="pt-BR"><body>{children}</body></html>;
}
