#!/user/bin/python

import time
import os
import logging

# http://www.pythonforbeginners.com/files/reading-and-writing-files-in-python
# https://www.andreas-jung.com/contents/a-python-decorator-for-measuring-the-execution-time-of-methods

def timeit(method):

    def timed(*args, **kw):
        ts = time.time()
        result = method(*args, **kw)
        te = time.time()

        # print '%r (%r, %r) %2.2f sec' % \
        #       (method.__name__, args, kw, te-ts)

        printStr='%r %2.2f sec' % \
              (method.__name__, te-ts)

        logging.info(printStr)

        return result

    return timed

def testPath():
    print 'os.path.dirname: '+os.path.dirname(os.path.abspath(__file__))
    print 'os.getcwd: '+os.getcwd()



# Read fileNames once from init.py - logging.conf
# Log should be based on input fileName param - Logger & getLogger('simpleExample')
# Logger should also work fine with static methods, when ingested through param
# Should support diff log levels [5] - logger.debug()

# def log(logger, log_str, level):
#     writeLog(logger, log_str)
#     return
#
# def logErr(file, log_str, err):
#     errStr = log_str + str(err)
#     writeLog(file, errStr)
#     return
#
# def writeLog(logger, str):
#     logger.write(str)
