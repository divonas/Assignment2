module MyArray
    def pomme
        puts 'Zef is cool!'
    end
end

class Array
    include MyArray
    extend MyArray
end

#=beginArray.extend(MyArray)

#a = Array.new()
#a.pomme

#a[0] = "ok"
#puts a
#end=
