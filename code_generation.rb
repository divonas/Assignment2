#! /usr/bin/env ruby

require 'yaml'

module Model
=begin
=end

    def self.get_class_elements(file_path)
    # This methods opens the file file_path and returns a dictionnary with :
    # {title: [title], attributes: [attributes], constraints: [constraints]}
        res = {:attributes => [], :constraints => {}}
        method_source = File.open(file_path).read
        method_source.each_line do |line|
            line = line.gsub(/\s+/, '').split(':')
            case line[0]
            when 'title'
                res[:title] = line[1]
            when 'attribute'
                att_name = line[1].split(',')[0]
                res[:attributes].push(att_name)
                res[:constraints][att_name] = []
            when 'constraint'
                att_name = line[1].split(',')[0]
                # We check if the attribute exists
                if (res[:attributes].include?(att_name))
                    const = line[1].split(',')[1]
                    # We remove the quotes
                    res[:constraints][att_name].push(eval(const))
                end
            end
        end
        puts res
        return res
    end

    def self.generate(file_path)
        src = get_class_elements(file_path)
        class_title = src[:title]
        #puts %(class #{class_title}; end)
        # We create the class
        eval %(class #{class_title}; end)
        # We get the class
        curr_class = eval(class_title)

        # For every attribute, we add it to the new class
        # Maybe putting everything in 1 string and do only 1 eval
        # is better for perfs
        src[:attributes].each { |attr|
            # we get the constraints for this attribute
            consts = src[:constraints][attr]
            # We create a statement with the constraints
            const_list = 'true'
            consts.each { |c|
                const_list += " and " + '(@' + c + ')'
            }
            # we need to differenciate getter and setter, with val
            const_list_set = const_list.gsub('@' + attr, 'val')
            code = %(
                def #{attr}
                    if (#{const_list})
                        @#{attr}
                    else
                        raise
                    end
                end
                def #{attr}=(val)
                    if (#{const_list_set})
                        @#{attr} = val
                    else
                        raise
                    end
                end
            )
            curr_class.class_eval(code)
        }

        # We create the method load_from_file
        curr_class.class_eval do
            def pomme
                puts class_title
            end
        end
        
        # We return the class
        return curr_class
    end
end

#m = Model
#c = m.generate("/home/mogmi/Prog/Ruby/Assignment2/person_class.yml")
#puts c.methods

=begin
puts m
        yml = YAML::load(File.open(file_path))
=end
