# Created by Zachary Burchill, 2019, adapted by Peter Wills, 2020

# Feel free to use/modify however you want, but be nice and please give Zachary
# credit/attribution.
#
# Put this file in your jupyter directory and load it in the first cell with:
#   %load_ext magics
# After that, you can use %%notify.

from IPython.core.magic import Magics, cell_magic, magics_class
import logging

logger = logging.getLogger(__name__)


@magics_class
class MyMagics(Magics):
    @cell_magic
    def notify(self, line, cell):
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
