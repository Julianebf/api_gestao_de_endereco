# Gestão de Endereços

Aplicação full-stack em **Ruby on Rails 7.1** com **Hotwire (Turbo + Stimulus)** e **PostgreSQL** para cadastro e gerenciamento de endereços brasileiros.

## Funcionalidades

- Cadastro, visualização, edição e exclusão (CRUD) de endereços
- Validação e normalização automática de CEP (8 dígitos) e UF brasileira (27 estados)
- Máscara automática de CEP e busca opcional via ViaCEP no formulário (`app/javascript/controllers/cep_controller.js`)
- Controle de **endereço principal único**, garantido no banco via índice parcial único e na aplicação via `Address#mark_as_primary!`
- Busca textual por apelido, CEP, logradouro, bairro ou cidade, com filtro por UF
- Interface em português (`pt-BR`)

## Requisitos

- Ruby `3.0.2` (ou compatível)
- Rails `7.1.5.2`
- PostgreSQL `14+`

## Configuração e execução

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed # opcional: popula endereços de exemplo
bin/rails server
```

Acesse `http://localhost:3000`.

## Testes

```bash
bin/rails test
```
