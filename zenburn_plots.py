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

def zenburn_plots():

    import matplotlib as mpl
    from cycler import cycler
    # import seaborn as sns
    
    # To restore defaults, run `mpl.rcdefaults()`.
    # For nice plots, use `plt.style.use(['classic','ggplot'])`.

    # colors used for plotting (zenburn styled)
    red,green,blue,orange = '#A55D5D', '#466F46','#4A7274','#A35E2E'
    black,d_gray,l_gray,ll_gray = '#3F3F3F','#6F6F6F','#9F9F9F','#CFCFCF'

    # there's a nicer way to do this, but whatever
    # General Settings
    mpl.rcParams['legend.loc'] = 'best'
    mpl.rcParams['axes.titlesize'] = '18'
    mpl.rcParams['figure.figsize'] = [8,6]
    mpl.rcParams['axes.grid'] = True
    mpl.rcParams['axes.labelsize'] = '14'
    
    # Zenburn Color Settings
    mpl.rcParams['text.color'] = 'white'
    mpl.rcParams['legend.facecolor'] = l_gray
    mpl.rcParams['legend.fancybox'] = True
    mpl.rcParams['lines.color'] = black
    mpl.rcParams['axes.prop_cycle'] = cycler('color',
                                             [red,green,blue,
                                              orange,black])
    mpl.rcParams['patch.facecolor'] = green
    mpl.rcParams['axes.facecolor'] = ll_gray
    mpl.rcParams['axes.labelcolor'] = 'white'
    mpl.rcParams['xtick.color'] = ll_gray
    mpl.rcParams['ytick.color'] = ll_gray


    ###############################
    ### Change seaborn defaults ###
    ###############################
    
    # # modify axes style
    # sns.set_style({
    #     'axes.edgecolor': black,
    #     'axes.facecolor': ll_gray,
    #     'figure.facecolor' : black,
    #     'axes.labelcolor' : ll_gray,
    #     'ytick.color' : ll_gray,
    #     'xtick.color' : ll_gray,
    #     'grid.color' : l_gray
    #     #    'legend.color' : l_gray
    # })

    # # change color palette for plotting
    # sns.set_palette([red,green,blue,orange,black])


    #######################################
    ### Print message informing imports ###
    #######################################

    print('')
    print('Plots have been zenburned!')
