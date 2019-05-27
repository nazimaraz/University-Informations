class UniversitiesController < ApplicationController

    # GET /universities
    def index
        # get universities with only id and name columns
        @universities = University.select("id", "name")
        render json: @universities
    end

    # GET /universities/:id
    def show
        begin
            # get university except created_at and updated_at columns, also include students
            @university = University.find(params[:id]).as_json(
                except: [:created_at, :updated_at],
                include: {students: {only: [:id, :name, :started_at]}}
            )
            # format founded_at and started_at of students columns
            @university["founded_at"] = @university["founded_at"].strftime("%F")
            @university["students"].each do |student|
                student["started_at"] = student["started_at"].strftime("%F")
            end
            render json: @university
        rescue
            render json: {"status": "error", "message": params[:id] + " numaralı üniversite kaydı bulunamadı"}
        end
      end
end
