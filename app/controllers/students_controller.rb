class StudentsController < ApplicationController

    # GET /students
    def index
        # get students with only id, name and university_id columns, also include university
        @students = Student.select("id", "name", "university_id").as_json(
            except: [:university_id],
            include: {university: {only: [:name]}}
            )
        @students.each do |student|
            student["university"] = student["university"]["name"]
        end
        render json: @students
    end

    # GET /students/:id
    def show
        begin
            # get student with only id, name and started_at columns, also include university
            @student = Student.find(params[:id]).as_json(
                :only => [:id, :name, :started_at],
                :include => [:university => {:only => [:id, :name, :founded_at, :type]}]
                )
            # format started_at and founded_at of university columns
            @student["started_at"] = @student["started_at"].strftime("%F")
            @student["university"]["founded_at"] = @student["university"]["founded_at"].strftime("%F")
            render json: @student
        rescue
            render json: {"status": "error", "message": params[:id] + " numaralı öğrenci kaydı bulunamadı"}
        end
      end

    # POST /students
    def create
        errors = check_params(params['name'], params['started_at'])
        # Check the errors variable is nil.
        if errors.nil?
            date = Date.strptime(params['started_at'], '%Y-%m-%d')
            time = Time.new(date.year, date.month, date.day)
            university_api_id = params['university']
            university = University.where(api_id: university_api_id).first
            if university.present?
                student_save(params['name'], time, university.id)
            else
                require 'net/http'
                source = 'https://gitlab.com/kodiasoft/intern/2019/snippets/1859421/raw'
                resp = Net::HTTP.get_response(URI.parse(source))
                data = resp.body
                result = JSON.parse(data)
                university = result.find{|s| s["id"] == university_api_id.to_i }
                university_time = Time.new(university['founded_at'])
                @university = University.new(api_id: university['id'], name: university['name'], city: university['city'], web_page: university['web_page'], type: university['type'], founded_at: university_time)
                @university.save
                student_save(params['name'], time, @university.id)
            end
        else
            render json: errors
        end
    end

    private
        # Check parameters and set error messages
        # @param [String] name
        # @param [String] started_at
        # @return [nil, object]
        def check_params(name, started_at)
            name_errors = []
            started_at_errors = []
            errors = []

            # Check the name variable is blank.
            if name.blank?
                # If the name variable is blank then push the error message to name_errors array.
                name_errors.push("Öğrenci adı boş bırakılamaz")
            end

            # Check the started_at variable is blank.
            if started_at.blank?
                # If the started_at variable is blank then push the error message to started_at_errors array.
                started_at_errors.push("Üniversiteye başlangıç tarihi boş bırakılamaz")
            # Check the started_at variable date is in future.
            elsif Date.strptime(started_at, '%Y-%m-%d').future?
                # If the started_at variable is in future then push the error message to started_at_errors array.
                started_at_errors.push("Kişinin üniversiteye başlangıç tarihi bugünden büyük olamaz.")
            end
            
            # Check the name_errors variable is not empty.
            if !name_errors.empty?
                # If the name_errors variable is not empty then push this object.
                errors.push({"key": "name", "errors": name_errors})
            end

            # Check the started_at_errors variable is not empty.
            if !started_at_errors.empty?
                # If the started_at_errors variable is not empty then push this object.
                errors.push({"key": "started_at", "errors": started_at_errors})
            end
            
            # If errors array is empty return nil, else return status, message and errors.
            return errors.empty? ? nil : {"status": "error", "message": "Öğrenci eklenirken hata oluştu", "errors": errors}
        end

        # Save the student
        # @param [String] name
        # @param [Datetime] started_at
        # @param [Integer] university_id
        def student_save(name, started_at, university_id)
            @student = Student.new(name: name, started_at: started_at, university_id: university_id)
            @student.save
            render json: {
                "id": @student.id,
                "status": "success",
                "message": @student.name + " adlı öğrenci " + @student.university.name + "'ne başarıyla eklendi."
              }
        end
end
