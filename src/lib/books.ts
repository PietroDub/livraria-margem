export type Book = { id: number; title: string; author: string; category: string; price_cents: number; stock: number; isbn: string; description: string };
export type BookInput = Omit<Book, 'id'>;
export const categories = ['Literatura brasileira', 'Ficção', 'Tecnologia', 'Não ficção', 'Poesia'];
export const initialBooks: Book[] = [
  { id: 1, title: 'Dom Casmurro', author: 'Machado de Assis', category: 'Literatura brasileira', price_cents: 3990, stock: 12, isbn: '9788535914849', description: 'Memória, ciúme e os silêncios de uma das grandes obras da literatura brasileira.' },
  { id: 2, title: 'O pequeno príncipe', author: 'Antoine de Saint-Exupéry', category: 'Ficção', price_cents: 2990, stock: 8, isbn: '9788522031447', description: 'Uma viagem sobre amizade, cuidado e o que realmente importa.' },
  { id: 3, title: 'Código limpo', author: 'Robert C. Martin', category: 'Tecnologia', price_cents: 8990, stock: 3, isbn: '9788576082675', description: 'Princípios e práticas para escrever código legível e sustentável.' },
  { id: 4, title: 'A hora da estrela', author: 'Clarice Lispector', category: 'Literatura brasileira', price_cents: 4490, stock: 6, isbn: '9788532529626', description: 'A história de Macabéa e um olhar delicado sobre a existência.' },
  { id: 5, title: '1984', author: 'George Orwell', category: 'Ficção', price_cents: 3490, stock: 0, isbn: '9788535914848', description: 'Uma distopia sobre vigilância, poder e liberdade.' },
  { id: 6, title: 'Alguma poesia', author: 'Carlos Drummond de Andrade', category: 'Poesia', price_cents: 4290, stock: 5, isbn: '9788535921076', description: 'O cotidiano ganha novas perspectivas nos versos de Drummond.' }
];
export const demoMode = process.env.NEXT_PUBLIC_DATA_MODE === 'demo';
const endpoint = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001/api/v1';
const key = 'margem-books-v1';
function readLocal(): Book[] {
  const raw = localStorage.getItem(key);
  if (!raw) { localStorage.setItem(key, JSON.stringify(initialBooks)); return initialBooks; }
  const value: unknown = JSON.parse(raw);
  if (!Array.isArray(value)) throw new Error('Dados locais inválidos. Limpe o armazenamento deste site para reiniciar a demonstração.');
  return value as Book[];
}
async function request<T>(path: string, options?: RequestInit): Promise<T> {
  let response: Response;
  try { response = await fetch(`${endpoint}${path}`, { ...options, headers: { 'Content-Type': 'application/json', ...options?.headers }, signal: AbortSignal.timeout(10000) }); }
  catch { throw new Error('Não foi possível conectar à API Ruby. Confira se ela está em execução e verifique NEXT_PUBLIC_API_URL.'); }
  if (response.status === 204) return undefined as T;
  const payload = await response.json();
  if (!response.ok) throw new Error(payload.errors?.join(' · ') || payload.error || 'Não foi possível concluir a operação.');
  return payload as T;
}
export const booksApi = {
  list: async (): Promise<Book[]> => demoMode ? readLocal() : request<Book[]>('/books'),
  save: async (input: BookInput, id?: number): Promise<Book> => {
    if (!demoMode) return request<Book>(id ? `/books/${id}` : '/books', { method: id ? 'PATCH' : 'POST', body: JSON.stringify({ book: input }) });
    const books = readLocal();
    if (books.some(book => book.isbn === input.isbn && book.id !== id)) throw new Error('Este ISBN já está cadastrado.');
    const book = { ...input, id: id ?? Math.max(0, ...books.map(book => book.id)) + 1 };
    localStorage.setItem(key, JSON.stringify(id ? books.map(item => item.id === id ? book : item) : [...books, book]));
    return book;
  },
  remove: async (id: number): Promise<void> => {
    if (!demoMode) return request<void>(`/books/${id}`, { method: 'DELETE' });
    localStorage.setItem(key, JSON.stringify(readLocal().filter(book => book.id !== id)));
  }
};
export const money = (cents: number) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(cents / 100);
