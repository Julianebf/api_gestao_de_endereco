require "test_helper"

class AddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @address = addresses(:one)
    @secondary = addresses(:two)
  end

  test "should get index and order primary first" do
    get addresses_url
    assert_response :success
    assert_select "h1", "Endereços cadastrados"
    assert_select "article.card", count: 2
  end

  test "should filter index by query and state" do
    get addresses_url, params: { q: "01310-100", state: "SP" }
    assert_response :success
    assert_select "article.card", count: 1
    assert_select "h2.card__title", text: /Casa/
  end

  test "should get new" do
    get new_address_url
    assert_response :success
  end

  test "should create address" do
    assert_difference("Address.count", 1) do
      post addresses_url, params: {
        address: {
          label: "Filial MG",
          cep: "30130-010",
          street: "Avenida Afonso Pena",
          number: "867",
          neighborhood: "Centro",
          city: "Belo Horizonte",
          state: "MG",
          country: "Brasil",
          primary: false
        }
      }
    end

    assert_redirected_to addresses_url
    follow_redirect!
    assert_select ".flash--notice", text: /Endereço cadastrado com sucesso/
  end

  test "should not create invalid address" do
    assert_no_difference("Address.count") do
      post addresses_url, params: {
        address: {
          cep: "123",
          street: "",
          number: "",
          neighborhood: "",
          city: "",
          state: "ZZ"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".error-box"
  end

  test "should show address" do
    get address_url(@address)
    assert_response :success
    assert_select "h1", @address.display_title
  end

  test "should get edit" do
    get edit_address_url(@address)
    assert_response :success
  end

  test "should update address" do
    patch address_url(@secondary), params: {
      address: {
        label: "Escritório Central",
        number: "200"
      }
    }

    assert_redirected_to address_url(@secondary)
    @secondary.reload
    assert_equal "Escritório Central", @secondary.label
    assert_equal "200", @secondary.number
  end

  test "should set address as primary" do
    assert_not @secondary.primary?

    patch set_primary_address_url(@secondary)
    assert_redirected_to addresses_url

    assert @secondary.reload.primary?
    assert_not @address.reload.primary?
  end

  test "should destroy address" do
    assert_difference("Address.count", -1) do
      delete address_url(@secondary)
    end

    assert_redirected_to addresses_url
  end
end
