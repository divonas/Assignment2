#!/usr/bin/env ruby

module MyArray
	def select_first(exp)
		if exp.size == 1						#if there is 1 element in the dictionary
			value = exp[exp.keys[0]]
			if value.kind_of? Array				#attirbute values given in the array
				self.each do |item|
					value.each do |val|
						return item if item.send(exp.keys[0]) == val
					end
				end
			else
				self.each do |item|				#the value in the dictionary is item
					return item if item.send(exp.keys[0]) == value
				end
			end
		else									#if interval is given as well
			self.each do |item|
				if item.send(exp[:name]) <= exp[:interval][:max]
					if exp[:interval].size > 1
						return item if item.send(exp[:name]) >= exp[:interval][:min]
					else
						return item
					end
				end
			end
		end
	end
	def select_all(exp)
		resp = Array.new
		if exp.size == 1						#if there is 1 element in the dictionary
			value = exp[exp.keys[0]]
			if value.kind_of? Array				#attirbute values given in the array
				self.each do |item|
					value.each do |val|
						resp.push item if item.send(exp.keys[0]) == val
					end
				end
			else
				self.each do |item|				#the value in the dictionary is item
					resp.push item if item.send(exp.keys[0]) == value
				end
			end
		else									#if interval is given as well
			self.each do |item|
				if item.send(exp[:name]) <= exp[:interval][:max]
					if exp[:interval].size > 1
						resp.push item if item.send(exp[:name]) >= exp[:interval][:min]
					else
						resp.push item
					end
				end
			end
		end
		resp
	end
	
	def method_missing(mName, *args, &block)
		if mName.to_s =~ %r{select_first_where_(.*)_is$}
			puts $1
			puts args[0]
			eval "
				def self.#{mName}(argument)
					select_first(:#{$1} => argument)
				end
			"
		elsif mName.to_s =~ %r{select_first_where_(.*)_is_in$}
			eval "
				def self.#{mName}(#{$1})
					select_first(:name => :#{$1}, :interval => {:min => #{args[0]}, :max => #{args[1]}})
				end
			"
		elsif mName.to_s =~ %r{select_all_where_(.*)_is$}
			eval "
				def self.#{mName}(#{$1})
					select_all(:#{$1} => #{$1})
				end
			"
		elsif mName.to_s =~ %r{select_all_where_(.*)_is_in$}
			eval "
				def self.#{mName}(#{$1})
					select_all(:name => :#{$1}, :interval => {:min => #{args[0]}, :max => #{args[1]}})
				end
			"
		else 
		   super
		end	
		send(mName, args)   
	end
end

class Array
    include MyArray
    extend MyArray
end

