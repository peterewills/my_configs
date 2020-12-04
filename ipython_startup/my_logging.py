# Pandas throws a future warning with an unbalanced paren, which confuses the shit out
# of my electric-pair mode. So, turn that shit off.
import warnings

warnings.simplefilter(action="ignore", category=FutureWarning)
