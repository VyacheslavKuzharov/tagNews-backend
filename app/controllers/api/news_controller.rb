class Api::NewsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    news = News.all
    news = news.by_date.page(params[:page]).per(20)

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
                                           photos: photos.map{|photo| photo.photo.url}
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
end
