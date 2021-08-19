require 'date'
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  
  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  
  filename = "output/thanks_#{id}.html"
  
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_number(num)
  num = num.to_s.split('').filter {|char| %w(1 2 3 4 5 6 7 8 9 0).include?(char)}.join('')

  if num.length == 11 && num[0] == 1
    num.drop(1)
  elsif num.length == 10
    num
  else
    'invalid phone number'
  end
end

def proccess_datetime(datetime)
  date_arr = datetime.split('/')
  day = date_arr[1]
  month = date_arr[0]
  year = '20' + date_arr[2].split(' ')[0]
  time = date_arr[2].split(' ')[1]
  hour = time.split(':')[0]
  min = time.split(':')[1]
  dt = Time.new(year, month, day, hour, min)
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

def generate_letters(contents)
  template_letter = File.read('form_letter.erb')
  erb_template = ERB.new template_letter

  contents.each do |row|
    # id = row[0]
    # name = row[:first_name]
    # zipcode = clean_zipcode(row[:zipcode])
    # legislators = legislators_by_zipcode(zipcode)

    # form_letter = erb_template.result(binding)

    # save_thank_you_letter(id,form_letter)

  end
end

def target_hours(contents)
  hour_arr = []
  contents.each do |row|
    hour_arr.push(proccess_datetime(row[:regdate]).hour)
  end

  hour_list = hour_arr.reduce(Hash.new(0)) do |total, hour|
    total[hour] += 1 
    total
  end
  
  sorted_arr = hour_list.to_a.sort{|a, b| b[1] <=> a[1]}
  top_score = sorted_arr[0][1]

  top_hours = sorted_arr.filter { |arr| arr[1] == top_score }
end

def target_dof(contents)
  dof_arr = []
  contents.each do |row|
    dof_arr.push(proccess_datetime(row[:regdate]).wday)
  end

  dof_list = dof_arr.reduce(Hash.new(0)) do |total, dof|
    total[dof] += 1 
    total
  end

  sorted_arr = dof_list.to_a.sort{|a, b| b[1] <=> a[1]}
  top_score = sorted_arr[0][1]

  top_dof = sorted_arr.filter { |arr| arr[1] == top_score }
end

p target_hours(contents)