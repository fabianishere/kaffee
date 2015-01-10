Fs = require "fs"
Path = require "path"

CoffeeScript = require "coffee-script"
###
  The kaffee-coffeemaker plugins compiles Coffeescript files into Javascript files.
  
  @version 0.0.1
  @author Fabian M. <mail.fabianm@gmail.com>
###
module.exports = ->
	###
	  Utility to create a directory.
	  
	  @since 0.0.1
	  @param path The path to the directory to create.
	###
	mkdir = (path) ->
  		try
  			Fs.mkdirSync path
  		catch e
      			if e.errno is 34
      				mkdir Path.dirname(path)
      				mkdir path
	###
	  Returns an array of Coffeescript files in the given directory
		and its childs.

	  @since 0.0.1
	  @param path The path to the directory.
	  @return An array of Coffeescript files in the given directory
		and its childs.
	###
	getFiles = (path) ->
		return [] if not Fs.existsSync path
		files = []
		files.push Path.join(path, file) for file in Fs.readdirSync path
		files

	###
	  Tests all Coffeescript files in the given directory.

	  @since 0.0.1
	  @param path The path to the directory to check.
	  @return <code>true</code> if no errors occured, <code>false</code> otherwise.
	###
	test = (path) ->
		ok = true
		for file in getFiles(path)
			try 
				stats = Fs.lstatSync file
				if stats.isDirectory()
					ok = false unless test.call this, file
					continue
				CoffeeScript.compile Fs.readFileSync(file, 'UTF-8') if Path.extname(file) is ".coffee"
			catch e
				e.message += " in #{ file }"
				this.logger.error e
				return false
		ok
		
	###
	  Compiles all Coffeescript files in the given directory.

	  @since 0.0.1
	  @param goal The goal instance.
	  @param path The path to the input directory.
	  @param output The path to the output directory.
	###
	compile = (path, output) ->
		return unless test.call this, path	
		files = getFiles path
		mkdir output unless Fs.existsSync(output) and files.length > 0
		for file, i in getFiles(path)
			try
				stats = Fs.lstatSync file
				compile.call this, file, Path.join(output, Path.basename(file)) if stats.isDirectory()
				if Path.extname(file) is ".coffee"
					this.logger.info file
					fd = Fs.openSync Path.join(output, Path.basename(file, ".coffee") + ".js"), "w"					
					out = CoffeeScript.compile Fs.readFileSync(file, 'UTF-8')
					Fs.writeSync fd, out, 0, out.length
					Fs.closeSync fd
				else if Path.basename(file) is "package.json"
					this.logger.info file
					fd = Fs.openSync Path.join(output, Path.basename(file)), "w"
					out = Fs.readFileSync file, 'UTF-8'
					Fs.writeSync fd, out, 0, out.length
					Fs.closeSync fd		
			catch e
				e.message += " in #{ file }"
				this.logger.error e
				
	###
	  Compiles Coffeescript files into Javascript files.
	###
	this.register "compile", (request) ->
		this.dependsOn "clean", request
		structure = this.getProject().getConfiguration().getKaffeeConfiguration().getStructure()
		return this.logger.warn "No structure" unless structure
		this.logger.info "Compiling files for project #{ this.getProject().getConfiguration().getName() }"
		compile.call this, structure.get('src'), structure.get('bin')
		compile.call this, structure.get('src-test'), structure.get('bin-test')
	###
	  Tests Coffeescript files.
	###
	this.register "test", ->
		structure = this.getProject().getConfiguration().getKaffeeConfiguration().getStructure()
		return this.logger.warn "No structure" unless structure
		this.logger.info "Testing files for project #{ this.getProject().getConfiguration().getName() }"
		ok = test.call(this, structure.get('src')) and test.call(this, structure.get('src-test'))
		if ok then this.logger.info "Test passed!" else this.logger.warn "Test failed!"
		
	###
	  Registers the archtype.
	###
	this.archtype 
		kaffee: 
			plugins: 
				"kaffee-coffeemaker" : {}
			lifecycles: 
				"compile" : ["kaffee-coffeemaker:compile"]
				"test" : ["kaffee-coffeemaker:test"]
		
