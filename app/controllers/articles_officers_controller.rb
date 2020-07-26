class ArticlesOfficersController < ApplicationController
  before_action :require_login

  def create
    @articles_officer = ArticlesOfficer.create(articles_officer_params)
    redirect_to edit_article_path(@articles_officer.article)
  end

  def destroy
    @articles_officer = ArticlesOfficer.find(params[:id])
    @articles_officer.destroy
    redirect_to edit_article_path(@articles_officer.article)
  end

  def update
    @articles_officer = ArticlesOfficer.find(params[:id])
    @articles_officer.attributes = articles_officer_params
    @articles_officer.save!
    redirect_to edit_article_path(@articles_officer.article)
  end

  private
  def articles_officer_params
    params.require(:articles_officer).permit(:officer_id, :article_id, :confirmed, :status)
  end
end
