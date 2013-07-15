_ = require 'underscore'
sinon = require 'sinon'

processArgv = require '../../lib/process.argv.js'

module.exports = 
  setUp: (callback) ->
    callback()

  tearDown: (callback) ->
    callback()

  'it should parse correct arguments': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js', 
      '-browsers', 
      'firefox,chrome', 
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '-paths', 
      '/404.html',
      '-report-format',
      'html',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv

    test.ok _.isEqual _.keys(config), ['seleniumHost', 'browsers', 'envHosts', 'paths', 'reportFormat']
    test.ok _.isEqual config.browsers, ['firefox', 'chrome']
    test.ok _.isEqual config.envHosts, { build: 'http://localhost:4000', prod: 'http://ishouldbeageek.me' }
    test.ok _.isEqual config.paths, ['/404.html']
    test.ok _.isEqual config.reportFormat, 'html'
    test.ok _.isEqual config.seleniumHost, 'http://localhost:4444/wd/hub'
    test.done()

  'it should ignore the blank between ","': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js', 
      '-browsers', 
      ' firefox , chrome ',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '-paths', 
      '/404.html',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv
    test.ok _.isEqual config.browsers, ['firefox', 'chrome']
    test.done()

  'it should ignore value is empty': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js', 
      '-browsers', 
      ' firefox , chrome ',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '-paths', 
      '/404.html, ',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv
    test.ok _.isEqual config.paths, ['/404.html']
    test.done()
  
  'it should set default browser "firefox" when no browsers argument': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '-paths', 
      '/404.html, ',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv
    test.ok _.isEqual config.browsers, ['firefox']
    test.done()

  'it should set default report format "html" when no -report-format': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '-paths', 
      '/404.html, ',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv
    test.ok _.isEqual config.reportFormat, 'html'
    test.done()

  'it should throw error when envHosts is not set': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js',
      '-paths', 
      '/404.html, ',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    test.throws ->
      config = processArgv argv

    test.done()

  'it should throw error when paths is not set': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    test.throws ->
      config = processArgv argv

    test.done()

  'it will overide configuration when set custom.config.js and args at same time': (test) ->
    argv = [ 
      'node', 
      '/Users/tw/Projects/viff/lib/index.js',
      '-envs', 
      'build=http://localhost:4000,prod=http://ishouldbeageek.me', 
      '/Users/tw/Projects/viff/test/src/test.config.js',
      '-paths', 
      '/404.html',
      '-selenium-host',
      'http://localhost:4444/wd/hub'
    ]

    config = processArgv argv

    test.ok _.isEqual config.browsers, ['firefox']
    test.ok _.isEqual config.envHosts, { build: 'http://localhost:4000', prod: 'http://ishouldbeageek.me' }
    test.ok _.isEqual config.paths, ['/404.html']
    test.ok _.isEqual config.reportFormat, 'html'
    test.done()



  
