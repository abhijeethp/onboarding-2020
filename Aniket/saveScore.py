import json


t = open("scoretemp.txt","r")
t = t.read()
scores = json.loads(t)
man = scores["man_score"]
mac = scores["machine_score"]

t = open("score.txt","r+")
t.truncate(0)
s = str(man) + " " + str(mac)
t.write(s)
t.close()



