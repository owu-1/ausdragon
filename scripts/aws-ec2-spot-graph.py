import boto3
import pandas as pd
import matplotlib.pyplot as plt
import os.path
from pathlib import Path

number_of_spot_instances_to_graph = 11
graph_price_y_limit = 0.10
data_directory = 'aws-ec2-spot-data'
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

def get_region_spot_data(region_name, instance_types, csv_filename):
    session = boto3.Session(region_name=region_name)
    client = session.client('ec2')
    paginator = client.get_paginator('describe_spot_price_history')
    response_iter = paginator.paginate(
        InstanceTypes=instance_types,
        ProductDescriptions=operating_systems
    )
    df_region = pd.DataFrame()
    for page_num, page in enumerate(response_iter):
        print(f"{region_name}: Reading page {page_num}")
        df_page = pd.DataFrame(page['SpotPriceHistory'])
        if df_page.empty:
            print(f'{region_name} was empty')
            continue
        df_page['SpotPrice'] = df_page['SpotPrice'].astype(float)
        df_region = pd.concat([df_region, df_page])
    df_region.to_csv(csv_filename)
    return df_region

def get_all_spot_data(region_names, instance_types):
    Path(data_directory).mkdir(exist_ok=True)
    df = pd.DataFrame()
    for region_name in region_names:
        csv_filename = os.path.join(data_directory, f'{region_name}.csv')
        try:
            df_region = pd.read_csv(csv_filename)
            if df_region.empty:
                print(f'{region_name} was empty')
                continue
            df_region['Timestamp'] = pd.to_datetime(df_region['Timestamp'])
        except FileNotFoundError:
            df_region = get_region_spot_data(region_name, instance_types, csv_filename)
        df = pd.concat([df, df_region])
    return df

def draw_graph(df):
    pd.set_option('display.max_rows', None)
    latest = df[df.groupby(['AvailabilityZone', 'InstanceType'])['Timestamp'].transform('max') == df['Timestamp']]
    latest_rows = latest.sort_values('SpotPrice').head(number_of_spot_instances_to_graph)
    print(latest_rows)
    latest_rows_tuple = [tuple(x) for x in latest_rows[['AvailabilityZone', 'InstanceType']].to_numpy()]
    df = df[[x in latest_rows_tuple for x in [tuple(x) for x in df[['AvailabilityZone', 'InstanceType']].to_numpy()]]]

    df = df.set_index('Timestamp')
    df.groupby(['AvailabilityZone', 'InstanceType'])['SpotPrice'].plot(legend=True, ylim=(0, graph_price_y_limit))
    plt.show()

if __name__ == "__main__":
    session = boto3.Session()
    client = session.client('ec2')
    regions = client.describe_regions(AllRegions=True)
    # Assumes every region is enabled
    spot_data = get_all_spot_data(
        region_names=[region['RegionName'] for region in regions['Regions']],
        instance_types=accelerated_computing_instance_types)
    draw_graph(spot_data)
