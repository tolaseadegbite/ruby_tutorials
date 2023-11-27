states = ["Oyo", "Adamawa", "Akwa Ibom", "Ogun"]

# domain url
domain_url = "https://example.com/"

# returns a url-friendly version of a string
def urlify(string)
    string.split(" ").join("-")
end

# urls: imperative version
def imperative_urls(states)
    urls = []
    states.each do |state|
        urls << state.downcase.split(" ").join("-")
    end
    urls
end

p imperative_urls(states)

# urls: functional version

def functional_urls(elements)
    domain_url = "https://example.com/"
    elements.map{ |e| "#{domain_url}#{urlify(e)}" }
end

p functional_urls(states)

# singles: imperative version
def imperative_singles(states)
    singles = []
    states.each do |state|
        if state.split(" ").length > 1
            singles << state
        end
    end
    singles
end

p imperative_singles(states)

# singles: functional version

def functional_singles(states)
    states.select{ |state| state.split(" ").length > 1 }
end

p functional_singles(states)

# length: imperative version
def imperative_length(states)
    length = {}
    states.each do |state|
        length[state] = state.length
    end
    length
end

p imperative_length(states)

numbers = 1..10

# sum: imperative version
def imperative_sum(numbers)
    total = 0
    numbers.each do |number|
        total += number
    end
    total
end

p imperative_sum(numbers)

# sum: functional sum
def functional_sum(numbers)
    numbers.reduce{ |total, n| total += n }
end

p functional_sum(numbers)