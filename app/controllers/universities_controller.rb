class UniversitiesController < ApplicationController

    # GET /universities
    def index
        @universities = University.select("id", "name")
        render json: @universities
    end

    # GET /universities/:id
    def show
        begin
            @university = University.find(params[:id]).as_json(
                except: [:created_at, :updated_at],
                include: {students: {only: [:id, :name, :started_at]}}
            )
            render json: @university
        rescue
            render json: {"status": "error", "message": params[:id] + " numaralı üniversite kaydı bulunamadı"}
        end
      end

    # POST /universities
    def create
        @university = University.new(university_params)
        render json: @university, status: :created
    end

    private
        def university_params
            params.require(:university).permit(:api_id, :name, :city, :web_page, :type, :founded_at)
        end
end
