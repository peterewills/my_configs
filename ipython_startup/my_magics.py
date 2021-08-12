# Created by Zachary Burchill, 2019, adapted by Peter Wills, 2020
#
# https://gist.github.com/burchill/4adb9531a246e8c27752c1b19e0236bb
#
# Feel free to use/modify however you want, but be nice and please give Zachary
# credit/attribution.
#
# This magic should be loaded automatically, since load_extensions.ipy gets run at
# startup. If not, you should be able to do `%load_ext my_magics` and load it.
#
# Then, you can just add `%%notify` at the top of a cell, and a notification will alert
# you when the cell has finished running.

from IPython.core.magic import Magics, line_cell_magic, magics_class
import logging

logger = logging.getLogger(__name__)


@magics_class
class MyMagics(Magics):
    @line_cell_magic
    def notify(self, line, cell=None):
        """
        Notifies when the cell finishes running, if pync is available.
        """
        # If there isn't any `cell` (ie its a single line), execute the line
        exec_val = line if cell is None else cell
        self.shell.run_cell(exec_val)
        try:
            import pync

            pync.notify("Cell execution completed!")
        except ModuleNotFoundError:
            logger.info("module pync not found, notifications not available")


# This needs to be in the file so Jupyter registers the magics when it's loaded
def load_ipython_extension(ipython):
    ipython.register_magics(MyMagics)
