import requests 
import json 

username = 'xxxx' #add username
password = 'yyyyy' #add password

# create a crumb token
req = requests.get('http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)', auth=(username,password))
crumb=req.text.split(":")
headers = {crumb[0]: crumb[1]}
params = {'newTokenName': 'portal-dev'}

#generate api token
url = 'http://localhost:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken'
r = requests.post(url, params=params, auth=(username,password), headers=headers, cookies=req.cookies)
data = json.loads(r.text)
print(data['data']['tokenValue'])
