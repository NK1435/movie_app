require 'net/http'
require "json"
require 'uri'
# ApplicationControllerにクラスの継承
class MovieController < ApplicationController

  def index
    #@actorにActorの全データをorderメソッド(昇順)で取り出すメソッドを代入
    #@actors = Actor.all.order
    #引数params[:search]を受け取るメソッドを@actorsに代入
    @actors = search_actors(params[:search])
    
    #映画アクセスランキングデータの準備
    @ranking = MovieAccess.all
    @ranking = MovieAccess.group(:movie_id).count
    @ranking_sort = @ranking.sort {|a,b| a[1] <=> b[1]}.reverse.map{|s| s[0]}.take(3)
    @ranking_result = @ranking_sort.map do |a|
      MovieAccess.find_by(movie_id: a)
    end  
  end
  
  def show
    #paramsに入っているidを受け取るメソッドを@actorに代入
    @actor=get_actor(params[:id])
  end

  private
  #引数nameを受け取るメソッド
  def search_actors(name)
    #uriをurlに変換する
    url =  URI.encode("https://api.themoviedb.org/3/search/person?api_key=118f2e5c4f9f1d17942a3271a18b5ea2&query=#{name.to_s}")
    #URIを読み込んでHTTPを取得するレスポンス
    res = Net::HTTP.get(URI.parse(url))
    #レスポンスにjsonを読み込む
    json = JSON.parse(res)
    #jsonの"results"配列から１つずつ取り出してrという変数に代入する
    if json["results"] == nil
      []
    else
      json["results"].map do |r|
        #ハッシュの形で変数rのnameとprofile_pathをnameで、変数rのidをidで出力する
        {name: r['name']+r['profile_path'].to_s, id: r['id']}
      end
    end
  end
  
  #引数idを受け取るメソッド
  #引数に渡したidを持つactor情報(rubyオブジェクト)を返す
  def get_actor(id)
    #uriをurlに変換する
    url =  URI.encode("https://api.themoviedb.org/3/person/#{id}?api_key=118f2e5c4f9f1d17942a3271a18b5ea2&language=ja-JP")
    #getで引数のurlにアクセスしてレスポンスを受け取る
    res = Net::HTTP.get(URI.parse(url))
    #引数に渡されたjson形式のデータをrubyオブジェクトに変換
    JSON.parse(res)
  end  
  
  

end