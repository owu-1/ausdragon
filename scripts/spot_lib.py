import boto3
import pandas as pd
import os.path
from pathlib import Path

def get_region_spot_data(region_name, instance_types, operating_systems, csv_filename):
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

def get_all_spot_data(region_names, instance_types, operating_systems, data_directory):
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
            df_region = get_region_spot_data(region_name, instance_types, operating_systems, csv_filename)
        df = pd.concat([df, df_region])
    return df

def get_cheapest_instances(df, number_of_spot_instances_to_graph):
    pd.set_option('display.max_rows', None)
    latest = df[df.groupby(['AvailabilityZone', 'InstanceType'])['Timestamp'].transform('max') == df['Timestamp']]
    return latest.sort_values('SpotPrice').head(number_of_spot_instances_to_graph)
