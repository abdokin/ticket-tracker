class HomeController < ApplicationController
    def index
        flash[:notice] = "Welcome to the home page!"
    end
end
