import json
import time
import csv


json_data = open("basis_short.json")
data = json.load(json_data)
#pprint(data)
start_time = data["starttime"]
end_time = data["endtime"]
steps = data["metrics"]["steps"]["values"]
skin_temp = data["metrics"]["skin_temp"]["values"]
hr = data["metrics"]["heartrate"]["values"]
gsr = data["metrics"]["gsr"]["values"]
cal = data["metrics"]["calories"]["values"]
# air temperature
#at = data["metrics"]["air_temp"]["values"]
body_states = data["bodystates"]

with open('metrics.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(["time", "steps", "skin_temp", "heart_rate", "gsr", "calories"])
    for i in range(len(steps)):
        writer.writerow([time.ctime(int(start_time)+60*i), steps[i], skin_temp[i], hr[i], gsr[i], cal[i]])
   

with open('bodystates.csv', 'wb') as fn:
    writer = csv.writer(fn)
    writer.writerow(["time1", "time2", "bodystate"])
    for st in body_states:
	writer.writerow([time.ctime(int(st[0])), time.ctime(int(st[1])), st[2]])


json_data.close()
