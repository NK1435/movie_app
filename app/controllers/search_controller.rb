require 'net/http'
require "json"
require 'uri'

class SearchController < ApplicationController
    def index
        @movies = search_movies(params[:search])
        #映画アクセスランキングデータの準備
        @ranking = MovieAccess.all
        @ranking = MovieAccess.group(:id)
        @ranking = MovieAccess.sort {|a,b| a[1] <=> b[1]}.reverse.map{|s| s[0]}.take(3)
    end
    
    def show
        @movie=get_movie(params[:id])
        #閲覧記録を追加
        #titleとmovie_id 
        @movie_access = MovieAccess.new(title: @movie["title"],movie_id: @movie["id"])
        if @movie["title"] == nil && @movie["id"] == nil
            puts []
        else 
            @movie_access.save
        end    
    end
    
    private
    
    def search_movies(title)
        url =  URI.encode("https://api.themoviedb.org/3/search/movie?api_key=118f2e5c4f9f1d17942a3271a18b5ea2&query=#{title.to_s}")
        res = Net::HTTP.get(URI.parse(url))
        json = JSON.parse(res)
        if json["results"] == nil
            []
        else
        json["results"].map do |m|
            #ハッシュの形で変数rのnameとprofile_pathをnameで、変数rのidをidで出力する
            {title: m['title']+m['poster_path'].to_s, id: m['id']}
            end
        end
    end
    
    def get_movie(id)
    #uriをurlに変換する
    url =  URI.encode("https://api.themoviedb.org/3/movie/#{id}?api_key=118f2e5c4f9f1d17942a3271a18b5ea2&language=ja-JP")
    #getで引数のurlにアクセスしてレスポンスを受け取る
    res = Net::HTTP.get(URI.parse(url))
    #引数に渡されたjson形式のデータをrubyオブジェクトに変換
    JSON.parse(res)
    end 
end
