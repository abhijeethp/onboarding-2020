import json
import sys

with open('temp.json') as json_file:
    data = json.load(json_file)
    print(data[sys.argv[1]])