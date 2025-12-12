import yaml

def read_yaml_file(filename):
    '''
            Loads yaml, and returns config for your country
    '''
    with open(filename) as file:
        cfg = yaml.load(file, Loader=yaml.FullLoader)
    return cfg
