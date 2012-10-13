###
  The Configuration class contains serveral configuration fields that
	Kaffee uses.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Configuration
	@NAME: "Kaffee"
	@VERSION: "0.3.3"
			
	###
	  Default filename of the project configuration file.
	###
	@DEFAULT_PROJECT_CONFIG_FILE: "package.json"
	
	###
	  The super project configuration object.
	###
	@SUPER_PROJECT_CONFIG: 
		version: "0.0.1"
		dependencies: []
		kaffee: 
			###
			  Default Kaffee plugins.
			###
			plugins: {}
				
			###
			  The default directory structure.
			###
			structure:
				"src" : "./src/main"
				"bin" : "./lib/main"
				"src-test" : "./src/test"
				"bin-test" : "./lib/test"

			
			###
			  Default lifecycles.
			###
			lifecycles: 
				"compile" : []
				"install" : []
				"test" : []
				"deploy" : []
				"package" : []
				"clean" : ["kaffee-plugin:clean"]
			
			###
			  Parent project.
			###
			parent: ""
			
			###
			  Child projects of this project.
			###
			modules: []

module.exports = Configuration;
