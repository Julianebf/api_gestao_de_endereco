import { Controller } from "@hotwired/stimulus"

// Formats Brazilian CEP inputs and optionally fetches address details via ViaCEP.
export default class extends Controller {
  static targets = ["cep", "street", "neighborhood", "city", "state", "number", "status"]

  format() {
    const digits = this.cepTarget.value.replace(/\D/g, "").slice(0, 8)
    this.cepTarget.value = digits.length > 5
      ? `${digits.slice(0, 5)}-${digits.slice(5)}`
      : digits
  }

  async lookup(event) {
    event.preventDefault()

    const digits = this.cepTarget.value.replace(/\D/g, "")
    if (digits.length !== 8) {
      this.setStatus("Informe um CEP válido com 8 dígitos para buscar.", true)
      return
    }

    this.setStatus("Buscando CEP...", false)

    try {
      const response = await fetch(`https://viacep.com.br/ws/${digits}/json/`)
      if (!response.ok) throw new Error("HTTP error")

      const data = await response.json()
      if (data.erro) {
        this.setStatus("CEP não encontrado. Preencha os campos manualmente.", true)
        return
      }

      if (data.logradouro) this.streetTarget.value = data.logradouro
      if (data.bairro) this.neighborhoodTarget.value = data.bairro
      if (data.localidade) this.cityTarget.value = data.localidade
      if (data.uf) this.stateTarget.value = data.uf

      this.setStatus("Endereço preenchido a partir do CEP.", false)
      this.numberTarget.focus()
    } catch (_error) {
      this.setStatus("Não foi possível consultar o CEP agora. Preencha manualmente.", true)
    }
  }

  setStatus(message, isError) {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = message
    this.statusTarget.classList.toggle("cep-status--error", isError)
    this.statusTarget.classList.toggle("cep-status--ok", !isError)
  }
}
