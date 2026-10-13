# O model reúne regras que valem para qualquer entrada de dados.
class Book < ApplicationRecord
  CATEGORIES = ['Literatura brasileira', 'Ficção', 'Tecnologia', 'Não ficção', 'Poesia'].freeze

  before_validation :normalize_text
  validates :title, presence: true, length: { maximum: 180 }
  validates :author, presence: true, length: { maximum: 120 }
  validates :category, inclusion: { in: CATEGORIES }
  validates :isbn, presence: true, uniqueness: true,
                   format: { with: /\A(?:\d{10}|\d{13})\z/, message: 'must contain 10 or 13 digits' }
  validates :description, length: { maximum: 2000 }
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100_000_000 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000 }
  # Não use o client como única barreira para valores fracionários.
  validate :raw_integer_fields

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
