require 'csv'

module Csv
  class AssignmentWriter
    def self.write(file_path, assignments)
      CSV.open(file_path, 'w') do |csv|
        csv << [
          'Employee_Name',
          'Employee_EmailID',
          'Secret_Child_Name',
          'Secret_Child_EmailID'
        ]

        assignments.each do |a|
          csv << [
            a.giver.name,
            a.giver.email,
            a.receiver.name,
            a.receiver.email
          ]
        end
      end
    end
  end
end
