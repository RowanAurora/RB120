class Student
  #attr_accessor :name
  #attr_reader :grade

  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  def grade
    @grade
  end

end

joy = Student.new("Joy", 90)
max = Student.new("Max", 83)

puts "well done" if joy.better_grade_than?(max)
puts joy.grade