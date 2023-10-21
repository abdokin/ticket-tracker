class ArticlesController < ApplicationController
  layout "show_layout", only: [:show]
  before_action :authenticate_user!, except: [:show]

  before_action :set_article, only: %i[ show edit update destroy generate_qr_code_sm generate_qr_code_lg ]

  def index
    @query = params[:search]

    if @query.present?
      # Check if the search query matches the format of an 8-digit number
        @articles = Article.where("code LIKE ?", "%#{@query}%")
    else
      @articles = Article.all
    end
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to articles_path, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_to articles_path, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
 
  def generate_qr_code_sm
    data = article_url(@article)
    qr = RQRCode::QRCode.new(data, size: 8, level: :h)
    qr_code = qr.as_png(size: 130)
    image = MiniMagick::Image.read(qr_code.to_s)
    text = "#{@article.code}"
    text_size = 10
    text_x = (image.width / 2) - (text_size * text.length / 2)  - 20
    text_y = (image.height / 2) - (text_size / 2) - 2
    image.combine_options do |c|
      c.gravity "center"
      c.fill "black"
      c.stroke "none"
      c.pointsize text_size
      c.draw "text #{text_x},#{text_y} '#{text}'"
    end
    send_data image.to_blob, type: "image/png", disposition: "inline"
  end
  
  def generate_qr_code_lg
    data = article_url(@article)
    qr = RQRCode::QRCode.new(data, size: 8, level: :h)
    qr_code = qr.as_png(size: 200)
    image = MiniMagick::Image.read(qr_code.to_s)
    text = @article.code
    text_size = 16
    text_x = (image.width / 2) - (text_size * text.length / 2) - 30
    text_y = (image.height / 2) - (text_size / 2) - 8
    image.combine_options do |c|
      c.gravity "center"
      c.fill "black"
      c.stroke "none"
      c.pointsize text_size
      c.draw "text #{text_x},#{text_y} '#{text}'"
    end
    send_data image.to_blob, type: "image/png", disposition: "inline"
  end
  
  def destroy
    @article.destroy
    redirect_to articles_url, notice: "Article was successfully destroyed."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:name, :code, :photo, :price, :promo_price, :on_promo)
  end
end
