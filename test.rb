#! /usr/bin/env ruby

require '/home/mogmi/Prog/Ruby/Assignment2/code_generation'

pclasse = Model.generate("/home/mogmi/Prog/Ruby/Assignment2/person_class.yml")

persons = pclasse.load_from_file('/home/mogmi/Prog/Ruby/Assignment2/persons.yml')

puts "=> " + String(persons)

puts 'Done'
