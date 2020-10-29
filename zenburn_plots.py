"""
Imports
-------

This script exposes a method in iPython that sets plotstyle to be
zenburn-themed. This is useful when running Emacs Ipython Notebook.

"""


#################################
### Zenburn Color References: ###
#################################

## Gray: #3F3F3F
## Light Gray: #6F6F6F
## White: #FFFFEF
## Red: #CC9393
## Green: #7F9F7F
## Orange: #DFAF8F
## Yellow: #F0DFAF
## Cyan: #93E0E3
## Blue: #8CD0D3
## Dark Red: #A55D5D
## Dark Green: #466F46
## Dark Blue: #4A7274
## Dark Orange: #A352E

##################################
### Change matplotlib defaults ###
##################################


def zenburn_plots(log_info=True):

    import matplotlib as mpl
    from cycler import cycler
    from matplotlib import pyplot as plt

    plt.rc("figure", figsize=(12, 8))
    plt.rc("font", size=14)

    # To restore defaults, run `mpl.rcdefaults()`.
    # For nice plots, use `plt.style.use(['classic','ggplot'])`.

    from enum import Enum

    class ZenburnColors(Enum):
        RED = "#A55D5D"
        GREEN = "#466F46"
        BLUE = "#4A7274"
        ORANGE = "#A35E2E"
        BLACK = "#3F3F3F"
        DARK_GREY = "#6F6F6F"
        GREY = "#9F9F9F"
        LIGHT_GREY = "#CFCFCF"

    # there's a nicer way to do this, but whatever
    # General Settings
    mpl.rcParams["legend.loc"] = "best"
    mpl.rcParams["axes.titlesize"] = "18"
    mpl.rcParams["figure.figsize"] = [8, 6]
    mpl.rcParams["axes.grid"] = True
    mpl.rcParams["axes.labelsize"] = "14"

    # Zenburn Color Settings
    mpl.rcParams["text.color"] = "white"
    mpl.rcParams["legend.facecolor"] = ZenburnColors.GREY
    mpl.rcParams["legend.fancybox"] = True
    mpl.rcParams["lines.color"] = ZenburnColors.BLACK
    mpl.rcParams["axes.prop_cycle"] = cycler(
        "color",
        [
            ZenburnColors.RED,
            ZenburnColors.GREEN,
            ZenburnColors.BLUE,
            ZenburnColors.ORANGE,
            ZenburnColors.BLACK,
        ],
    )
    mpl.rcParams["patch.facecolor"] = ZenburnColors.GREEN
    mpl.rcParams["axes.facecolor"] = ZenburnColors.LIGHT_GREY
    mpl.rcParams["axes.labelcolor"] = "white"
    mpl.rcParams["xtick.color"] = ZenburnColors.LIGHT_GREY
    mpl.rcParams["ytick.color"] = ZenburnColors.LIGHT_GREY

    ###############################
    ### Change seaborn defaults ###
    ###############################

    # right now, we can't do this. It results in an ImportError, because
    # "python is not installed as a framework." So...

    import seaborn as sns

    # modify axes style
    sns.set_style(
        {
            "axes.edgecolor": ZenburnColors.BLACK,
            "axes.facecolor": ZenburnColors.LIGHT_GREY,
            "figure.facecolor": ZenburnColors.BLACK,
            "axes.labelcolor": ZenburnColors.LIGHT_GREY,
            "ytick.color": ZenburnColors.LIGHT_GREY,
            "xtick.color": ZenburnColors.LIGHT_GREY,
            "grid.color": ZenburnColors.GREY
            #    'legend.color' : ZenburnColors.GREY
        }
    )

    # change color palette for plotting
    sns.set_palette(
        [
            ZenburnColors.RED,
            ZenburnColors.GREEN,
            ZenburnColors.BLUE,
            ZenburnColors.ORANGE,
            ZenburnColors.BLACK,
        ]
    )

    if log_info:
        #######################################
        ### Print message informing imports ###
        #######################################

        print("")
        print("Plots have been zenburned!")


# change the plotstyle when you're running shit locally
zenburn_plots(log_info=False)
