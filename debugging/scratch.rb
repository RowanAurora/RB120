def increment(number)
  if block_given?
    yield(number + 1)
  end
  number + 1
end

# method invocation

p increment(5) do |num|
  puts num
end