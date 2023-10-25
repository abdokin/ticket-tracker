class ArticlesController < ApplicationController
  layout "show_layout", only: [:show]
  before_action :authenticate_user!, except: [:show]

  before_action :set_article, only: %i[ show edit update destroy generate_qr_code ]

  def index
    @query = params[:search]
    # flash[:alert] = "Welcome to the home page!"

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
 
  def generate_qr_code
    image = generate_qr_with_article(@article)
    send_data image.to_blob, type: "image/png", disposition: "inline"
  end
  


  def generate_all_qrs
    selected_ids = params['selectedIds']
    qr_images = []
    selected_ids.each do |article_id|
      article = Article.find(article_id)
      qr_code = generate_qr_with_article(article)
      qr_images << qr_code
    end
  
    merged_qr_code_path = merge_qr_codes(qr_images, qr_images.length)

    # Send the merged QR code image as a response
    send_file merged_qr_code_path, type: 'image/png', disposition: 'inline'
  end
  
  def destroy
    @article.destroy
    redirect_to articles_url, notice: "Article was successfully destroyed."
  end

  private
  
  
  def generate_qr_with_article(article) 
    data = article_url(article)
    qr = RQRCode::QRCode.new(data, size: 8, level: :h)
    qr_code = qr.as_png(size: 130)
    image = MiniMagick::Image.read(qr_code.to_s)
    text = "#{article.code}"
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
    image  
  end
  def merge_qr_codes(qr_images, article_count)
    grid_columns = Math.sqrt(article_count).ceil
    grid_rows = (article_count / grid_columns.to_f).ceil
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    merged_qr_code_path = Rails.root.join('public', "qr_codes_#{timestamp}.png")
    MiniMagick::Tool::Montage.new do |montage|
      montage.geometry '100x100'  # Define the size of each tile
      montage.tile "#{grid_columns}x#{grid_rows}"  # Define the grid layout

      # Append all the QR code images to the montage
      qr_images.each do |qr_image|
        montage << qr_image.path
      end

      # Set the output path for the merged QR code image
      montage << merged_qr_code_path
    end

    merged_qr_code_path
  end
  
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:name, :code, :photo, :price, :promo_price, :on_promo)
  end
end
