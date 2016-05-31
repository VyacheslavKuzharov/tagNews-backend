class Api::NewsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    news = News.all
    news = news.by_date.page(params[:page]).per(5)

    info = {}
    info[:news_count] = News.count

    respond_to do |format|
      format.html
      format.json { render json: news.map{|news| news.as_json(except: :image)
                                                     .merge(description: truncate(news.description, length: 220, separator: ' '),
                                                            small_image: news.image.url(:small)
                                                     )}.as_json << info
      }
    end
  end

  def show
    single_news = News.find_by_id params[:id]
    photos = single_news.photos

    respond_to do |format|
      format.json {render json: single_news.as_json
                                    .merge(image: single_news.image.url,
                                           photos: photos.map{|photo| {id: photo.id, url:photo.photo.url} }
                                    )
      }
    end
  end

  def top_news
    news = News.top_news_only.order('created_at desc')

    respond_to do |format|
      format.json {render json: news.map{|news| news.as_json(except: :image)
                                                    .merge(description: truncate(news.description, length: 180, separator: ' '),
                                                           small_image: news.image.url(:small))}
      }
    end
  end

  def comments
    article = News.find_by_id params[:id]
    comments = article.comments

    respond_to do |format|
      format.json { render json: comments.map{|comment| comment.as_json.merge(user: comment.user, avatar: 'http://www.hdwallpaperspulse.com/wp-content/uploads/2012/10/lovely-smile-wallpaper.jpg') } }
    end
  end
end
