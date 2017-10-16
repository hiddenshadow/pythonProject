
import logging
import ConfigReader
from allocator import Core
from utils.LogUtils import timeit,testPath
import os
from utils import LogUtils
import logging.config

# https://docs.python.org/2/library/logging.html

@timeit
def execute():
    err_file=''
    try:
        app_name='WelcomeCall Allocator';

        testPath()

        dir = os.path.dirname(os.path.abspath(__file__))

        config_files = [dir+'/configuration/config.cfg']
        def_file = dir+'/configuration/defaults.cfg'

        configObj = ConfigReader.getConfig(config_files, def_file)

        # allocatorObj = Core.Allocator(configObj)
        # allocatorObj.allocate()

        logConfigFile=dir+'/configuration/'+configObj.logConfigFile()

        initLogger(logConfigFile)

        log_Str='Starting '+app_name+'\n'

        getLogger().info(log_Str)

        # logging.error("Test Error in Core.")
        raise (Exception("Test Error in Core."))

    except IOError, io:
        print "Exception in execute: ", io
        # logging.error("Exception in execute: "+io)
        logging.error("Exception in execute: ", io)
        return
    except Exception, e:
        # print "Exception in execute: ", e
        # getErrorLogger().error("Exception in execute: ", e)
        logging.exception("Printing stacktrace: ")
        # logging.error("Exception in execute: (using +)"+e)
        # logging.error("Exception in execute: (usign ,)", e)
        # logging.error("Exception in execute: ")
        return
    finally:
        # err_file.close()
        pass
    return


def initLogger(log_config_file):
    print 'Using log config file: '+log_config_file
    logging.config.fileConfig(log_config_file)
    return

# def log(log_str):
#     # print log_str
#     coreLogger = logging.getLogger('core')
#     LogUtils.log(coreLogger, log_str)
#     return
#
# def logErr(file, log_str, err):
#     LogUtils.logErr(file,log_str,err)
#     return

def getLogger():
    return logging.getLogger('core')

def getErrorLogger():
    # return logging.getLogger('errorLogger')
    return logging.getLogger('core')

execute()
