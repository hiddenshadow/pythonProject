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