def text_animation
  animate = " ✨                                      ✨"
  10.times do
    sleep 0.2
    print "\r"
    print(animate)
    sleep 0.2
    print "\r"
    print(animate.reverse)
  end
  sleep 0.5
end

text_animation
