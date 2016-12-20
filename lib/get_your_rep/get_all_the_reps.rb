# require 'net/http'
# require 'csv'

##
# extension for the get_your_rep gem/module, seeds the db by programmatically collecting and
# saving data through external API callbacks

module GetYourRep
  class GetAllTheReps

    attr_accessor :csv_file
    attr_reader :zips, :zip_rows

    def initialize(csv_file)
      @csv_file = csv_file
      @zip_rows = []
      @zips = []
    end

    #read the csv file containing zips by state
    def read_zip_csv
      CSV.foreach("lib/seeds/zipcode_tabulation_csv_files/#{@csv_file}") do |row|
        @zip_rows << row
      end
    end

    # extract all state zips in one array
    def collect_zips
      read_zip_csv

      @zip_rows.each do |zip|
        @zips << zip[1] unless zip[1].nil? || zip[1].match(/[a-zA-Z]+/)
      end

      @zips
    end

    # iterate through zips and batch query API to save reps in DB
    def get_all_the_reps
      collect_zips

      i = 1
      @zips.each do |zip|
        # uri = URI("https://aqueous-anchorage-20771.herokuapp.com/reps?address=#{zip}")
        # Net::HTTP.get(uri)
        Rep.get_all_reps(zip)
        puts "Request ##{i} sent for #{zip}"
        i += 1
        sleep(4)
      end
    end
  end
end
