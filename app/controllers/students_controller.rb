class StudentsController < ApplicationController

    # GET /students
    def index
        @students = Student.all
        render json: @students
    end

    # GET /students/:id
    def show
        @student = Student.find(params[:id])
        render json: @student
      end

    # POST /students
    def create
        @student = Article.new(student_params)
        render json: @student, status: :created
    end

    private
        def student_params
            params.require(:student).permit(:university_id, :name, :started_at)
        end
end
