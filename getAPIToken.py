import requests 
import json 

username = 'xxxx' #add username
password = 'yyyyy' #add password

req = requests.get('http://localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)', auth=(username,password))
crumb=req.text.split(":")
headers = {crumb[0]: crumb[1]}
url = 'http://localhost:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken'
payload = {'newTokenName': 'my-token'}

r = requests.post(url, data=json.dumps(payload), auth=(username,password), headers=headers, cookies=req.cookies)
data = json.loads(r.text)
print(data['data']['tokenValue'])
