class AddressesController < ApplicationController
  before_action :set_address, only: %i[show edit update destroy set_primary]

  def index
    @query = params[:q].to_s.strip
    @state_filter = params[:state].to_s.strip.upcase
    @addresses = Address.primary_first.search(@query).by_state(@state_filter)
    @total_count = Address.count
    @states_in_use = Address.distinct.order(:state).pluck(:state)
  end

  def show
  end

  def new
    @address = Address.new(country: "Brasil")
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to addresses_path, notice: "Endereço cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to @address, notice: "Endereço atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, status: :see_other, notice: "Endereço excluído com sucesso."
  end

  def set_primary
    @address.mark_as_primary!
    redirect_back fallback_location: addresses_path, notice: "Endereço definido como principal."
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :label,
      :cep,
      :street,
      :number,
      :complement,
      :neighborhood,
      :city,
      :state,
      :country,
      :primary
    )
  end
end
