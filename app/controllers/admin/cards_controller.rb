class Admin::CardsController < AdminController
  before_action :get_expansion, only: [:new, :create]
  before_action :get_card, only: [:edit, :update, :destroy]

  def new
    @card = Card.new
  end

  def create
    type = params[:card][:type]
    texts = params[:card][:text].split("\n")

    @card = Card.new type: type
    @cards = []

    texts.each do |text|
      @cards << Card.create(type: type, text: text, expansion: @expansion)
    end

    if @cards.empty?
      @card.valid?
      render 'new'
    elsif @cards.all? &:valid?
      redirect_to admin_expansion_path(@expansion), flash: { notice: 'Cards added to expansion!' }
    else
      if @cards.any? &:valid?
        flash.now[:error] = 'Some cards were invalid.'
        @cards.reject! &:valid?
      end

      @card.errors[:text] << @cards.collect { |c| c.errors[:text] }.flatten.uniq.to_sentence
      @card.text = @cards.collect(&:text).join("\n")

      render 'new'
    end

    Rails.logger.info @card.errors.full_messages
  end

  def edit; end

  def update
    @card.update_attributes(card_params)
    respond_with :admin, @card.expansion, @card, location: admin_expansion_path(@card.expansion)
  end

  def destroy
    @card.destroy
    respond_with :admin, @expansion, @card, location: admin_expansion_path(@expansion)
  end

  private

  def get_expansion
    @expansion = Expansion.find(params[:expansion_id])
  end

  def get_card
    @card = Card.find(params[:id])
    @expansion = @card.expansion
  end

  def card_params
    params.require(:card).permit(:expansion_id, :text, :type)
  end
end
