import boto3
from spot_lib import get_all_spot_data, get_cheapest_instances

number_of_spot_instances_to_graph = 20
data_directory = 'accelerated_computing_instance_spot_data'
operating_systems = ['Linux/UNIX (Amazon VPC)']
accelerated_computing_instance_types = [
    'g5g.xlarge', 'g5g.2xlarge', 'g5g.4xlarge', 'g5g.8xlarge', 'g5g.16xlarge', 'g5g.metal',
    'g5.xlarge', 'g5.2xlarge', 'g5.4xlarge', 'g5.8xlarge', 'g5.16xlarge', 'g5.12xlarge', 'g5.24xlarge', 'g5.48xlarge',
    'g4dn.xlarge', 'g4dn.2xlarge', 'g4dn.4xlarge', 'g4dn.8xlarge', 'g4dn.16xlarge', 'g4dn.12xlarge', 'g4dn.metal',
    'g4ad.xlarge', 'g4ad.2xlarge', 'g4ad.4xlarge', 'g4ad.8xlarge', 'g4ad.16xlarge',
    'g3s.xlarge', 'g3.4xlarge', 'g3.8xlarge', 'g3.16xlarge',
    'trn1.2xlarge', 'trn1.32xlarge', 'trn1n.32xlarge',
    'inf1.xlarge', 'inf1.2xlarge', 'inf1.6xlarge', 'inf1.24xlarge',
    'inf2.xlarge', 'inf2.8xlarge', 'inf2.24xlarge', 'inf2.48xlarge'
]

# todo: refactor so you do not need to create a frontend for spot_lib.py for every set of instance types

if __name__ == "__main__":
    session = boto3.Session()
    client = session.client('ec2')
    regions = client.describe_regions(AllRegions=True)
    # Assumes every region is enabled
    spot_data = get_all_spot_data(
        region_names=[region['RegionName'] for region in regions['Regions']],
        instance_types=accelerated_computing_instance_types,
        operating_systems=operating_systems,
        data_directory=data_directory)
    cheapest_instances = get_cheapest_instances(spot_data, number_of_spot_instances_to_graph)
    print(cheapest_instances)
