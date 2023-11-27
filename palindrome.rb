# defines a phrase class (inheriting from string)
module Palindrome
    
    def palindrome?
        processed_content == processed_content.reverse
    end
    
    private

        def processed_content
            to_s.downcase
        end
end
