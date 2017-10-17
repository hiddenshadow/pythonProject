#!/usr/bin/python

import ConfigParser
from allocator.Config import Config
from utils.LogUtils import timeit


def getValue(section, property, configParser):
	value = configParser.get(section, property)
	# print 'section: '+section+', property: '+property+', value: '+value
	return value

def getIntValue(section, property, configParser):
	value = int( getValue(section, property, configParser) )
	# print value
	return value

def logEx(logStr, ex):
	print logStr,ex
	return

def log(logStr):
	print logStr
	return

@timeit
def getConfig(config_file, def_file):
	configObj=None
	try:
		configParser = ConfigParser.RawConfigParser()
		configParser.readfp(open(def_file)) # Reading default config.

		if config_file is None:
			log('No config files added! Using default configs.')
		elif len(config_file) == 0 :
			log('Empty config files list! Using default configs.')
		else:
			dataset = configParser.read(config_file)
			if len(dataset) != 1:
				raise ValueError, "Failed to open/find config file: "+config_file

		# Todo: Validate Config data
		host = getValue("db" , 'host', configParser)
		user = getValue('db', 'user', configParser)
		password = getValue('db', 'password', configParser)
		database = getValue('db', 'database', configParser)
		port = getValue('db', 'port', configParser)
		assignCount = getIntValue('allocation', 'assignCount', configParser)
		role = getValue('allocation', 'role', configParser)
		customerTable = getValue('allocation', 'customerTable', configParser)
		roleTable = getValue('allocation', 'roleTable', configParser)

		welCalStatusToPick = getValue('allocation', 'welCalStatusToPick', configParser)
		allocatingStatus = getValue('allocation', 'allocatingStatus', configParser)

		logConfigFile = getValue('logging', 'logConfigFile', configParser)
		appName= getValue('logging', 'appName', configParser)


		configObj = Config(host=host,user=user,password=password,database=database,port=port,
						   assignCount=assignCount,role=role,customerTable=customerTable,
						   roleTable=roleTable,welCalStatusToPick=welCalStatusToPick,
						   allocatingStatus=allocatingStatus,logConfigFile=logConfigFile,appName=appName)
	except ValueError, v:
		raise v
	except Exception, e:
		raise e
	finally:
		pass

	return configObj
