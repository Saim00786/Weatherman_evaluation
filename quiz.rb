def get_Questions_and_Answers(filename)
  fd = File.open(filename,"r")
  str =  fd.read
  lines  = str.split()
  questions =[]
  lines.each {|a|
    tmp = Hash.new
    tmp["Q"],tmp["A"] = a.split(',')
    questions << tmp
  }
  return questions
end

def startQuiz(questions,total_time=30)
  if total_time == 0
    total_time = 30
  end
  puts 'Press enter to start the Quiz...'
  gets

  before = Time.now.to_i
  count = 0
  t1 = nil;

  t2 = Thread.new{
    total_time.times do
      sleep(1)
    end

    puts "Time out."
    t1.exit
  }

  t1 = Thread.new {
    questions.each{
      |q|
      system("clear")
      sec = Time.now.to_i - before
      puts "You have #{total_time - sec} seconds to solve these Questions. :)"
      puts "What is #{q["Q"]} ?"

      while ans = Integer(gets.chomp) rescue true
        if ans.is_a? Integer
          count = count+1 if ans.to_s == q["A"]
          break
        else
          puts "Invalid. Enter again"
        end
      end

    }
    t2.exit
    system("clear")
  }
  t1.join
  t2.join

  return count
end

questions= get_Questions_and_Answers("problems.csv")
puts "Enter time (leave empty for default):"
timer = gets.strip.to_i

system("clear")

correct= startQuiz(questions,timer)
puts "#{correct} out of #{questions.length} questions were correct."

