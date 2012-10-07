# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
###
  The Configuration class contains serveral configuration fields that
	Kaffee uses.

  @version 0.3.0
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Configuration
	@NAME: "Kaffee"
	@VERSION: "0.3.0"
	
	###
	  Merges two objects into one.
	  
	  @since 0.3.0
	  @param o Original object.
	  @param a The object to merge it with.
	  @return The result.
	###
	merge = (o, a) -> 
			r = []
			for key, value of o
				r[key] = value
			return r if typeof o != 'object' || typeof a != 'object'
			for key, value of a
				if typeof o[key] == 'object'
					r[key] = merge(o[key], value)	
				else if typeof o[key] == 'array'
					r[key] = o[key].concat value
				else 
					r[key] = value
			r
			
	###
	  Default filename of the project configuration file.
	###
	@DEFAULT_PROJECT_CONFIG_FILE: "package.json"
	
	###
	  The super project configuration object.
	###
	@SUPER_PROJECT_CONFIG: {
		version: "0.0.1",
		dependencies: [],
		kaffee: {
			###
			  Default Kaffee plugins.
			###
			plugins: {
			},
				
			###
			  The default directory structure.
			###
			structure: {
				"src" : "./src/main",
				"bin" : "./lib/main"
				"src-test" : "./src/test"
				"bin-test" : "./lib/test"
			}
			
			###
			  Default lifecycles.
			###
			lifecycles: {
				"compile" : [],
				"install" : [],
				"test" : [],
				"deploy" : [],
				"package" : [],
				"clean" : []
			}
			
			###
			  Parent project.
			###
			parent: "",
			
			###
			  Childs of this project.
			###
			modules: []
		}
	}

	###
	  Currently available archtypes.
	###
	@ARCHTYPES: {
		"default": @SUPER_PROJECT_CONFIG,
		"kaffee-coffeemaker": merge(@SUPER_PROJECT_CONFIG, {
			kaffee: {
				plugins: {
					"kaffee-coffeemaker" : {}
				},
				lifecycles: {
					"compile" : ["kaffee-coffeemaker:compile"],
					"test" : ["kaffee-coffeemaker:test"]
				}
			}
		})
	}

module.exports = Configuration;
