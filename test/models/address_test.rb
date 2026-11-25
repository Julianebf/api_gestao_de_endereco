require "test_helper"

class AddressTest < ActiveSupport::TestCase
  test "valid address saves with normalized fields" do
    address = Address.new(
      label: "  Depósito Sul  ",
      cep: "80010-000",
      street: "  Rua XV de Novembro  ",
      number: " 500 ",
      complement: "   ",
      neighborhood: " Centro ",
      city: " Curitiba ",
      state: " pr "
    )

    assert address.valid?
    assert address.save
    assert_equal "Depósito Sul", address.label
    assert_equal "80010000", address.cep
    assert_equal "80010-000", address.formatted_cep
    assert_equal "PR", address.state
    assert_equal "Brasil", address.country
    assert_nil address.complement
  end

  test "requires valid 8-digit cep" do
    address = addresses(:two)
    address.cep = "1234"
    assert_not address.valid?
    assert_includes address.errors[:cep], "deve conter 8 dígitos (ex.: 01310-100)"
  end

  test "requires valid Brazilian state UF" do
    address = addresses(:two)
    address.state = "XX"
    assert_not address.valid?
    assert_includes address.errors[:state], "não é uma UF brasileira válida"
  end

  test "setting a new primary address unsets the previous primary" do
    primary_one = addresses(:one)
    secondary_two = addresses(:two)

    assert primary_one.primary?
    assert_not secondary_two.primary?

    secondary_two.mark_as_primary!

    assert secondary_two.reload.primary?
    assert_not primary_one.reload.primary?
    assert_equal 1, Address.where(primary: true).count
  end

  test "search matches street, city, label, and formatted cep" do
    assert_equal [addresses(:one)], Address.search("Paulista").to_a
    assert_equal [addresses(:one)], Address.search("01310-100").to_a
    assert_equal [addresses(:two)], Address.search("Rio de Janeiro").to_a
    assert_equal [addresses(:two)], Address.search("Trabalho").to_a
  end

  test "by_state filters by UF case-insensitively" do
    assert_equal [addresses(:one)], Address.by_state("sp").to_a
    assert_equal [addresses(:two)], Address.by_state("RJ").to_a
  end
end
