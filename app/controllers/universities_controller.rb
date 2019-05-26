class UniversitiesController < ApplicationController

    # GET /universities
    def index
        @universities = University.all
        render json: @universities
    end

    # GET /universities/:id
    def show
        @university = University.find(params[:id])
        render json: @university
      end

    # POST /universities
    def create
        @university = University.new(university_params)
        render json: @university, status: :created
    end

    private
        def university_params
            params.require(:university).permit(:api_id, :name, :city, :web_page, :classification, :founded_at)
        end
end
