# University Informations

Bu rest api ile üniversiteleri ve öğrencileri listeleme,  üniversitelerin ve öğrencilerin ayrıntılarını görme, ve yeni öğrenci oluşturup, oluşturulan öğrenciyi üniversiteye kaydetme yapılabilir.

## Kullanım
| HTTP Verbs    | Paths                        | Used for                 |
| ------------- |:----------------------------:| ------------------------:|
| GET           | /universtities               | Get all universities     |
| GET           | /universities/:university_id | Show a single university |
| GET           | /students                    | Get all students         |
| POST          | /students                    | Create a new student     |
| GET           | /students/:student_id        | Show a single student    |
