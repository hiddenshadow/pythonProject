
import logging
import ConfigReader
from allocator import Core
from utils.LogUtils import timeit
import os, sys
import logging.config
import traceback

# https://docs.python.org/2/library/logging.html

@timeit
def execute():
    try:
        try:
            config_file = None
            argLen = len(sys.argv)

            if argLen == 1:
                print "Pass absolute path of Config file as first arg. No args passed!"
            else:
                config_file = sys.argv[1]

            dir = os.path.dirname(os.path.abspath(__file__))
            relativePath=dir+'/configuration/'
            default_file = relativePath+'defaults.cfg'
            configObj = ConfigReader.getConfig(config_file, default_file)
            logConfigFile = relativePath + configObj.logConfigFile()
        except Exception:
            print "Exception while getting config: "
            traceback.print_exc()
            sys.exit(1)

        initLogger(logConfigFile)

        app_name=configObj.appName()
        logging.info('Starting '+app_name+'\n')

        allocatorObj = Core.Allocator(configObj)
        allocatorObj.allocate()

    except IOError:
        logging.exception("IOError in execute: ")
        sys.exit(1)
    except Exception:
        logging.exception("Exception while allocating: ")
        sys.exit(1)
    finally:
        pass

    sys.exit()

def initLogger(log_config_file):
    print 'Using log config file: '+log_config_file
    logging.config.fileConfig(log_config_file)
    return

execute()