class Admin::ExpansionsController < AdminController
  before_action :get_expansion, only: [:show, :edit, :update, :destroy]

  def index
    @expansions = filter_scope Expansion.all
    respond_with :admin, @expansions
  end

  def new
    @expansion = Expansion.new
    respond_with :admin, @expansion
  end

  def show
    @cards = filter_scope @expansion.cards, skip_params: ['id']
  end

  def edit; end

  def create
    @expansion = Expansion.create(expansion_params)
    respond_with :admin, @expansion
  end

  def update
    @expansion.update_attributes(expansion_params)
    respond_with :admin, @expansion
  end

  def destroy
    @expansion.destroy!
    respond_with :admin, @expansion
  end

  private

  def get_expansion
    @expansion = Expansion.find_by!(uuid: params[:id])
  end

  def expansion_params
    params.require(:expansion).permit(:name)
  end
end
