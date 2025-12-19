require 'csv'

module Csv
  class EmployeeReader
    def self.read(file_path)
      CSV.read(file_path, headers: true).map do |row|
        Employee.new(
          name: row['Employee_Name'].strip,
          email: row['Employee_EmailID'].strip
        )
      end
    rescue Errno::ENOENT
      raise AssignmentError, 'Employee CSV file not found'
    end
  end
end
