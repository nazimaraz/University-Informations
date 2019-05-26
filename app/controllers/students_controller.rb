class StudentsController < ApplicationController

    # GET /students
    def index
        @students = Student.select("id", "name", "university_id").as_json(
            except: [:university_id],
            include: {university: {only: [:name]}}
            )
        render json: @students  
    end

    # GET /students/:id
    def show
        begin
            @student = Student.find(params[:id]).as_json(
                :only => [:id, :name, :started_at],
                :include => [:university => {:only => [:id, :name, :founded_at, :classification]}]
                )
            render json: @student
        rescue
            render json: {"status": "error", "message": params[:id] + " numaralı öğrenci kaydı bulunamadı"}
        end
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
