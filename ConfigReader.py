#!/usr/bin/python

import ConfigParser
from allocator.Config import Config
from utils.LogUtils import timeit,testPath


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
def getConfig(config_files, def_file):
	configObj=None

	try:
		configParser = ConfigParser.RawConfigParser()
		configParser.readfp(open(def_file)) # Reading default config.

		if config_files is None:
			log('No config files added! Using default configs.')
		elif len(config_files) == 0 :
			log('Empty config files list! Using default configs.')
		else:
			dataset = configParser.read(config_files)
			if len(dataset) != len(config_files):
				raise ValueError, "Failed to open/find all files"

		# Todo: Validate Config data
		host = getValue("db" , 'host', configParser)
		user = getValue('db', 'user', configParser)
		password = getValue('db', 'password', configParser)
		database = getValue('db', 'database', configParser)
		port = getValue('db', 'port', configParser)
		assignCount = getIntValue('db', 'assignCount', configParser)
		role = getValue('db', 'role', configParser)
		customerTable = getValue('db', 'customerTable', configParser)
		roleTable = getValue('db', 'roleTable', configParser)

		welCalStatusToPick = getValue('allocation', 'welCalStatusToPick', configParser)
		allocatingStatus = getValue('allocation', 'allocatingStatus', configParser)

		logConfigFile = getValue('logging', 'logConfigFile', configParser)

		# errorLogFile = getValue('logging', 'errorLogFile', configParser)
		# infoLogFile = getValue('logging', 'infoLogFile', configParser)


		configObj = Config(host=host,user=user,password=password,database=database,port=port,
						   assignCount=assignCount,role=role,customerTable=customerTable,
						   roleTable=roleTable,welCalStatusToPick=welCalStatusToPick,
						   allocatingStatus=allocatingStatus,logConfigFile=logConfigFile)
	except ValueError, v:
		logEx('ValueError: ',v)
		raise v
	except Exception, e:
		print 'Exception while getting config:', e
		raise e
	finally:
		pass

	return configObj



# class Dimension:
# 	def __init__(self, width, height):
# 		self.__width = width
# 		self.__height = height
#
# 	# @property
# 	def width(self):
# 		return self.__width
#
# 	# @property
# 	def height(self):
# 		return self.__height
#
# def testObject():
# 	d = Dimension(800, 400)
#
# 	# print d.width
# 	# print d.height
# 	return d
#
# # testObject()