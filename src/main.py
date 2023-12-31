# main file component
# This file is the main file of the project. It contains the main function
# This file will distribute the work to other files
# first thing is to check the given config file and load it
# based on config file, it will make the necessary calls to other files and make folders for the output files
import os
from pathlib import Path
import sys
from utils.singleton.location import Location
from utils.singleton.logger import get_logger
from utils.registry import Registry
#add argument parser
from argparse import ArgumentParser

Location(root=os.path.dirname(os.path.abspath(__file__)))
logger = get_logger()
# set the location of the src folder
# check if the data folder exists
if not os.path.isdir("data"):
    logger.error(
        "Data folder not found. Please make sure it exists in src/data"
    )
    sys.exit(1)

logger.info("Start of gh-pages build")

data_path = Path(Location().get_location()) / "data"

#parse first argument as base_uri
parser = ArgumentParser()
parser.add_argument("base_uri", help="base uri of the registry")
base_uri = parser.parse_args().base_uri
logger.info("Base URI: {}".format(base_uri))

registry = Registry(data_path=data_path, base=str(base_uri))
registry.build()
registry.report()
