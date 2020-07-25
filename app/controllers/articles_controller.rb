class ArticlesController < ApplicationController
  include Datatableable

  before_action :require_login, only: [:new, :create, :edit, :update]

  def datatable_class
    ArticleDatatable
  end

  def new
    @article = Article.new
  end

  def create
    url = params.require(:article)[:url]
    @article = ArticleFetcher.new(url).fetch
    existing = @article && Article.find_by(url: @article.url)

    if existing
      # if an article w/ this url already exists, redirect to it
      flash[:notice] = "Redirected to existing article with same URL"
      redirect_to edit_article_path(existing)
    elsif @article && @article.save
      redirect_to edit_article_path(@article)
    else
      @article ||= Article.new(url: url)
      @error = true
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.attributes = params.require(:article).permit(:url, :title, :date_published)
    if @article.save
      redirect_to edit_article_path(@article)
    else
      render :edit
    end
  end
end
