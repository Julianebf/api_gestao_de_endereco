# Represents a Brazilian physical or delivery address.
class Address < ApplicationRecord
  BRAZILIAN_STATES = {
    "AC" => "Acre",
    "AL" => "Alagoas",
    "AP" => "Amapá",
    "AM" => "Amazonas",
    "BA" => "Bahia",
    "CE" => "Ceará",
    "DF" => "Distrito Federal",
    "ES" => "Espírito Santo",
    "GO" => "Goiás",
    "MA" => "Maranhão",
    "MT" => "Mato Grosso",
    "MS" => "Mato Grosso do Sul",
    "MG" => "Minas Gerais",
    "PA" => "Pará",
    "PB" => "Paraíba",
    "PR" => "Paraná",
    "PE" => "Pernambuco",
    "PI" => "Piauí",
    "RJ" => "Rio de Janeiro",
    "RN" => "Rio Grande do Norte",
    "RS" => "Rio Grande do Sul",
    "RO" => "Rondônia",
    "RR" => "Roraima",
    "SC" => "Santa Catarina",
    "SP" => "São Paulo",
    "SE" => "Sergipe",
    "TO" => "Tocantins"
  }.freeze

  before_validation :normalize_fields
  before_save :ensure_single_primary, if: :primary?

  validates :label, length: { maximum: 80 }, allow_blank: true
  validates :cep, presence: true, format: { with: /\A\d{8}\z/ }
  validates :street, presence: true, length: { maximum: 150 }
  validates :number, presence: true, length: { maximum: 20 }
  validates :complement, length: { maximum: 100 }, allow_blank: true
  validates :neighborhood, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :state, presence: true, inclusion: { in: BRAZILIAN_STATES.keys }
  validates :country, presence: true, length: { maximum: 60 }

  scope :primary_first, -> { order(primary: :desc, updated_at: :desc) }
  scope :by_state, ->(uf) { uf.present? ? where(state: uf.to_s.strip.upcase) : all }
  scope :search, lambda { |query|
    term = query.to_s.strip
    if term.blank?
      all
    else
      pattern = "%#{sanitize_sql_like(term)}%"
      digits = term.gsub(/\D/, "")

      if digits.present?
        cep_pattern = "%#{sanitize_sql_like(digits)}%"
        where(
          "label ILIKE :pattern OR street ILIKE :pattern OR neighborhood ILIKE :pattern OR city ILIKE :pattern OR state ILIKE :pattern OR cep ILIKE :cep_pattern",
          pattern: pattern,
          cep_pattern: cep_pattern
        )
      else
        where(
          "label ILIKE :pattern OR street ILIKE :pattern OR neighborhood ILIKE :pattern OR city ILIKE :pattern OR state ILIKE :pattern",
          pattern: pattern
        )
      end
    end
  }

  def self.state_options
    BRAZILIAN_STATES.map { |uf, name| ["#{uf} - #{name}", uf] }
  end

  def mark_as_primary!
    update!(primary: true)
  end

  def formatted_cep
    return cep if cep.blank? || cep.length != 8

    "#{cep[0, 5]}-#{cep[5, 3]}"
  end

  def display_title
    label.presence || street
  end

  def street_line
    base = "#{street}, #{number}"
    complement.present? ? "#{base} — #{complement}" : base
  end

  def full_address
    "#{street_line}, #{neighborhood}, #{city}/#{state} - CEP #{formatted_cep}"
  end

  private

  def normalize_fields
    self.label = label&.strip.presence
    self.cep = cep.to_s.gsub(/\D/, "")
    self.street = street&.strip
    self.number = number&.strip
    self.complement = complement&.strip.presence
    self.neighborhood = neighborhood&.strip
    self.city = city&.strip
    self.state = state&.strip&.upcase
    self.country = country.present? ? country.strip : "Brasil"
  end

  def ensure_single_primary
    self.class.where.not(id: id).where(primary: true).update_all(primary: false)
  end
end
