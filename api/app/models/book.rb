class Book < ApplicationRecord
  # Lista fechada: a categoria precisa ser uma destas, não um texto livre.
  CATEGORIES = ['Literatura brasileira', 'Ficção', 'Tecnologia', 'Não ficção', 'Poesia'].freeze

  # optional: livros já cadastrados não têm user_id. Rails 5+ exige belongs_to por padrão.
  belongs_to :user, optional: true

  # Tira espaços nas pontas antes de validar título, autor e ISBN.
  before_validation :normalize_text
  validates :title, presence: true, length: { maximum: 180 }
  validates :author, presence: true, length: { maximum: 120 }
  validates :category, inclusion: { in: CATEGORIES }
  # ISBN só com 10 ou 13 dígitos, único no catálogo.
  validates :isbn, presence: true, uniqueness: true,
                   format: { with: /\A(?:\d{10}|\d{13})\z/, message: 'must contain 10 or 13 digits' }
  validates :description, length: { maximum: 2000 }
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100_000_000 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000 }
  # numericality sozinho aceita "10.5" depois do cast; aqui recusamos o valor original.
  validate :raw_integer_fields

  # Ordena por título e id para manter consistência em buscas. => representa uma expressão lambda que define um escopo para o modelo.
  # order(:title, :id) ordena primeiro por título e depois por id.
  scope :alphabetical, -> { order(:title, :id) }

  private

  def normalize_text
    self.title = title&.strip
    self.author = author&.strip
    self.isbn = isbn&.strip
  end

  def raw_integer_fields
    %i[price_cents stock].each do |field|
      raw = public_send("#{field}_before_type_cast")
      errors.add(field, 'must be an integer') unless raw.is_a?(Integer) || raw.to_s.match?(/\A\d+\z/)
    end
  end
end
