samples = [
  {
    label: "Escritório Paulista",
    cep: "01310100",
    street: "Avenida Paulista",
    number: "1578",
    complement: "Conjunto 402",
    neighborhood: "Bela Vista",
    city: "São Paulo",
    state: "SP",
    country: "Brasil",
    primary: true
  },
  {
    label: "Casa",
    cep: "22041001",
    street: "Avenida Atlântica",
    number: "1702",
    complement: "Apto 801",
    neighborhood: "Copacabana",
    city: "Rio de Janeiro",
    state: "RJ",
    country: "Brasil",
    primary: false
  },
  {
    label: "Centro de Distribuição",
    cep: "30130010",
    street: "Avenida Afonso Pena",
    number: "867",
    complement: "Galpão 3",
    neighborhood: "Centro",
    city: "Belo Horizonte",
    state: "MG",
    country: "Brasil",
    primary: false
  }
]

samples.each do |attrs|
  Address.find_or_create_by!(cep: attrs[:cep], number: attrs[:number]) do |address|
    address.assign_attributes(attrs)
  end
end
