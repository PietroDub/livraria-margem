import { Book } from "@/lib/books";

export type Pagination = {
    current_page: number;
    total_pages: number;
    per_page: number;
    total_count: number;
  };
  export type BookPage = {
    books: Book[];
    pagination: Pagination;
  };