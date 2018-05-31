require_relative '../config/environment'

LOGGER.info("load_all begin")

system 'ruby -S load_app_catalog.rb'
LOGGER.info("load_app_catalog complete")
system 'ruby -S load_solutions.rb'
LOGGER.info("load_solutions complete")
system 'ruby -S load_projects.rb'
LOGGER.info("load_projects complete")

LOGGER.info("load_all end")
