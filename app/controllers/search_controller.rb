class SearchController < ApplicationController
    def search
        #Viewのformで取得したパラメータをモデルに渡す
        @search = Actor.search(params[:search]) 
    end    
end
