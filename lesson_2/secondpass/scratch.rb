class Topclass
  CON = 7
end

module Outermod
CON = 1
  class Outerclass
    CON = 2
  end
  module Midmod
    #CON = 3

    class Midclass
      CON = 4
    end
    module Innermod
      #CON = 5
      class Innerclass < Topclass
       puts CON
      end
    end
  end
end

