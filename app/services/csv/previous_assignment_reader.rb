require 'csv'

module Csv
  class PreviousAssignmentReader
    def self.read(file_path)
      history = {}
      CSV.read(file_path, headers: true).each do |row|
        history[row['Employee_EmailID']] = row['Secret_Child_EmailID']
      end
      history
    rescue Errno::ENOENT
      {}
    end
  end
end
