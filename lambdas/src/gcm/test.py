import argparse
import sys

import config
import pandas as pd
import process

# Declare command-line flags.
argparser = argparse.ArgumentParser(add_help=False)
argparser.add_argument(
    'dataset',
    help='The dataset to confirm.')


def main(argv):
    # Retrieve command line arguments.
    parser = argparse.ArgumentParser(
            description=__doc__,
            formatter_class=argparse.RawDescriptionHelpFormatter,
            parents=[argparser])
    flags = parser.parse_args(argv[1:])

    dataset = flags.dataset
    dataset_path = config.get_curated_dataset_path(dataset)

    parq = pd.read_parquet(path=dataset_path, engine='pyarrow')
    print(parq.groupby(process.PARTITION_NAME).size())

    parq.to_csv(dataset_path.parent / (dataset + '.csv'))


if __name__ == '__main__':
    main(sys.argv)
